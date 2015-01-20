# Julia wrapper for header: src/dai.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0
# and then hand modified by Jason Knight <jason@jasonknight.us>

import Base: length, getindex, setindex!, copy, ==, in, show, isless, searchsortedlast, deepcopy_internal

export Var, label, states
export VarSet, insert!, erase!, labels, nrStates, calcLinearState, calcState, conditionalState, conditionalStateBoth, conditionalState2
export Factor, vars, entropy, embed, normalize!, p
export FactorGraph, numVars, numFactors, numEdges, setBackedFactor!, clearBackups!, restoreFactors!, readFromFile
export JTree, init!, run!, iterations, properties, marginal, belief

typealias _VarSet Ptr{Void}
typealias _PropertySet Ptr{Void}
typealias _Factor Ptr{Void}
typealias _FactorGraph Ptr{Void}
typealias _JTree Ptr{Void}

############################
# Var
############################

immutable Var
  label::Csize_t
  states::Csize_t
  function Var(label, states)
    assert(label>=0)
    assert(states>0)
    new(label,states)
  end
end

typealias _Var Ptr{Var}

function label(x::Var)
  int(x.label)
end
function states(x::Var)
  int(x.states)
end
function ==(v1::Var, v2::Var)
  v1.label == v2.label
  v1.states == v2.states
end
function show(io::IO, v::Var)
  print(io, "Var(label=$(label(v)), states=$(states(v)))")
end


############################
# VarSet
############################
type VarSet
  hdl::_VarSet
  function VarSet(hdl::_VarSet, own=true)
    v = new(hdl)
    own && finalizer(v, wrapdai_varset_delete)
    v
  end
end

function VarSet()
  VarSet( ccall( (:wrapdai_varset_create, libdai), _VarSet, ()) )
end

function VarSet(vars...)
  assert(eltype(vars) == Var)
  vsp = ccall( (:wrapdai_varset_create, libdai), _VarSet, ())
  for var in vars
    ccall( (:wrapdai_varset_insert, libdai), _VarSet, (_VarSet, _Var), vsp, &var)
  end
  VarSet(vsp)
end
function +(v1::Var, v2::Var)
  VarSet(v1,v2)
end

function wrapdai_varset_delete(x::VarSet)
  ccall( (:wrapdai_varset_delete, libdai), None, (_VarSet,), x.hdl)
end
function copy(vs::VarSet)
  VarSet(ccall( (:wrapdai_varset_clone, libdai), _VarSet, (_VarSet,), vs.hdl))
end
function deepcopy_internal(vs::VarSet, stack::ObjectIdDict)
  haskey(stack,vs) && return vs
  return stack[vs] = copy(vs)
end

function insert!(vs::VarSet, v::Var)
  ccall( (:wrapdai_varset_insert, libdai), _VarSet, (_VarSet, _Var), vs.hdl, &v)
  vs
end
function labels(vs::VarSet)
  ptrs = pointer_to_array(ccall( (:wrapdai_varset_vars, libdai), _Var, (_VarSet,), vs.hdl), 
    int(length(vs)))
  Int[label(x) for x in ptrs]
end
function searchsortedlast(vs::VarSet, v::Var)
  ccall( (:wrapdai_varset_searchsortedlast, libdai), Cint, (_VarSet,_Var), vs.hdl, &v)
end
function nrStates(vs::VarSet)
  ccall( (:wrapdai_varset_nrStates, libdai), Cint, (_VarSet,), vs.hdl)
end
function length(vs::VarSet)
  ccall( (:wrapdai_varset_size, libdai), Cint, (_VarSet,), vs.hdl)
end
function erase!(vs::VarSet, v::Var)
  ccall( (:wrapdai_varset_erase, libdai), _VarSet, (_VarSet, _Var), vs.hdl, &v)
  vs
end
function sub!(vs1::VarSet, vs2::VarSet)
  ccall( (:wrapdai_varset_remove, libdai), _VarSet, (_VarSet, _VarSet), vs1.hdl, vs2.hdl)
end
function add!(vs1::VarSet, vs2::VarSet)
  ccall( (:wrapdai_varset_addm, libdai), _VarSet, (_VarSet, _VarSet), vs1.hdl, vs2.hdl)
end
function +(vs1::VarSet, vs2::VarSet)
  VarSet(ccall( (:wrapdai_varset_add, libdai), _VarSet, (_VarSet, _VarSet), vs1.hdl, vs2.hdl))
end
function +(vs::VarSet, v::Var)
  VarSet(ccall( (:wrapdai_varset_add_one, libdai), _VarSet, (_VarSet, _Var), vs.hdl, &v))
end
function -(vs1::VarSet, vs2::VarSet)
  VarSet(ccall( (:wrapdai_varset_sub, libdai), _VarSet, (_VarSet, _VarSet), vs1.hdl, vs2.hdl))
end
function -(vs::VarSet, v::Var)
  VarSet(ccall( (:wrapdai_varset_sub_one, libdai), _VarSet, (_VarSet, _Var), vs.hdl, &v))
end

function calcLinearState(vs::VarSet, statevals)
  #for (i,v) in enumerate(vars(vs))
    #0 < statevals[i] <= states(v) || throw(BoundsError())
  #end
  #assert(length(vs) == length(statevals))
  tot = 0
  for i=1:length(statevals)
    tot += (statevals[i]-1)*2^(i-1)
  end
  tot+1
end

function pris_calcLinearState(vs::VarSet, statevals)
  for (i,v) in enumerate(vars(vs))
    0 < statevals[i] <= states(v) || throw(BoundsError())
  end
  assert(length(vs) == length(statevals))
  for i=1:length(statevals)
    statevals[i] -= 1
  end
  ret = 1+ccall( (:wrapdai_varset_calcLinearState, libdai), Csize_t, 
    (_VarSet, Ptr{Csize_t}, _VarSet), vs.hdl, uint(statevals), C_NULL)
  for i=1:length(statevals)
    statevals[i] += 1
  end
  ret
end

function calcLinearState(vs::VarSet, statevals, orig::VarSet)
  for (i,v) in enumerate(vars(orig))
    if statevals[i] > states(v)
      @show vs, statevals, orig
      @show i,v
      @show statevals[i], states(v)
      throw(BoundsError())
    end
  end
  assert(length(orig) == length(statevals))
  for i=1:length(statevals)
    statevals[i] -= 1
  end
  ret = 1+ccall( (:wrapdai_varset_calcLinearState, libdai), Csize_t, 
    (_VarSet, Ptr{Csize_t}, _VarSet), vs.hdl, uint(statevals), orig.hdl)
  for i=1:length(statevals)
    statevals[i] += 1
  end
  ret
end

function calcState(vs::VarSet, state)
  0 < state <= nrStates(vs) || throw(BoundsError())
  states = Array(Csize_t, length(vs))
  ccall( (:wrapdai_varset_calcState, libdai), None, (_VarSet, Csize_t, Ptr{Csize_t}), 
    vs.hdl, state-1, states)
  broadcast!(+,states,states,1)
  return states 
end

function conditionalState(v::Var, pars::VarSet, vstate, parstate)
  #0 < vstate <= states(v) || throw(BoundsError())
  #0 < parstate <= nrStates(pars) || throw(BoundsError())
  tot = 0
  inserti = searchsortedlast(pars,v)
  correction = 0
  ps = parstate - 1
  for i=1:length(pars)
    if inserti < i && correction == 0
      tot += (vstate-1)*2^(i-1)
      correction = 1
    end
    stateval = 2^(i+correction-1) & (ps<<correction)
    tot += stateval#*2^(i+correction-1)
  end
  if correction == 0 # append variable
    tot += (vstate-1)*2^(length(pars))
  end
  tot+1
end

function conditionalStateBoth(v::Var, pars::VarSet, parstate)
  tot0 = 0
  tot1 = 0
  inserti = searchsortedlast(pars,v)
  correction = 0
  ps = parstate - 1
  for i=1:length(pars)
    if inserti < i && correction == 0
      tot1 += 2^(i-1)
      correction = 1
    end
    stateval = 2^(i+correction-1) & (ps<<correction)
    tot0 += stateval
    tot1 += stateval
  end
  if correction == 0 # append variable
    tot1 += 2^(length(pars))
  end
  tot0+1,tot1+1
end

function pris_conditionalState(v::Var, pars::VarSet, vstate, parstate)
  0 < vstate <= states(v) || throw(BoundsError())
  0 < parstate <= nrStates(pars) || throw(BoundsError())
  1 + ccall( (:wrapdai_varset_conditionalState, libdai), Csize_t, 
    (_Var, _VarSet, Csize_t, Csize_t), &v, pars.hdl, vstate-1, parstate-1)
end

function conditionalState2(all::VarSet, v1::Var, v2::Var, pars::VarSet, vstate, parstate)
  #0 < vstate <= states(v1) || throw(BoundsError())
  #0 < parstate <= nrStates(pars) || throw(BoundsError())
  tot1 = 0
  tot2 = 0
  inserti1 = searchsortedlast(all,v1) #this is 'off by one' and accounted for below
  inserti2 = searchsortedlast(all,v2)
  ps = parstate - 1
  correction = 0
  for i=1:length(all)
    if inserti1 == i
      temp = (vstate-1)*2^(i-1)
      tot1 += temp
      tot2 += temp
      correction += 1
    elseif inserti2 == i
      # tot1 missing on purpose here
      tot2 += 2^(i-1)
      correction += 1
    else
      stateval = 2^(i-1) & (ps<<correction)
      tot1 += stateval
      tot2 += stateval
    end
  end
  tot1 += 1
  tot2 += 1
  #pris = pris_conditionalState2(all,v1,v2,pars,vstate,parstate)
  #if pris != (tot1,tot2)
    #raise(Exception())
    #@show v1
    #@show v2
    #@show pars
    #@show vstate
    #@show parstate
    #@show tot1+1,tot2+1
    #@show pris
  #end
  tot1,tot2
end

function pris_conditionalState2(all::VarSet, v1::Var, v2::Var, pars::VarSet, vstate, parstate)
  0 < vstate <= states(v1) || throw(BoundsError())
  0 < parstate <= nrStates(pars) || throw(BoundsError())
  i1 = 1 + ccall( (:wrapdai_varset_conditionalState2, libdai), Csize_t, 
    (_Var, _Var, _VarSet, Csize_t, Csize_t, Csize_t), 
    &v1, &v2, pars.hdl, vstate-1, 0, parstate-1)
  i2 = 1 + ccall( (:wrapdai_varset_conditionalState2, libdai), Csize_t, 
    (_Var, _Var, _VarSet, Csize_t, Csize_t, Csize_t), 
    &v1, &v2, pars.hdl, vstate-1, 1, parstate-1)
  return i1,i2
end

function in(v::Var, vs::VarSet)
  ccall( (:wrapdai_varset_contains, libdai), Bool, (_VarSet, _Var), vs.hdl, &v)
end
function ==(vs1::VarSet, vs2::VarSet)
  ccall( (:wrapdai_varset_isequal, libdai), Bool, (_VarSet, _VarSet), vs1.hdl, vs2.hdl)
end
function isless(vs1::VarSet, vs2::VarSet)
  ccall( (:wrapdai_varset_isless, libdai), Bool, (_VarSet, _VarSet), vs1.hdl, vs2.hdl)
end
function vars(vs::VarSet)
  pointer_to_array(ccall( (:wrapdai_varset_vars, libdai), _Var, (_VarSet,), vs.hdl), 
    int(length(vs)),false)
end
function show(io::IO, vs::VarSet)
  if length(vs) == 0
    print(io, "VarSet()")
  else
    println(io, "VarSet(")
    for v=vars(vs)
      show(io, v)
      println(io, ",")
    end
    print(io,")")
  end
end
############################
# Factor
############################

type Factor
  hdl::_Factor
  function Factor(hdl::_Factor)
    v = new(hdl)
    finalizer(v, wrapdai_factor_delete)
    v
  end
end
function Factor(v::Var...)
  if length(v) == 1
    return Factor(ccall( (:wrapdai_factor_create_var, libdai), _Factor, (_Var,), &v[1]))
  else
    return Factor(Varset(v))
  end
end
function Factor(vs::VarSet)
  Factor(ccall( (:wrapdai_factor_create_varset, libdai), _Factor, (_VarSet,), vs.hdl))
end
function Factor(vs::VarSet, vals::Vector{Float64})
  assert(length(vals) == nrStates(vs))
  Factor(ccall( (:wrapdai_factor_create_varset_vals, libdai), _Factor, (_VarSet, Ptr{Cdouble}), vs.hdl, vals))
end

function wrapdai_factor_delete(fac::Factor)
  ccall( (:wrapdai_factor_delete, libdai), None, (_Factor,), fac.hdl)
end
function length(fac::Factor)
  ccall( (:wrapdai_factor_numvars, libdai), Cint, (_Factor,), fac.hdl)
end
function labels(fac::Factor)
  vsp = ccall( (:wrapdai_factor_vars_unsafe, libdai), _VarSet, (_Factor,), fac.hdl)
  lvsp = ccall( (:wrapdai_varset_size, libdai), Cint, (_VarSet,), vsp)
  ptrs = pointer_to_array(ccall( (:wrapdai_varset_vars, libdai), _Var, (_VarSet,), vsp), 
    int(lvsp))
  Int[label(x) for x in ptrs]
end
function setindex!(fac::Factor, val, index)
  0 < index <= nrStates(fac) || throw(BoundsError())
  ccall( (:wrapdai_factor_set, libdai), None, (_Factor, Csize_t, Cdouble), fac.hdl, index-1, val)
end
function getindex(fac::Factor, index)
  0 < index <= nrStates(fac) || throw(BoundsError())
  ccall( (:wrapdai_factor_get, libdai), Cdouble, (_Factor, Csize_t), fac.hdl, index-1)
end
function in(var::Var,fac::Factor)
  var in vars(fac)
end
function copy(fac::Factor)
  Factor(ccall( (:wrapdai_factor_clone, libdai), _Factor, (_Factor,), fac.hdl))
end
function deepcopy_internal(fac::Factor, stack::ObjectIdDict)
  haskey(stack,fac) && return fac
  return stack[fac] = copy(fac)
end
function vars(fac::Factor)
  VarSet(ccall( (:wrapdai_factor_vars_unsafe, libdai), _VarSet, (_Factor,), fac.hdl),false)
end
function nrStates(fac::Factor)
  int(ccall( (:wrapdai_factor_nrStates, libdai), Csize_t, (_Factor,), fac.hdl))
end
function entropy(fac::Factor)
  ccall( (:wrapdai_factor_entropy, libdai), Cdouble, (_Factor,), fac.hdl)
end
function marginal(fac::Factor, vs::VarSet)
  vsp = ccall( (:wrapdai_factor_vars_unsafe, libdai), _VarSet, (_Factor,), fac.hdl)
  assert(ccall( (:wrapdai_varset_isless, libdai), Bool, (_VarSet, _VarSet), vs.hdl, vsp))
  Factor(ccall( (:wrapdai_factor_marginal, libdai), _Factor, (_Factor, _VarSet), fac.hdl, vs.hdl))
end
function embed(fac::Factor, vs::VarSet)
  #vsp = ccall( (:wrapdai_factor_vars_unsafe, libdai), _VarSet, (_Factor,), fac.hdl)
  #assert(ccall( (:wrapdai_varset_isless, libdai), Bool, (_VarSet, _VarSet), vsp, vs.hdl))
  Factor(ccall( (:wrapdai_factor_embed, libdai), _Factor, (_Factor, _VarSet), fac.hdl, vs.hdl))
end
#function embed(fac::Factor, v::Var)
  ##vsp = ccall( (:wrapdai_factor_vars_unsafe, libdai), _VarSet, (_Factor,), fac.hdl)
  ##assert(ccall( (:wrapdai_varset_isless, libdai), Bool, (_VarSet, _VarSet), vsp, vs.hdl))
  #Factor(ccall( (:wrapdai_factor_embed_one, libdai), _Factor, (_Factor, _Var), fac.hdl, &v))
#end

function embed(fac::Factor, v::Var)
  #create blank factor with right nodes
  oldvars = vars(fac)
  inserti = searchsortedlast(oldvars,v)
  newfac = Factor(oldvars+v)
  numoldvars = length(oldvars)
  for origstate=1:nrStates(fac)
    temp = fac[origstate]
    tot0 = 0
    tot1 = 0
    correction = 0
    ps = origstate - 1
    for i=1:numoldvars
      if inserti < i && correction == 0
        #tot0 += 0*2^(i-1)
        tot1 += 2^(i-1)
        correction = 1
      end
      stateval = 2^(i+correction-1) & (ps<<correction)
      tot0 += stateval
      tot1 += stateval
    end
    if correction == 0 # append variable
      #tot0 += (vstate-1)*2^(length(oldvars))
      tot1 += 2^numoldvars
    end
    newfac[tot0+1] = temp
    newfac[tot1+1] = temp
  end
  newfac
end

function normalize!(fac::Factor)
  ccall( (:wrapdai_factor_normalize, libdai), Cdouble, (_Factor,), fac.hdl)
end
function ==(fac1::Factor, fac2::Factor)
  return ccall( (:wrapdai_factor_isequal, libdai), Bool, (_Factor, _Factor), fac1.hdl, fac2.hdl)
end
# the below is just a test, I should really copy the memory
function p(fac::Factor)
  return pointer_to_array(ccall((:wrapdai_factor_p, libdai), Ptr{Cdouble}, (_Factor,), fac.hdl), (nrStates(fac),), false)
end
function show(io::IO, fac::Factor)
  if length(fac) == 0
    print(io, "Factor()")
  else
    println(io, "Factor(")
    show(io,vars(fac))
    println(io, ",")
    for i=1:nrStates(fac)
      println(io, "$i => $(fac[i])")
    end
    print(io,")")
  end
end
############################
# FactorGraph
############################

type FactorGraph
  hdl::_FactorGraph
  function FactorGraph(hdl::_FactorGraph)
    v = new(hdl)
    finalizer(v, wrapdai_fg_delete)
    v
  end
end

function FactorGraph(factors...)
  assert(eltype(factors)==Factor)
  numfacs = length(factors)
  facs = [x.hdl for x in factors]
  FactorGraph(ccall( (:wrapdai_fg_create_facs, libdai), _FactorGraph, (_Factor, Cint), facs, numfacs))
end

function wrapdai_fg_delete(fg::FactorGraph)
  ccall( (:wrapdai_fg_delete, libdai), None, (_FactorGraph,), fg.hdl)
end

function vars(fg::FactorGraph)
  pointer_to_array((ccall( (:wrapdai_fg_vars, libdai), _Var, (_FactorGraph,), fg.hdl)),(numVars(fg),),false)
end
function copy(fg::FactorGraph)
  FactorGraph(ccall( (:wrapdai_fg_clone, libdai), _FactorGraph, (_FactorGraph,), fg.hdl))
end
function deepcopy_internal(fg::FactorGraph, stack::ObjectIdDict)
  haskey(stack,fg) && return fg
  return stack[fg] = copy(fg)
end
function numVars(fg::FactorGraph)
  int(ccall( (:wrapdai_fg_nrVars, libdai), Csize_t, (_FactorGraph,), fg.hdl))
end
function numFactors(fg::FactorGraph)
  int(ccall( (:wrapdai_fg_nrFactors, libdai), Csize_t, (_FactorGraph,), fg.hdl))
end
function numEdges(fg::FactorGraph)
  int(ccall( (:wrapdai_fg_nrEdges, libdai), Csize_t, (_FactorGraph,), fg.hdl))
end
function getindex(fg::FactorGraph, ind)
  0 < ind <= numFactors(fg) || throw(BoundsError())
  Factor(ccall( (:wrapdai_fg_factor, libdai), _Factor, (_FactorGraph, Cint), fg.hdl, ind-1))
end
function setindex!(fg::FactorGraph, fac::Factor, ind)
  0 < ind <= numFactors(fg) || throw(BoundsError())
  ccall( (:wrapdai_fg_setFactor_backup, libdai), None, 
    (_FactorGraph, Cint, _Factor), fg.hdl, ind-1, fac.hdl)
end
function ==(fg1::FactorGraph, fg2::FactorGraph)
  nf1 = numFactors(fg1)
  nf2 = numFactors(fg2)
  nf1 == nf2 || return false
  for i = 1:nf1
    fg1[i] == fg2[i] || return false
  end
  return true
end
function setBackedFactor!(fg::FactorGraph, ind, fac::Factor)
  0 < ind <= numFactors(fg) || throw(BoundsError())
  ccall( (:wrapdai_fg_setFactor_backup, libdai), None, 
    (_FactorGraph, Cint, _Factor), fg.hdl, ind-1, fac.hdl)
end
#function getVar(fg::FactorGraph, ind)
  #0 < ind <= numVars(fg) || throw(BoundsError())
  #Var(ccall( (:wrapdai_fg_var, libdai), _Var, (_FactorGraph, Csize_t), fg.hdl, ind-1))
#end
function clearBackups!(fg::FactorGraph)
  ccall( (:wrapdai_fg_clearBackups, libdai), None, (_FactorGraph,), fg.hdl)
end
function restoreFactors!(fg::FactorGraph)
  ccall( (:wrapdai_fg_restoreFactors, libdai), None, (_FactorGraph,), fg.hdl)
end
function readFromFile(fg::FactorGraph, text)
  FactorGraph(ccall( (:wrapdai_fg_readFromFile, libdai), 
    None, (_FactorGraph, Ptr{Uint8}), fg.hdl, text))
end
function show(io::IO, fg::FactorGraph)
  if numVars(fg) == 0
    print(io, "FactorGraph()")
  else
    println(io, "FactorGraph(")
    for v=vars(fg)
      show(io, v)
      println(io, ",")
    end
    println(io, "Factors: ")
    for i=1:numFactors(fg)
      print(io, "$i: ")
      show(io, fg[i])
      println(",")
    end
    print(io,")")
  end
end
############################
# JunctionTree
############################

type JTree
  hdl::_JTree
  function JTree(hdl::_JTree)
    v = new(hdl)
    finalizer(v, wrapdai_jtree_delete)
    v
  end
end
function JTree(fg::FactorGraph, props="[updates=HUGIN]")
  ps = wrapdai_ps_create(props)
  jt = JTree(ccall( (:wrapdai_jt_create_fgps, libdai), _JTree, (_FactorGraph, _PropertySet), fg.hdl, ps))
  wrapdai_ps_delete(ps)
  jt
end
function wrapdai_jtree_delete(jt::JTree)
  ccall( (:wrapdai_jt_delete, libdai), None, (_JTree,), jt.hdl)
end

function copy(jt::JTree)
  JTree(ccall( (:wrapdai_jt_clone, libdai), _JTree, (_JTree,), jt.hdl))
end

function deepcopy_internal(jt::JTree, stack::ObjectIdDict)
  haskey(stack,jt) && return jt
  return stack[jt] = copy(jt)
end

function init!(jt::JTree)
  ccall( (:wrapdai_jt_init, libdai), None, (_JTree,), jt.hdl)
end
function run!(jt::JTree)
  ccall( (:wrapdai_jt_run, libdai), None, (_JTree,), jt.hdl)
end
function iterations(jt::JTree)
  ccall( (:wrapdai_jt_iterations, libdai), Csize_t, (_JTree,), jt.hdl)
end
function properties(jt::JTree)
  ptr = ccall( (:wrapdai_jt_printProperties, libdai), Ptr{Uint8}, (_JTree,), jt.hdl)
  bytestring(ptr)
end
function marginal(jt::JTree, vs::VarSet)
  Factor(ccall( (:wrapdai_jt_calcMarginal, libdai), _Factor, (_JTree, _VarSet), jt.hdl, vs.hdl))
end
function belief(jt::JTree, vs::VarSet)
  Factor(ccall( (:wrapdai_jt_belief, libdai), _Factor, (_JTree, _VarSet), jt.hdl, vs.hdl))
end
############################
# PropertySet
############################
function wrapdai_ps_create(name)
  ccall( (:wrapdai_ps_create, libdai), _PropertySet, (Ptr{Uint8},), name)
end
function wrapdai_ps_delete(ps::_PropertySet)
  ccall( (:wrapdai_ps_delete, libdai), _PropertySet, (_PropertySet,), ps)
end
