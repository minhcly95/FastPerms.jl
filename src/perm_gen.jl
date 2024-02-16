# Generate all permutations of N elements as tuples.
# This uses Heap's algorithm.
# Warning: may take forever if N large.
function _generate_all_perms(N::Integer)
    perms = NTuple{N,Int}[]
    A = collect(1:N)

    function recur(k)
        if k == 1
            push!(perms, Tuple(A))
            return
        end

        recur(k - 1)

        for i in 1:k-1
            if iseven(k)
                A[i], A[k] = A[k], A[i]
            else
                A[1], A[k] = A[k], A[1]
            end
            recur(k - 1)
        end
    end
    recur(N)
    return perms
end

