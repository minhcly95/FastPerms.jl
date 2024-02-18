Base.promote_rule(::Type{SPerm{N,T}}, ::Type{SPerm{M,S}}) where {N,M,T,S} = SPerm{max(M, N),promote_type(T, S)}
Base.promote_rule(::Type{CPerm{N}}, ::Type{CPerm{N}}) where {N} = CPerm{N}
Base.promote_rule(::Type{LPerm{N}}, ::Type{LPerm{N}}) where {N} = LPerm{N}

# Promote every other case to SPerm
Base.promote_rule(::Type{<:AbstractPerm{N}}, ::Type{<:AbstractPerm{M}}) where {N,M} = SPerm{max(M, N),Int}
