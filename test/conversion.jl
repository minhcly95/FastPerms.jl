@testset "Conversion" begin
    perms = rand.([SPerm{4}, SPerm{4,UInt8}, CPerm{4}, LPerm{4}])

    # Default conversion
    for a in perms
        @test typeof(SPerm(a)) == SPerm{4,Int}
        @test typeof(CPerm(a)) == CPerm{4}
        @test typeof(LPerm(a)) == LPerm{4}
    end

    # Same degree conversion
    for a in perms
        @test typeof(SPerm{4}(a)) == SPerm{4,Int}
        @test typeof(SPerm{4,UInt8}(a)) == SPerm{4,UInt8}
        @test typeof(CPerm{4}(a)) == CPerm{4}
        @test typeof(LPerm{4}(a)) == LPerm{4}
    end

    # Conversion to lower degree
    for a in perms
        @test typeof(SPerm{3}(a)) == SPerm{4,Int}
        @test typeof(CPerm{3}(a)) == CPerm{4}
        @test typeof(LPerm{3}(a)) == LPerm{4}

        @test_throws ArgumentError convert(SPerm{3,Int}, a)
        @test_throws ArgumentError convert(SPerm{3,UInt8}, a)
        @test_throws ArgumentError convert(CPerm{3}, a)
        @test_throws ArgumentError convert(LPerm{3}, a)
    end

    # Conversion to higher degree
    for a in perms
        @test typeof(SPerm{5}(a)) == SPerm{5,Int}
        @test typeof(CPerm{5}(a)) == CPerm{5}
        @test typeof(LPerm{5}(a)) == LPerm{5}
    end

    # Conversion to unsupported degree
    for a in perms
        @test typeof(CPerm{32}(a)) == SPerm{32,Int}
        @test typeof(LPerm{8}(a)) == SPerm{8,Int}

        @test_throws ArgumentError convert(CPerm{32}, a)
        @test_throws ArgumentError convert(LPerm{8}, a)
    end
end

