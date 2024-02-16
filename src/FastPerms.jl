module FastPerms

using Random

include("check_image.jl")
include("perm_gen.jl")

include("AbstractPerm.jl")
include("SPerm.jl")
include("CPerm.jl")
include("LPerm.jl")
include("random.jl")

export AbstractPerm
export SPerm
export CPerm
export LPerm

export identity_perm
export num_perms

end
