# Create a cyclic permutation
function cycle(T::Type{<:AbstractPerm}, ::Val{N}, elements::Tuple) where {N}
    @boundscheck (minimum(elements) >= 1 && maximum(elements) <= N) ||
                 throw(ArgumentError("there are out-of-range elements (must be in 1:$N)"))

    # Unsafe code to avoid memory allocation
    images = Ref(SPerm{N}())    # Start with an identity SPerm
    ptr = Base.unsafe_convert(Ptr{Int}, pointer_from_objref(images))
    setv(x, i) = unsafe_store!(ptr, x, i)

    i = elements[end]
    GC.@preserve images for j in elements
        setv(j, i)
        i = j
    end

    return @inbounds T(images[])
end

# If N is not provided, use the maximum element as N
Base.@propagate_inbounds cycle(T::Type{<:AbstractPerm{N}}, elements::Tuple) where {N} = cycle(T, Val{N}(), elements)
Base.@propagate_inbounds cycle(T::Type{<:AbstractPerm}, elements::Tuple) = cycle(T, Val(maximum(elements)), elements)

# Other signatures
Base.@propagate_inbounds cycle(T::Type{<:AbstractPerm}, elements::Integer...) = cycle(T, tuple(elements...))
Base.@propagate_inbounds cycle(T::Type{<:AbstractPerm}, elements::AbstractVector) = cycle(T, Tuple(elements))

Base.@propagate_inbounds cycle(elements::Tuple) = cycle(SPerm, elements)
Base.@propagate_inbounds cycle(elements::Integer...) = cycle(SPerm, tuple(elements...))
Base.@propagate_inbounds cycle(elements::AbstractVector) = cycle(SPerm, Tuple(elements))

# Create a permutation from cycle notation
function Base.parse(T::Type{<:AbstractPerm}, str::AbstractString)
    a = SPerm{1}()
    for match in eachmatch(r"\((.*?)\)", str)
        cycle_str = match.captures[1]
        elems_str = split(cycle_str, [' ', ','], keepempty=false)
        isempty(elems_str) && continue
        elems = parse.(Int, elems_str)
        a *= cycle(Tuple(elems))
    end
    return T(a)
end

macro perm_str(str)
    return :(parse(SPerm, $str))
end

