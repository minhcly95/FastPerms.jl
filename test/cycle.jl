@testset "Cycle" begin
    @testset "Direct comparison" begin
        @test cycle(1, 6, 5, 3) == [6, 2, 1, 4, 3, 5]
        @test cycle(12, 20) == [1:11..., 20, 13:19..., 12]
        @test cycle(SPerm{10}, 4, 2, 7, 1) == [4, 7, 3, 2, 5, 6, 1, 8, 9, 10]
    end

    @testset "Evenness" begin
        for N in 1:10
            @test iseven(cycle(1:N...)) == isodd(N)
        end
    end

    @testset "Order" begin
        for N in 2:10
            @test isone(cycle(1:N)^N)
        end
    end

    @testset "Parse" begin
        @test isone(perm"")
        @test isone(parse(SPerm{8}, ""))
        @test perm"(2,5)(1,3,7)" == [3, 5, 7, 4, 2, 6, 1]
        @test perm"(1 5)(2 5)(3 5)(4 5)" == [2, 3, 4, 5, 1]
        @test perm"(6, 8,2) (4   7)" == [1, 6, 3, 7, 5, 8, 4, 2]
    end
end
