using DAI

function wrapdai_varset_create()
  ccall( (:wrapdai_varset_create, "src/libdaiwrap.so"), Ptr{VarSet}, ())
end
function wrapdai_var_create(label, states)
  ccall( (:wrapdai_var_create, "src/libdaiwrap.so"), Ptr{Var}, (Csize_t, Csize_t), label, states)
end

function wrapdai_varset_calcLinearState(vs::Ptr{VarSet}, states)
  ccall( (:wrapdai_varset_calcLinearState, "src/libdaiwrap.so"), Csize_t, (Ptr{VarSet}, Ptr{Csize_t}), vs, uint64(states))
end
function wrapdai_varset_calcState(vs::Ptr{VarSet}, state)
  states = Array(Csize_t, wrapdai_varset_size(vs))
  ccall( (:wrapdai_varset_calcState, "src/libdaiwrap.so"), None, (Ptr{VarSet}, Csize_t, Ptr{Csize_t}), vs, state, states)
  return states
end
function wrapdai_factor_create_varset_vals(vs::Ptr{VarSet}, vals)
  ccall( (:wrapdai_factor_create_varset_vals, "src/libdaiwrap.so"), Ptr{Factor}, (Ptr{VarSet}, Ptr{Cdouble}), vs, vals)
end
function wrapdai_factor_get(fac::Ptr{Factor}, index)
  ccall( (:wrapdai_factor_get, "src/libdaiwrap.so"), Cdouble, (Ptr{Factor}, Csize_t), fac, index)
end
function wrapdai_fg_create_facs(facs)
  numfacs = length(facs)
  ccall( (:wrapdai_fg_create_facs, "src/libdaiwrap.so"), Ptr{FactorGraph}, (Ptr{Factor}, Cint), facs, numfacs)
end
function wrapdai_factor_set(fac::Ptr{Factor}, index, val)
  ccall( (:wrapdai_factor_set, "src/libdaiwrap.so"), None, (Ptr{Factor}, Csize_t, Cdouble), fac, index, val)
end
function wrapdai_ps_create(name)
  ccall( (:wrapdai_ps_create, "src/libdaiwrap.so"), Ptr{PropertySet}, (Ptr{Uint8},), name)
end

x = wrapdai_var_create(0,2)
y = wrapdai_var_create(1,2)

println("label: ", wrapdai_var_label(x))
println("states: ", wrapdai_var_states(x))

vs = wrapdai_varset_create()
wrapdai_varset_insert(vs,x)
wrapdai_varset_insert(vs,y)

vs2 = wrapdai_varset_create()
wrapdai_varset_insert(vs2,wrapdai_var_create(3,3))

wrapdai_varset_add(vs,vs2)

println("nrstates: ", wrapdai_varset_nrStates(vs))
println("size: ", wrapdai_varset_size(vs))

for i=0:wrapdai_varset_nrStates(vs)-1
  println("#################")
  states = wrapdai_varset_calcState(vs, i)
  state = wrapdai_varset_calcLinearState(vs, states)
  print("state $i -> states: $(states')")
  println("-> state: $state")
  assert(i==state)
end

testvals = zeros(int(wrapdai_varset_nrStates(vs)))
testvals[1] = 3.0
testvals[2] = 3.0
testvals[12] = 3.0

#fac = wrapdai_factor_create_varset_vals(vs, rand(int(wrapdai_varset_nrStates(vs))))
fac = wrapdai_factor_create_varset_vals(vs, testvals)

println("normalize factor: ", wrapdai_factor_normalize(fac))
tot = 0.0
for i=0:wrapdai_factor_nrStates(fac)-1
  val = wrapdai_factor_get(fac, i)
  println("val: $val")
  tot += val
end
assert(abs(tot-1.0) <= eps())

println("\nNow testing a marginal factor:")
fac2 = wrapdai_factor_marginal(fac, vs2)
tot = 0.0
for i=0:wrapdai_factor_nrStates(fac2)-1
  val = wrapdai_factor_get(fac2, i)
  println("val: $val")
  tot += val
end
assert(abs(tot-1.0) <= eps())

fac3 = wrapdai_factor_create_var(wrapdai_var_create(5,2))
wrapdai_factor_set(fac3, 0, 10.0)
wrapdai_factor_set(fac3, 1, 5.0)


println("")
println("Testing FactorGraph")
fg = wrapdai_fg_create_facs([fac, fac3])
println("Number of edges: $(wrapdai_fg_nrEdges(fg))")
println("Number of factors: $(wrapdai_fg_nrFactors(fg))")
println("Number of vars: $(wrapdai_fg_nrVars(fg))")

println("")
println("Testing JTree")
ps = wrapdai_ps_create("[updates=HUGIN]")
jt = wrapdai_jt_create_fgps(fg, ps)
wrapdai_jt_init(jt)
wrapdai_jt_run(jt)
println("iterations: $(wrapdai_jt_iterations(jt))")
println(wrapdai_jt_printProperties(jt))
marg = wrapdai_jt_calcMarginal(jt, vs)
println(wrapdai_factor_get(marg, 0))
