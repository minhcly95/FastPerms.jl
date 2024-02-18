@testset "General operations" begin
    perm_types = [
        [SPerm{N,T} for N in [4, 8, 16, 32, 64, 128], T in [Int, UInt8]]...,
        [CPerm{N} for N in [4, 8, 12, 16]]...,
        [LPerm{N} for N in [2, 3, 4, 5]]...
    ]
    NSAMPLES = 10

    for P in perm_types
        @testset "$P" begin
            N, T = degree(P), eltype(P)

            # Random permutations to test
            As = rand(P, NSAMPLES)
            Bs = rand(P, NSAMPLES)

            # Identity
            @test identity_perm(P) == 1:N
            @test identity_perm(As[1]) == 1:N
            @test one(P) == 1:N
            @test one(Bs[1]) == 1:N

            # Invalid bound check
            # (0,...,0) is not a permutation
            @test_throws ArgumentError P(zeros(T, N))
            # (1,...,1) is not a permutation
            @test_throws ArgumentError P(ones(T, N))
            # Non-injective image
            @test_throws ArgumentError P([1, 1, 3:N...])

            # Valid bound check
            # Identity is valid
            @test P(one(P)) isa Any
            for a in As
                # Every random perm is valid
                @test P(a) isa Any
            end

            # Get image
            for a in As
                img = collect(a)
                @test img == [a(i) for i in 1:N]
            end

            # Multiplication and Composition
            for (a, b) in zip(As, Bs)
                @test a * b == [b(a(i)) for i in 1:N]
                @test b * a == [a(b(i)) for i in 1:N]
                @test b ∘ a == a * b
                @test a ∘ b == b * a
                @test a * one(P) == a
                @test one(P) * a == a
            end

            # Inverse
            for (a, b) in zip(As, Bs)
                @test a * inv(a) == one(P)
                @test inv(a) * a == one(P)
                @test inv(a * b) == inv(b) * inv(a)
                @test inv(b * a) == inv(a) * inv(b)
            end

            # Conjugate
            for (a, b) in zip(As, Bs)
                @test conj(a, b) == b * a * inv(b)
                @test conj(b, a) == a * b * inv(a)
                @test conj(conj(a, b), inv(b)) == a
                @test conj(a, b) * conj(inv(a), b) == one(P)
            end

            # Power
            for a in As
                @test a^0 == one(P)
                @test a^1 == a
                @test a^2 == a * a
                @test a^3 == a * a * a
                @test a^(-1) == inv(a)
                @test a^(-2) == inv(a) * inv(a)
            end
        end
    end
end
