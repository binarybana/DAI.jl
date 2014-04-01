include("dai_common.jl")
include("dai_wrap.jl")

function wrapdai_varset_create()
  ccall( (:wrapdai_varset_create, "src/libdaiwrap.so"), Ptr{VarSet}, ())
end
function wrapdai_var_create(label, states)
  ccall( (:wrapdai_var_create, "src/libdaiwrap.so"), Ptr{Var}, (Cint, Cint), label, states)
end

x = wrapdai_var_create(0,2)
y = wrapdai_var_create(1,2)

println("label: ", wrapdai_var_label(x))
println("states: ", wrapdai_var_states(x))

vs = wrapdai_varset_create()
wrapdai_varset_insert(vs,x)
wrapdai_varset_insert(vs,y)

vs2 = wrapdai_varset_create()
wrapdai_varset_insert(vs2,wrapdai_var_create(2,2))
wrapdai_varset_insert(vs2,wrapdai_var_create(3,3))

wrapdai_varset_add(vs,vs2)

println("nrstates: ", wrapdai_varset_nrStates(vs))
println("size: ", wrapdai_varset_size(vs))

