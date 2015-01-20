using DAI
using Base.Test

x = Var(0,2)
y = Var(1,2)

println("label: ", label(x))
println("states: ", states(x))

vs0 = VarSet(x) - x
@test labels(vs0) == Int[]

vs1 = VarSet(x,y)
vs2 = VarSet(Var(3,3))

@test x in vs1
@test y in vs1 
@test !(x in vs2)
@test !(y in vs2)

vs3 = vs1 + vs2

@test vs1 < vs3
@test !(vs1 > vs3)
@test !(vs1 >= vs3)
@test vs1 <= vs3
@test vs2 < vs3
@test vs3 >= vs2

println("length: ", length(vs3))
println("nrstates: ", nrStates(vs3))

for i=1:nrStates(vs3)
  println("#################")
  states = calcState(vs3, i)
  print("state $i -> states: $(states')")
  state = calcLinearState(vs3, states)
  println("-> state: $state")
  @test i==state
end

vs = VarSet(Var(0,2), Var(2,2))
v = Var(1,2)
for i=1:nrStates(vs)
  i1,i2 = conditionalStateBoth(v,vs,i)
  for j=1:2
    state = conditionalState(v,vs,j,i)
    state_pris = DAI.pris_conditionalState(v,vs,j,i)
    @test state==state_pris
    if j==1
      @test i1 == state
    else
      @test i2 == state
    end
  end
end

vs = VarSet(Var(0,2), Var(2,2))
v = Var(3,2)
for i=1:nrStates(vs), j=1:2
  state = conditionalState(v,vs,j,i)
  state_pris = DAI.pris_conditionalState(v,vs,j,i)
  @test state==state_pris
end

vs = VarSet(Var(1,2), Var(2,2))
v = Var(0,2)
for i=1:nrStates(vs), j=1:2
  state = conditionalState(v,vs,j,i)
  state_pris = DAI.pris_conditionalState(v,vs,j,i)
  @test state==state_pris
end

# Memory allocation tests
vs = VarSet(Var(1,2), Var(2,2))
for i=1:100000
  vs = deepcopy(vs)
end
gc()
allvars = vars(vs)
@test allvars[1].label == 1
@test allvars[2].label == 2
@test allvars[1].states == 2
@test allvars[2].states == 2

#testvals = zeros(int(nrStates(vs3)))
#testvals[1] = 3.0
#testvals[2] = 3.0
#testvals[12] = 3.0

testvals = rand(int(nrStates(vs3)))

# Memory allocation tests
vs = VarSet(Var(1,2), Var(2,2))
fac = Factor(vs3, testvals)
for i=1:10000
  fac = deepcopy(fac)
end
gc()
@test vars(fac) == vs3
@test p(fac) == testvals

fac = Factor(vs3, testvals)

println("normalize factor: ", normalize!(fac))
tot = 0.0
for i=1:nrStates(fac)
  val = fac[i]
  println("val: $val")
  tot += val
end
@test_approx_eq abs(tot) 1.0

println("\nNow testing a marginal factor:")
fac2 = marginal(fac, vs2)
tot = 0.0
for i=1:nrStates(fac2)
  val = fac2[i]
  println("val: $val")
  tot += val
end
@test_approx_eq abs(tot) 1.0
fac2[1]=22.3

fac3 = Factor(Var(5,2) + x)
fac3[1] = 10.0
fac3[2] = 5.0
fac3[3] = 3.0


println("")
println("Testing FactorGraph")
fg = FactorGraph(fac, fac2, fac3)
println("Number of edges: $(numEdges(fg))")
println("Number of factors: $(numFactors(fg))")
println("Number of vars: $(numVars(fg))")

# Memory allocation tests
fg = FactorGraph(fac, fac2, fac3)
for i=1:10000
  fg = deepcopy(fg)
end
gc()
@test fg[1] == fac
@test fg[2] == fac2
@test fg[3] == fac3

jt = JTree(fg)
jt2 = deepcopy(jt)
@test jt2.hdl != jt.hdl

println("")
println("Testing JTree")
jt = JTree(fg)
init!(jt)
run!(jt)
println("iterations: $(iterations(jt))")
println(properties(jt))
marg = marginal(jt, vs1)
@show p(marg)

@test_approx_eq sum(p(marg)) 1

@test fg[1] == fac
@test fg[2] == fac2
@test fg[3] == fac3

## Test factor copying
facc = copy(fac)
@test facc == fac
x = p(facc)
x[1] += 2.0
@test facc != fac
println("Factor copying checks out")

#Test fg and jtree copying
fgc = copy(fg)
@test fgc == fg
jtc = copy(jt)
#@test jtc == jt # doesn't exist yet

## Test fg equality
setBackedFactor!(fgc,1,facc)
@test fgc != fg
restoreFactors!(fgc)
@test fgc == fg

## Test unsafe vars
facc = copy(fac)
@test facc == fac
vs = vars(fac) 
vsc1 = vars(fac) 
vsc2 = copy(vars(fac))
temp = vars(copy(fac))
@test vsc2 == temp

@test vs == vsc1
@test vs == vsc2
@test vsc1 == vsc2
vs2 = vs - y
@test vs == vsc1
@test vs == vsc2
@test vsc1 == vsc2

@test vs2 != vsc1
@test vs2 != vsc2
@test vs2 != vs

@test facc == fac

erase!(vs, y)

@test facc != fac #uhh.. fac is no longer a proper factor here
@show fac # because vs = vars(fac) is tampering directly with internals

@test vs == vsc1
@test vs != vsc2
@test vsc1 != vsc2

@test vs2 == vsc1
@test vs2 != vsc2
@test vs2 == vs

insert!(vs, y)

@test vs == vsc1
@test vs == vsc2
@test vsc1 == vsc2

@test vs2 != vsc1
@test vs2 != vsc2
@test vs2 != vs

@test facc == fac

@test labels(fac) == [0,1,3]
@test labels(vs1) == [0,1]

############
vs = VarSet(Var(1,2), Var(2,2))

fac = Factor(vs)
fac2 = embed(fac, Var(3,2))
fac3 = embed(fac, vs+Var(3,2))
@test fac2 == fac3
#

#y = vars(fg)
#x = vars(vs1)

#println(x)
#println(vs1)
#println(fac)
#println(fg)
