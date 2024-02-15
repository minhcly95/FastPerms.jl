module FastPerms

using Random

include("check_image.jl")
include("AbstractPerm.jl")
include("SPerm.jl")
include("CPerm.jl")
include("random.jl")

export AbstractPerm
export SPerm
export CPerm

export identity_perm

end
