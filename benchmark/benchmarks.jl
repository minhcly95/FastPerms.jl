using FastPerms
using BenchmarkTools

SUITE = BenchmarkGroup()

SUITE["SPerm"] = BenchmarkGroup()
for N in [4, 8, 16, 32, 64, 128], T in [Int, UInt8]
    S = SPerm{N,T}
    SUITE["SPerm"]["$S"] = BenchmarkGroup()
    SUITE["SPerm"]["$S"]["mul"] = @benchmarkable a * b setup=(a=rand($S);b=rand($S))
    SUITE["SPerm"]["$S"]["inv"] = @benchmarkable inv(a) setup=(a=rand($S))
end

