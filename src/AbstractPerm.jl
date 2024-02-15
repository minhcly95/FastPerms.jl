# The abstract type of all permutation types
abstract type AbstractPerm{N,T} <: AbstractVector{T} end

# Static information
Base.length(::Type{<:AbstractPerm{N}}) where {N} = N

# Treating permutation as a vector
Base.size(::AbstractPerm{N,T}) where {N,T} = (N,)

# Treating permutation as a function
Base.@propagate_inbounds (a::AbstractPerm)(i::Integer) = a[i]

# Use composition to multiply from right-to-left
Base.:∘(a::AbstractPerm, b::AbstractPerm) = b * a

# Identity
@generated function identity_perm(type::Type{<:AbstractPerm{N,T}}) where {N,T}
    id_tuple = Expr(:tuple, UnitRange{T}(1,N)...)
    return quote
        return @inbounds type($id_tuple)
    end
end
identity_perm(a::AbstractPerm) = identity_perm(typeof(a))

Base.one(type::Type{<:AbstractPerm}) = identity_perm(type)
Base.one(a::AbstractPerm) = identity_perm(a)

# Conjugate b * a * inv(b)
Base.conj(a::AbstractPerm, b::AbstractPerm) = b * a * inv(b)

# Power
Base.:^(a::AbstractPerm, p::Integer) = p >= 0 ? Base.power_by_squaring(a, p) : Base.power_by_squaring(inv(a), -p)

Base.literal_pow(::typeof(^), a::AbstractPerm, ::Val{-3}) = inv(a*a*a)
Base.literal_pow(::typeof(^), a::AbstractPerm, ::Val{-2}) = inv(a*a)
Base.literal_pow(::typeof(^), a::AbstractPerm, ::Val{-1}) = inv(a)
Base.literal_pow(::typeof(^), a::AbstractPerm, ::Val{0}) = identity_perm(a)
Base.literal_pow(::typeof(^), a::AbstractPerm, ::Val{1}) = a
Base.literal_pow(::typeof(^), a::AbstractPerm, ::Val{2}) = a*a
Base.literal_pow(::typeof(^), a::AbstractPerm, ::Val{3}) = a*a*a

