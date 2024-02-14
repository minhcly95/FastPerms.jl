module FastPerms

using Random

include("check_image.jl")
include("AbstractPerm.jl")
include("SPerm.jl")

export AbstractPerm
export SPerm

export identity_perm

end
