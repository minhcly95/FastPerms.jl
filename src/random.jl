function Random.rand(rng::AbstractRNG, ::Random.SamplerType{P}) where {P<:AbstractPerm}
    return @inbounds P(shuffle(rng, UnitRange(1:length(P))))
end

function Random.rand(rng::AbstractRNG, ::Random.SamplerType{SPerm{N}}) where {N}
    return rand(rng, SPerm{N,Int})
end
