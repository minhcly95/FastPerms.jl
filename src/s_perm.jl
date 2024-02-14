# Permutation stored as a static array (a tuple)
# Tuples are stack-allocated, which is extremely fast in Julia.
struct SPerm{N,T} <: AbstractPerm{N,T}
    images::NTuple{N,T}

    function SPerm{N,T}(images::NTuple{N,T}) where {N,T}
        @boundscheck check_valid_image(images)
        new{N,T}(images)
    end
end

# Constructors
Base.@propagate_inbounds SPerm(images::NTuple{N,T}) where {N,T} = SPerm{N,T}(images)
Base.@propagate_inbounds SPerm(images::Integer...) = SPerm(tuple(images...))
Base.@propagate_inbounds SPerm(images::AbstractArray) = SPerm(Tuple(images))

SPerm{N,T}() where {N,T} = identity_perm(SPerm{N,T})

# Get image
Base.@propagate_inbounds Base.getindex(a::SPerm, i) = a.images[i]

# Multiply from left to right (the left permutation applies first)
@generated function Base.:*(a::SPerm{N,T}, b::SPerm{N,T}) where {N,T}
    # The implementation of the function depends on N,
    # which is only available for @generated functions.
    if N < 32
        # Initialize tuple with generator is faster but limit to N < 32
        return :(_mul_collect(a,b))
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

# Random
function Random.rand(rng::AbstractRNG, ::Random.SamplerType{SPerm{N,T}}) where {N,T}
    return @inbounds SPerm(shuffle(rng, UnitRange{T}(1:N)))
end

function Random.rand(rng::AbstractRNG, ::Random.SamplerType{SPerm{N}}) where {N}
    return rand(rng, SPerm{N,Int})
end

