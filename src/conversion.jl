# Convert any Perm{M} to an SPerm{N}
# Only possible if N >= M
@generated function Base.convert(::Type{SPerm{N,T}}, a::AbstractPerm{M}) where {N,M,T}
    if M > N
        throw(ArgumentError("cannot convert $a to a lower degree permutation"))
    else
        return :(return @inbounds SPerm{N,Int}(a))
    end
end
Base.convert(::Type{SPerm{N,T}}, a::SPerm{N,T}) where {N,T} = a

# Convert any Perm{M} to an CPerm{N}
# Only possible if N >= M and N <= CPERM_MAX_N
@generated function Base.convert(::Type{CPerm{N}}, a::AbstractPerm{M}) where {N,M}
    if N > CPERM_MAX_N
        throw(ArgumentError("CPerm{N} does not support N > $CPERM_MAX_N"))
    elseif M > N
        throw(ArgumentError("cannot convert $a to a lower degree permutation"))
    else
        return :(return @inbounds CPerm{N}(a))
    end
end
Base.convert(::Type{CPerm{N}}, a::CPerm{N}) where {N} = a

# Convert any Perm{M} to an LPerm{N}
# Only possible if N >= M and N <= LPERM_MAX_N
@generated function Base.convert(::Type{LPerm{N}}, a::AbstractPerm{M}) where {N,M}
    if N > LPERM_MAX_N
        throw(ArgumentError("LPerm{N} does not support N > $LPERM_MAX_N"))
    elseif M > N
        throw(ArgumentError("cannot convert $a to a lower degree permutation"))
    else
        return :(return @inbounds LPerm{N}(a))
    end
end
Base.convert(::Type{LPerm{N}}, a::LPerm{N}) where {N} = a
