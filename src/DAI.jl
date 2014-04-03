module DAI

#using BinDeps
#@BinDeps.load_dependencies
libdai = Pkg.dir("DAI", "deps", "libdai")

include("dai_wrap.jl")

end
