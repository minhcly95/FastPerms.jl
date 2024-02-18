# Permutation stored as a static array (a tuple)
# Tuples are stack-allocated, which is extremely fast in Julia.
using Base: InterpreterIP
struct SPerm{N,T} <: AbstractPerm{N}
    images::NTuple{N,T}

    function SPerm(::Val{N}, ::Type{T}, images::NTuple{N,T}) where {N,T}
        @boundscheck check_valid_image(images)
        new{N,T}(images)
    end
end

# Constructors
@generated function SPerm(::Val{N}, ::Type{T}, images::NTuple{M,T}) where {N,M,T}
    check_expr = :(@boundscheck check_valid_image(images))
    if M >= N
        # Given image has same or more elements: construct an SPerm{M,T} (ignore N)
        return :($check_expr; return @inbounds SPerm(Val{$M}(), $T, images))
    else
        # Given image has fewer elements: pad missing elements
        return :($check_expr; return @inbounds SPerm(Val{$N}(), $T, (images..., $(UnitRange{T}(M + 1, N))...)))
    end
end

Base.@propagate_inbounds SPerm(::Val{N}, ::Type{T}, images::NTuple{M}) where {N,M,T} = SPerm(Val{N}(), T, NTuple{M,T}(images))
Base.@propagate_inbounds SPerm(::Val{N}, ::Type{T}, images::Integer...) where {N,T} = SPerm(Val{N}(), T, Tuple(images))
Base.@propagate_inbounds SPerm(::Val{N}, ::Type{T}, images::AbstractArray) where {N,T} = SPerm(Val{N}(), T, Tuple(images))
SPerm(::Val{N}, ::Type{T}, perm::AbstractPerm) where {N,T} = @inbounds SPerm(Val{N}(), T, images(perm))

Base.@propagate_inbounds SPerm{N,T}(images...) where {N,T} = SPerm(Val{N}(), T, images...)
Base.@propagate_inbounds SPerm{N}(images...) where {N} = SPerm(Val{N}(), Int, images...)

Base.@propagate_inbounds SPerm(images::NTuple{N}) where {N} = SPerm(Val{N}(), Int, images)
Base.@propagate_inbounds SPerm(images::Integer...) = SPerm(Tuple(images))
Base.@propagate_inbounds SPerm(images::AbstractArray) = SPerm(Tuple(images))
SPerm(perm::AbstractPerm) = @inbounds SPerm(images(perm))

SPerm{N,T}() where {N,T} = identity_perm(SPerm{N,T})
SPerm{N}() where {N} = identity_perm(SPerm{N,Int})

# Get image
Base.@propagate_inbounds Base.getindex(a::SPerm, i) = convert(Int, a.images[i])

# Multiply from left to right (the left permutation applies first)
@generated function Base.:*(a::SPerm{N,T}, b::SPerm{N,T}) where {N,T}
    # The implementation of the function depends on N,
    # which is only available for @generated functions.
    if N < 32
        # Initialize tuple with generator is faster but limit to N < 32
        return :(_mul_collect(a, b))
    else
        # Warning: unsafe code (for the sake of performance)
        store_exprs = [:(unsafe_store!(ptr, convert($T, @inbounds b[a[$i]]), $i)) for i in 1:N]
        store_block = Expr(:block, store_exprs...)

        return quote
            # Create a pointer to a mutable object (Ref)
            c = Ref{SPerm{N,T}}()
            ptr = Base.unsafe_convert(Ptr{T}, pointer_from_objref(c))
            # Map i -> image of b[a[i]]
            GC.@preserve c $store_block
            # Since c doesn't exit the function (its content does),
            # Julia doesn't allocate heap memory for c
            return c[]
        end
    end
end

_mul_collect(a::SPerm{N,T}, b::SPerm{N,T}) where {N,T} = @inbounds SPerm(NTuple{N,T}(@inbounds b[a[i]] for i in 1:N))

# Inverse
@generated function Base.inv(a::SPerm{N,T}) where {N,T}
    # The implementation of the function depends on N,
    # which is only available for @generated functions.

    # Warning: unsafe code (for the sake of performance)
    store_exprs = [:(unsafe_store!(ptr, convert($T, $i), @inbounds a[$i])) for i in 1:N]
    store_block = Expr(:block, store_exprs...)

    return quote
        # Create a pointer to a mutable object (Ref)
        b = Ref{SPerm{N,T}}()
        ptr = Base.unsafe_convert(Ptr{T}, pointer_from_objref(b))
        # Map domain of a -> image of b
        GC.@preserve b $store_block
        # Since b doesn't exit the function (its content does),
        # Julia doesn't allocate heap memory for b
        return b[]
    end
end

