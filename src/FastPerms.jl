module FastPerms

using Random

include("check_image.jl")
include("abstract_perm.jl")
include("s_perm.jl")

export AbstractPerm
export SPerm

export identity_perm

end
