using FastPerms
using Test

@testset "FastPerms.jl" begin
    include("general_ops.jl")
    include("conversion.jl")
    include("cycle.jl")
end
