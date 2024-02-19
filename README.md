# FastPerms

A Julia permutation package optimized for performance.

[![Build Status](https://github.com/minhcly95/FastPerms.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/minhcly95/FastPerms.jl/actions/workflows/CI.yml?query=branch%3Amain)

## Introduction

This package provides several optimized implementations of permutations (which is defined as a bijection from `1:N` to `1:N`).
In particular, multiplication and inversion require no heap-allocated memory which is usually the biggest bottleneck in Julia.
There are three implementations to choose from:
- `SPerm{N}`: stores the images as an `NTuple`. Multiplication and inversion are done by shuffling the images around.
It has large memory footprint (`8N` bytes) but supports any `N`.
- `CPerm{N}`: stores every image as a 4-bit number in an `UInt64`. Multiplication and inversion are done via bitwise operations.
It supports up to `N = 16`.
- `LPerm{N}`: uses lookup tables to do multiplication and inversion. Extremely fast, but it only supports up to `N = 5`.

The performance of each implementation depends on the CPU architecture (see this [benchmark](benchmark/benchmark_report.md) for reference).
We provide a [benchmark script](benchmark/benchmarks.jl) for you to check the speed on your machine
(see [PkgBenchmark.jl](https://github.com/JuliaCI/PkgBenchmark.jl) on how to run the benchmark).
Nonetheless, they should be faster than any implementation that stores the images in a `Vector`
(e.g. [Permutations.jl](https://github.com/scheinerman/Permutations.jl)).

## Tutorial

```julia
# Create a permutation from a list of images
a = SPerm(4,2,3,1)      # Map (1,2,3,4) to (4,2,3,1)
b = CPerm((3,2,1,4))    # Map (1,2,3,4) to (3,2,1,4)
c = LPerm([2,3,4,1])    # Map (1,2,3,4) to (2,3,4,1)

# Create an identity permutation
e = SPerm{8}()
@assert e == one(SPerm{8}) == identity_perm(SPerm{8})

# Get degree of a permutation (the degree of an N-permutation is N)
@assert degree(a) == 4
@assert degree(e) == 8

# Get the image of an element (a[i], i^a, and a(i) are interchangable)
@assert a[1] == 1^a == a(1) == 4
@assert a[2] == 2^a == a(2) == 2
@assert a[3] == 3^a == a(3) == 3
@assert a[4] == 4^a == a(4) == 1

# Get all the images
@assert images(b) == (3,2,1,4)
@assert collect(c) == [2,3,4,1]

# Multiplication is done from left-to-right
# In particular, the left permutation is applied first
@assert a * b == [4,2,1,3]
@assert b * a == [3,2,4,1]
@assert b * a * c == [4,3,1,2]

# Use composition (\circ) to combine permutations from right-to-left
@assert a ∘ b == [3,2,4,1]
@assert a ∘ b == b * a

# Inversion
@assert inv(a) == [4,2,3,1]
@assert inv(b) == [3,2,1,4]
@assert inv(c) == [4,1,2,3]

# Power
@assert a^2 == [1,2,3,4]
@assert a^3 == a

# Generate random permutations
r = rand(SPerm{16})
s,t,u,v = rand(CPerm{8}, 4)

# Add @inbounds to skip bound-checking (for even faster code)
d = @inbounds SPerm(2,1,4,3)
@assert @inbounds d(2) == 1
```

