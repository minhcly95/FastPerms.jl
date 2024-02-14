@testset "SPerm" begin
    for N in [4, 8, 16, 32, 64, 128], T in [Int, UInt8]
        # Test for various parameters of N and T
        S = SPerm{N,T}
        @testset "$S" begin
            NSAMPLES = 10

            # Random permutations to test
            As = rand(S, NSAMPLES)
            Bs = rand(S, NSAMPLES)

            # Identity
            @test identity_perm(S) == 1:N
            @test identity_perm(As[1]) == 1:N
            @test one(S) == 1:N
            @test one(Bs[1]) == 1:N

            # Invalid bound check
            # (0,...,0) is not a permutation
            @test_throws ArgumentError S(zeros(T, N))
            # (1,...,1) is not a permutation
            @test_throws ArgumentError S(ones(T, N))
            # Non-injective image
            @test_throws ArgumentError S([1,1,3:N...])

            # Valid bound check
            # Identity is valid
            @test S(one(S)) isa Any
            for a in As
                # Every random perm is valid
                @test S(a) isa Any
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
                @test a * one(S) == a
                @test one(S) * a == a
            end

            # Inverse
            for (a, b) in zip(As, Bs)
                @test a * inv(a) == one(S)
                @test inv(a) * a == one(S)
                @test inv(a * b) == inv(b) * inv(a)
                @test inv(b * a) == inv(a) * inv(b)
            end

            # Conjugate
            for (a, b) in zip(As, Bs)
                @test conj(a, b) == b * a * inv(b)
                @test conj(b, a) == a * b * inv(a)
                @test conj(conj(a, b), inv(b)) == a
                @test conj(a, b) * conj(inv(a), b) == one(S)
            end

            # Power
            for a in As
                @test a^0 == one(S)
                @test a^1 == a
                @test a^2 == a * a
                @test a^3 == a * a * a
                @test a^(-1) == inv(a)
                @test a^(-2) == inv(a) * inv(a)
            end
        end
    end
end
