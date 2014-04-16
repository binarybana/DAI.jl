# Julia wrapper for header: src/dai.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0
# and then hand modified by Jason Knight <jason@jasonknight.us>

#typealias ptrdiff_t Clong
#typealias size_t Culong
#typealias wchar_t Cint
import Base: length, getindex, setindex!, copy, isequal, in, show, isless

export Var, label, states
export VarSet, insert!, labels, nrStates, calcLinearState, calcState, conditionalState
export Factor, vars, entropy, embed, normalize!, p
export FactorGraph, numVars, numFactors, numEdges, setBackedFactor!, clearBackups!, restoreFactors!, readFromFile
export JTree, init!, run!, iterations, properties, marginal, belief

typealias _Var Ptr{Void}
typealias _VarSet Ptr{Void}
typealias _PropertySet Ptr{Void}
typealias _Factor Ptr{Void}
typealias _FactorGraph Ptr{Void}
typealias _JTree Ptr{Void}

############################
# Var
############################

type Var
  hdl::_Var
  function Var(hdl::_Var)
    v = new(hdl)
    finalizer(v, wrapdai_var_destroy)
    v
  end
end

function Var(label, states)
  assert(label>=0)
  assert(states>0)
  hdl = ccall( (:wrapdai_var_create, libdai), _Var, (Csize_t, Csize_t), label, states)
  return Var(hdl)
end

function wrapdai_var_destroy(x::Var)
  ccall( (:wrapdai_var_destroy, libdai), None, (_Var,), x.hdl)
end

function label(x::Var)
  int(ccall( (:wrapdai_var_label, libdai), Uint32, (_Var,), x.hdl))
end
function states(x::Var)
  int(ccall( (:wrapdai_var_states, libdai), Uint32, (_Var,), x.hdl))
end
function isequal(v1::Var, v2::Var)
  label(v1) == label(v2)
end
function show(io::IO, v::Var)
  print(io, "Var(label=$(label(v)), states=$(states(v)))")
end


############################
# VarSet
############################
type VarSet
  hdl::_VarSet
  function VarSet(hdl::_VarSet)
    v = new(hdl)
    finalizer(v, wrapdai_varset_delete)
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
    ccall( (:wrapdai_varset_insert, libdai), _VarSet, (_VarSet, _Var), vsp, var.hdl)
  end
  VarSet(vsp)
end
function +(v1::Var, v2::Var)
  VarSet(v1,v2)
end

function wrapdai_varset_delete(x::VarSet)
  ccall( (:wrapdai_varset_delete, libdai), None, (_VarSet,), x.hdl)
end

function insert!(vs::VarSet, v::Var)
  ccall( (:wrapdai_varset_insert, libdai), _VarSet, (_VarSet, _Var), vs.hdl, v.hdl)
  nothing
end
function labels(vs::VarSet)
  ptrs = pointer_to_array(ccall( (:wrapdai_varset_vars, libdai), Ptr{_Var}, (_VarSet,), vs.hdl), 
    int(length(vs)))
  [int(ccall( (:wrapdai_var_label, libdai), Uint32, (_Var,), x)) for x in ptrs]
end
function nrStates(vs::VarSet)
  ccall( (:wrapdai_varset_nrStates, libdai), Cint, (_VarSet,), vs.hdl)
end
function length(vs::VarSet)
  ccall( (:wrapdai_varset_size, libdai), Cint, (_VarSet,), vs.hdl)
end
function erase!(vs::VarSet, v::Var)
  ccall( (:wrapdai_varset_erase, libdai), _VarSet, (_VarSet, _Var), vs.hdl, v.hdl)
  nothing
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
  VarSet(ccall( (:wrapdai_varset_add_one, libdai), _VarSet, (_VarSet, _Var), vs.hdl, v.hdl))
end
function -(vs1::VarSet, vs2::VarSet)
  VarSet(ccall( (:wrapdai_varset_sub, libdai), _VarSet, (_VarSet, _VarSet), vs1.hdl, vs2.hdl))
end
function -(vs::VarSet, v::Var)
  VarSet(ccall( (:wrapdai_varset_sub_one, libdai), _VarSet, (_VarSet, _Var), vs.hdl, v.hdl))
end

function calcLinearState(vs::VarSet, statevals)
  all(0 .< statevals .<= [states(v) for v=vars(vs)]) || throw(BoundsError())
  assert(length(vs) == length(statevals))
  1+ccall( (:wrapdai_varset_calcLinearState, libdai), Csize_t, 
    (_VarSet, Ptr{Csize_t}, _VarSet), vs.hdl, uint64(statevals).-1, C_NULL)
end

function calcLinearState(vs::VarSet, statevals, orig::VarSet)
  all(0 .< statevals .<= [states(v) for v=vars(orig)]) || throw(BoundsError())
  assert(length(orig) == length(statevals))
  1+ccall( (:wrapdai_varset_calcLinearState, libdai), Csize_t, 
    (_VarSet, Ptr{Csize_t}, _VarSet), vs.hdl, uint64(statevals).-1, orig.hdl)
end

function calcState(vs::VarSet, state::Integer)
  0 < state <= nrStates(vs) || throw(BoundsError())
  states = Array(Csize_t, length(vs))
  ccall( (:wrapdai_varset_calcState, libdai), None, (_VarSet, Csize_t, Ptr{Csize_t}), 
    vs.hdl, state-1, states)
  return states .+ 1
end

function conditionalState(v::Var, pars::VarSet, vstate::Int, parstate::Int)
  1 + ccall( (:wrapdai_varset_conditionalState, libdai), Csize_t, 
    (_Var, _VarSet, Csize_t, Csize_t), 
    v.hdl, pars.hdl, vstate-1, parstate-1)
end

function in(v::Var, vs::VarSet)
  ccall( (:wrapdai_varset_contains, libdai), Bool, (_VarSet, _Var), vs.hdl, v.hdl)
end
function isequal(vs1::VarSet, vs2::VarSet)
  ccall( (:wrapdai_varset_isequal, libdai), Bool, (_VarSet, _VarSet), vs1.hdl, vs2.hdl)
end
function isless(vs1::VarSet, vs2::VarSet)
  ccall( (:wrapdai_varset_isless, libdai), Bool, (_VarSet, _VarSet), vs1.hdl, vs2.hdl)
end
function vars(vs::VarSet)
  map(Var, pointer_to_array(ccall( (:wrapdai_varset_vars, libdai), Ptr{_Var}, (_VarSet,), vs.hdl), 
    int(length(vs))))
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
    return Factor(ccall( (:wrapdai_factor_create_var, libdai), _Factor, (_Var,), v[1].hdl))
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
  ptrs = pointer_to_array(ccall( (:wrapdai_varset_vars, libdai), Ptr{_Var}, (_VarSet,), vsp), 
    int(lvsp))
  [int(ccall( (:wrapdai_var_label, libdai), Uint32, (_Var,), x)) for x in ptrs]
end
function setindex!(fac::Factor, val, index)
  0 < index <= nrStates(fac) || throw(BoundsError())
  ccall( (:wrapdai_factor_set, libdai), None, (_Factor, Csize_t, Cdouble), fac.hdl, index-1, val)
end
function getindex(fac::Factor, index)
  0 < index <= nrStates(fac) || throw(BoundsError())
  ccall( (:wrapdai_factor_get, libdai), Cdouble, (_Factor, Csize_t), fac.hdl, index-1)
end
function vars(fac::Factor)
  VarSet(ccall( (:wrapdai_factor_vars, libdai), _VarSet, (_Factor,), fac.hdl))
end
function nrStates(fac::Factor)
  int(ccall( (:wrapdai_factor_nrStates, libdai), Csize_t, (_Factor,), fac.hdl))
end
function entropy(fac::Factor)
  ccall( (:wrapdai_factor_entropy, libdai), Cdouble, (_Factor,), fac.hdl)
end
function marginal(fac::Factor, vs::VarSet)
  Factor(ccall( (:wrapdai_factor_marginal, libdai), _Factor, (_Factor, _VarSet), fac.hdl, vs.hdl))
end
function embed(fac::Factor, vs::VarSet)
  Factor(ccall( (:wrapdai_factor_embed, libdai), _Factor, (_Factor, _VarSet), fac.hdl, vs.hdl))
end
function normalize!(fac::Factor)
  ccall( (:wrapdai_factor_normalize, libdai), Cdouble, (_Factor,), fac.hdl)
end
function isequal(fac1::Factor, fac2::Factor)
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
  map(Var, pointer_to_array(
    (ccall( (:wrapdai_fg_vars, libdai), Ptr{_Var}, (_FactorGraph,), fg.hdl)),
    (numVars(fg),),
    false))
end
function copy(fg::FactorGraph)
  FactorGraph(ccall( (:wrapdai_fg_clone, libdai), _FactorGraph, (_FactorGraph,), fg.hdl))
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
function setBackedFactor!(fg::FactorGraph, ind, fac::Factor)
  0 < ind <= numFactors(fg) || throw(BoundsError())
  ccall( (:wrapdai_fg_setFactor_backup, libdai), None, 
    (_FactorGraph, Cint, _Factor), fg.hdl, ind-1, fac.hdl)
end
function getVar(fg::FactorGraph, ind)
  0 < ind <= numVars(fg) || throw(BoundsError())
  Var(ccall( (:wrapdai_fg_var, libdai), _Var, (_FactorGraph, Csize_t), fg.hdl, ind-1))
end
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
  ccall( (:wrapdai_jt_belief, libdai), _Factor, (_JTree, _VarSet), jt.hdl, vs.hdl)
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
