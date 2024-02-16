# Limit N up to 5 (otherwise the lookup table is too large).
const LPERM_MAX_N = 5

# Permutation where mul and inv are done via lookup tables.
# L in LPerm stands for "Lookup".
struct LPerm{N} <: AbstractPerm{N,Int}
    data::UInt8

    function LPerm(::Val{N}, data::Integer) where {N}
        @boundscheck begin
            M = num_perms(Val{N}())
            data in 1:M || throw(ArgumentError("index out of range (must be in 1:$M)"))
        end
        new{N}(data & 0xff)
    end
end

# Make tables to convert tuples to data and vice-versa.
# We only need a pair of tables for all LPerm{N} if we organize the perms as follows:
# 1-perm, rest of 2-perms, rest of 3-perms, etc.
function _make_lperm_tuple_tables()
    all_perms = _generate_all_perms(LPERM_MAX_N)
    lperm_to_tuple = all_perms
    tuple_to_lperm = zeros(UInt8, LPERM_MAX_N^LPERM_MAX_N)

    for (data, perm) in enumerate(all_perms)
        hash = _lperm_encode(perm)
        tuple_to_lperm[hash] = data
    end

    return NTuple{5,UInt8}.(lperm_to_tuple), tuple_to_lperm
end

# Convert an NTuple to a linear index (1-based)
@generated function _lperm_encode(images::NTuple{N}) where {N}
    # Encode (a,b,c,d,e) -> a + (b-1)*5^1 + (c-1)*5^2 + (d-1)*5^3 + (e-1)*5^4
    ex = :(images[1])
    for i in 2:LPERM_MAX_N
        if i <= N
            ex = :((images[$i] - 1) * $(5^(i - 1)) + $ex)
        else
            # If N < 5, then we pad the permutation.
            # For example, (a,b,c) -> (a,b,c,4,5)
            ex = :($ex + $((i - 1) * 5^(i - 1)))
        end
    end
    return ex
end

# Loopup tables to convert to tuples
const LPERM_TO_TUPLE, TUPLE_TO_LPERM = Tuple.(_make_lperm_tuple_tables())

# Constructors
@generated function LPerm{N}(images::NTuple{N}) where {N}
    if N > LPERM_MAX_N
        throw(ArgumentError("LPerm{N} does not support N > $LPERM_MAX_N"))
    else
        return quote
            @boundscheck check_valid_image(images)
            hash = _lperm_encode(images)
            return @inbounds LPerm(Val{N}(), TUPLE_TO_LPERM[hash])
        end
    end
end

Base.@propagate_inbounds LPerm{N}(images::Integer...) where {N} = LPerm{N}(tuple(images...))
Base.@propagate_inbounds LPerm{N}(images::AbstractArray) where {N} = LPerm{N}(Tuple(images))

Base.@propagate_inbounds LPerm(images::NTuple{N}) where {N} = LPerm{N}(images)
Base.@propagate_inbounds LPerm(images::Integer...) = LPerm(tuple(images...))
Base.@propagate_inbounds LPerm(images::AbstractArray) = LPerm(Tuple(images))

# The identity of LPerm{N} is always 1
identity_perm(::Type{LPerm{N}}) where {N} = @inbounds LPerm(Val{N}(), 1)
LPerm{N}() where {N} = identity_perm(LPerm{N})

# Get image
function Base.getindex(a::LPerm{N}, i::Integer) where {N}
    @boundscheck i in 1:N || throw(ArgumentError("index [$i] is out of bound (1:$N)"))
    return @inbounds convert(Int, LPERM_TO_TUPLE[a.data][i])
end

# Make multiplication and inversion tables
function _make_lperm_mul_inv_tables()
    N = LPERM_MAX_N
    M = num_perms(Val{N}())
    all_perms = SPerm.(LPerm.(Val{N}(), 1:M))
    mul_table = Matrix{UInt8}(UndefInitializer(), M, M)

    # We use SPerm to calculate the product,
    # then convert it back to LPerm.
    for i in 1:M, j in 1:M
        k = LPerm(all_perms[i] * all_perms[j]).data
        mul_table[i, j] = k
    end

    # We search for the identity in each column of the mul table
    # to determine the inverse.
    inv_table = UInt8[findfirst(==(1), col) for col in eachcol(mul_table)]

    return mul_table, inv_table
end

# Loopup tables for multiplication and inversion
const LPERM_MUL, LPERM_INV = Tuple.(_make_lperm_mul_inv_tables())

# Multiply from left to right (the left permutation applies first)
function Base.:*(a::LPerm{N}, b::LPerm{N}) where {N}
    # Just look it up in the table
    M = num_perms(Val{LPERM_MAX_N}())
    ind = Base._sub2ind((M,M), a.data, b.data)
    return @inbounds LPerm(Val{N}(), LPERM_MUL[ind])
end

# Inverse
function Base.:inv(a::LPerm{N}) where {N}
    # Just look it up in the table
    return @inbounds LPerm(Val{N}(), LPERM_INV[a.data])
end

