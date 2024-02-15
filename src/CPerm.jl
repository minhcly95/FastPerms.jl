# Permutation stored as an UInt in a compact way.
# Each image is stored in 4-bit (0-15) and is manipulated using bitwise operators.
# C in CPerm stands for "Compact".
struct CPerm{N} <: AbstractPerm{N,Int}
    data::UInt64

    function CPerm{N}(images::NTuple{N}) where {N}
        @boundscheck check_valid_image(images)
        new{N}(_compactify(images))
    end
end

# Convert a tuple into an UInt64
# We store the images in the order [15, 14, ..., 2, 1, 16] (MSB first)
# because Julia indices start from 1.
@generated function _compactify(images::NTuple{N}) where {N}
    if N > 16
        throw(ArgumentError("CPerm{N} does not support N > 16"))
    else
        exprs = vcat(:(a = UInt64(0)), (:(a |= images[$i] & 0xf; a <<= 4) for i in min(N, 15):-1:1)...)
        (N == 16) && push!(exprs, :(a |= images[16] & 0xf))
        return Expr(:block, exprs...)
    end
end

# Make CPerm in an unsafe way
function _make_cperm_unsafe(data::UInt64, ::Val{N}) where {N}
    ref = Ref{CPerm{N}}()
    GC.@preserve ref unsafe_store!(Base.unsafe_convert(Ptr{UInt64}, pointer_from_objref(ref)), data)
    return ref[]
end

# Constructor
Base.@propagate_inbounds CPerm{N}(images::Integer...) where {N} = CPerm{N}(tuple(images...))
Base.@propagate_inbounds CPerm{N}(images::AbstractArray) where {N} = CPerm{N}(Tuple(images))

Base.@propagate_inbounds CPerm(images::NTuple{N}) where {N} = CPerm{N}(images)
Base.@propagate_inbounds CPerm(images::Integer...) = CPerm(tuple(images...))
Base.@propagate_inbounds CPerm(images::AbstractArray) = CPerm(Tuple(images))

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

        return _make_cperm_unsafe(cc, Val{$N}())
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

        return _make_cperm_unsafe(cc, Val{$N}())
    end
end

