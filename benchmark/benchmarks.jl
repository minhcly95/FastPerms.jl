using FastPerms
using BenchmarkTools

SUITE = BenchmarkGroup()

for N in [4, 8, 12, 16, 24, 32, 48, 64, 128], T in [Int, UInt8]
    S = SPerm{N,T}
    SUITE["$S"] = BenchmarkGroup(["SPerm", N, T])
    SUITE["$S"]["mul"] = @benchmarkable a * b setup = (a = rand($S); b = rand($S))
    SUITE["$S"]["inv"] = @benchmarkable inv(a) setup = (a = rand($S))
end

for N in [4, 8, 12, 16]
    C = CPerm{N}
    SUITE["$C"] = BenchmarkGroup(["CPerm", N])
    SUITE["$C"]["mul"] = @benchmarkable a * b setup = (a = rand($C); b = rand($C))
    SUITE["$C"]["inv"] = @benchmarkable inv(a) setup = (a = rand($C))
end

for N in [3, 4, 5]
    L = LPerm{N}
    SUITE["$L"] = BenchmarkGroup(["LPerm", N])
    SUITE["$L"]["mul"] = @benchmarkable a * b setup = (a = rand($L); b = rand($L))
    SUITE["$L"]["inv"] = @benchmarkable inv(a) setup = (a = rand($L))
end
