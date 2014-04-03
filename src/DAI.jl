module DAI

#using BinDeps
#@BinDeps.load_dependencies
const libdai = Pkg.dir("DAI", "deps", "libdaiwrap.so")

include("dai_wrap.jl")

end
