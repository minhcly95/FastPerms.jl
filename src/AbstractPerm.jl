# The abstract type of all permutation types
abstract type AbstractPerm{N} <: AbstractVector{Int} end

# Degree = number of elements on which the permutation acts
degree(::Type{<:AbstractPerm{N}}) where {N} = N

# Treating permutation as a vector
Base.size(::AbstractPerm{N}) where {N} = (N,)

# Use i^a to apply permutation on the right
Base.@propagate_inbounds Base.:^(i::Integer, a::AbstractPerm) = a[i]

# Use a(i) to apply permutation on the left
Base.@propagate_inbounds (a::AbstractPerm)(i::Integer) = a[i]

# Get all the images as a tuple
@generated function images(a::AbstractPerm{N}) where {N}
    return Expr(:tuple, [:(@inbounds a[$i]) for i in 1:N]...)
end

# Get total number of permutations of N items
num_perms(::Val{1}) = 1
num_perms(::Val{N}) where {N} = num_perms(Val{N-1}()) * N
num_perms(::AbstractPerm{N}) where {N} = num_perms(Val{N}())
num_perms(::Type{<:AbstractPerm{N}}) where {N} = num_perms(Val{N}())

# General multiplication is from left-to-right
Base.:*(a::AbstractPerm, b::AbstractPerm) = *(promote(a,b)...)

# Use composition to multiply from right-to-left
Base.:∘(a::AbstractPerm, b::AbstractPerm) = b * a

# Identity
@generated function identity_perm(type::Type{<:AbstractPerm{N}}) where {N}
    id_tuple = Tuple(1:N)
    return quote
        return @inbounds type($id_tuple)
    end
end
identity_perm(a::AbstractPerm) = identity_perm(typeof(a))

Base.one(type::Type{<:AbstractPerm}) = identity_perm(type)
Base.one(a::AbstractPerm) = identity_perm(a)

# Conjugate a^b = inv(b) * a * b
Base.conj(a::AbstractPerm, b::AbstractPerm) = inv(b) * a * b
Base.:^(a::AbstractPerm, b::AbstractPerm) = conj(a, b)

# Power
Base.:^(a::AbstractPerm, p::Integer) = p >= 0 ? Base.power_by_squaring(a, p) : Base.power_by_squaring(inv(a), -p)

Base.literal_pow(::typeof(^), a::AbstractPerm, ::Val{-3}) = inv(a*a*a)
Base.literal_pow(::typeof(^), a::AbstractPerm, ::Val{-2}) = inv(a*a)
Base.literal_pow(::typeof(^), a::AbstractPerm, ::Val{-1}) = inv(a)
Base.literal_pow(::typeof(^), a::AbstractPerm, ::Val{0}) = identity_perm(a)
Base.literal_pow(::typeof(^), a::AbstractPerm, ::Val{1}) = a
Base.literal_pow(::typeof(^), a::AbstractPerm, ::Val{2}) = a*a
Base.literal_pow(::typeof(^), a::AbstractPerm, ::Val{3}) = a*a*a

