using DAI

x = Var(0,2)
y = Var(1,2)

println("label: ", label(x))
println("states: ", states(x))

vs1 = VarSet(x,y)
vs2 = VarSet(Var(3,3))

vs3 = vs1 + vs2

println("length: ", length(vs3))
println("nrstates: ", nrStates(vs3))

for i=0:nrStates(vs3)-1
  println("#################")
  states = calcState(vs3, i)
  state = calcLinearState(vs3, states)
  print("state $i -> states: $(states')")
  println("-> state: $state")
  assert(i==state)
end

testvals = zeros(int(nrStates(vs3)))
testvals[1] = 3.0
testvals[2] = 3.0
testvals[12] = 3.0

#fac = wrapdai_factor_create_varset_vals(vs1,rand(int(nrStates(vs1))))
fac = Factor(vs3, testvals)

println("normalize factor: ", normalize!(fac))
tot = 0.0
for i=0:nrStates(fac)-1
  val = fac[i]
  println("val: $val")
  tot += val
end
assert(abs(tot-1.0) <= eps())

println("\nNow testing a marginal factor:")
fac2 = marginal(fac, vs2)
tot = 0.0
for i=0:nrStates(fac2)-1
  val = fac2[i]
  println("val: $val")
  tot += val
end
assert(abs(tot-1.0) <= eps())
fac2[0]=22.3

fac3 = Factor(Var(5,2) + x)
fac3[0] = 10.0
fac3[1] = 5.0
fac3[2] = 3.0


println("")
println("Testing FactorGraph")
fg = FactorGraph(fac, fac2, fac3)
println("Number of edges: $(numEdges(fg))")
println("Number of factors: $(numFactors(fg))")
println("Number of vars: $(numVars(fg))")

println("")
println("Testing JTree")
jt = JTree(fg)
init!(jt)
run!(jt)
println("iterations: $(iterations(jt))")
println(properties(jt))
marg = marginal(jt, vs1)
@show marg[0]
