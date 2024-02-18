# Limit N up to 16
const CPERM_MAX_N = 16

# Permutation stored as an UInt in a compact way.
# Each image is stored in 4-bit (0-15) and is manipulated using bitwise operators.
# C in CPerm stands for "Compact".
struct CPerm{N} <: AbstractPerm{N}
    data::UInt64

    # Special constructor to distinguish from the outer constructors
    # Warning: unsafe (there is no check)
    function CPerm(::Val{N}, ::Val{false}, data::UInt64) where {N}
        new{N}(data)
    end
end

# Convert a tuple into an UInt64
# We store the images in the order [15, 14, ..., 2, 1, 16] (MSB first)
# because Julia indices start from 1.
@generated function _compactify(images::NTuple{N}) where {N}
    if N > CPERM_MAX_N
        throw(ArgumentError("CPerm{N} does not support N > $CPERM_MAX_N"))
    else
        exprs = vcat(:(a = UInt64(0)), (:(a |= images[$i] & 0xf; a <<= 4) for i in min(N, 15):-1:1)...)
        (N == 16) && push!(exprs, :(a |= images[16] & 0xf))
        return Expr(:block, exprs...)
    end
end

# Constructor
@generated function CPerm(::Val{N}, images::NTuple{M}) where {N,M}
    check_expr = :(@boundscheck check_valid_image(images))
    if M > CPERM_MAX_N
        # Return an SPerm{M} if there are too many elements
        return :($check_expr; return SPerm{N}(images))
    elseif M == N
        # Real constructor
        return quote
            $check_expr
            data = _compactify(images)
            # Call the inner constructor
            return CPerm(Val{$N}(), Val{false}(), data)
        end
    elseif M > N
        # Given image has same or more elements: construct an CPerm{M} (ignore N)
        return :($check_expr; return @inbounds CPerm(Val{$M}(), images))
    else
        # Given image has fewer elements: pad missing elements
        return :($check_expr; return @inbounds CPerm(Val{$N}(), (images..., $(M+1:N)...)))
    end
end
Base.@propagate_inbounds CPerm(::Val{N}, images::Integer...) where {N} = CPerm(Val{N}(), Tuple(images))
Base.@propagate_inbounds CPerm(::Val{N}, images::AbstractArray) where {N} = CPerm(Val{N}(), Tuple(images))
CPerm(::Val{N}, perm::AbstractPerm) where {N} = @inbounds CPerm(Val{N}(), images(perm))

Base.@propagate_inbounds CPerm{N}(images...) where {N} = CPerm(Val{N}(), images...)

Base.@propagate_inbounds CPerm(images::NTuple{N}) where {N} = CPerm(Val{N}(), images)
Base.@propagate_inbounds CPerm(images::Integer...) = CPerm(Tuple(images))
Base.@propagate_inbounds CPerm(images::AbstractArray) = CPerm(Tuple(images))
CPerm(perm::AbstractPerm) = @inbounds CPerm(images(perm))

CPerm{N}() where {N} = identity_perm(CPerm{N})

# Get image
function Base.getindex(a::CPerm{N}, i::Integer) where {N}
    @boundscheck i in 1:N || throw(ArgumentError("index [$i] is out of bound (1:$N)"))
    # "& 63" at the end to hint Julia that shift is in the correct range
    shift = (i * 4) & 63
    val = (a.data >> shift) & 0xf
    return val == 0 ? 16 : convert(Int, val)
end

# Multiply from left to right (the left permutation applies first)
@generated function Base.:*(a::CPerm{N}, b::CPerm{N}) where {N}
    # The implementation of the function depends on N,
    # which is only available for @generated functions.
    range = N == 16 ? (0:N-1) : (1:N)
    store_exprs = [
        quote
            j = aa & 0xf            # j = a[i]
            k = (bb >> 4j) & 0xf    # k = b[j] = b[a[i]]
            cc |= k << $(4i)        # c[i] = k = b[a[i]]
            aa >>= 4
        end for i in range
    ]
    store_block = Expr(:block, store_exprs...)
    return quote
        # If N < 16, we start from bit 4.
        # If N = 16, we start from bit 0.
        aa = $(N == 16 ? :(a.data) : :(a.data >> 4))
        bb = b.data
        cc = UInt64(0)

        $store_block

        return CPerm(Val{$N}(), Val{false}(), cc)
    end
end

# Inverse
@generated function Base.inv(a::CPerm{N}) where {N}
    # The implementation of the function depends on N,
    # which is only available for @generated functions.
    range = N == 16 ? (0:N-1) : (1:N)
    store_exprs = [
        quote
            j = aa & 0xf        # j = a[i]
            cc |= $i << 4j      # c[j] = i
            aa >>= 4
        end for i in range
    ]
    store_block = Expr(:block, store_exprs...)
    return quote
        # If N < 16, we start from bit 4.
        # If N = 16, we start from bit 0.
        aa = $(N == 16 ? :(a.data) : :(a.data >> 4))
        cc = UInt64(0)

        $store_block

        return CPerm(Val{$N}(), Val{false}(), cc)
    end
end

