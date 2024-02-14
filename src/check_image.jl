# Check if the given tuple is a valid permutation
function check_valid_image(images::NTuple{N,T}) where {N,T}
    # The function must map onto 1-N: min = 1 and max = N
    a, b = minimum(images), maximum(images)
    (a == 1 && b == N) || throw(ArgumentError("given image does not contain every number in 1:$N"))
    # The function must be injective: no duplicate image
    allunique(images) || throw(ArgumentError("there are duplicated images"))
end
