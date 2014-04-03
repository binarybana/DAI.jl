# Julia wrapper for header: src/dai.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0
# and then hand modified by Jason Knight <jason@jasonknight.us>

#typealias ptrdiff_t Clong
#typealias size_t Culong
#typealias wchar_t Cint
import Base.length, Base.getindex, Base.setindex!, Base.copy

export Var, label, states
export VarSet, insert!, nrStates, calcLinearState, calcState
export Factor, vars, entropy, embed, normalize!
export FactorGraph, numVars, numFactors, numEdges, setFactor, clearBackups!, restoreFactors!, readFromFile
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
function calcLinearState(vs::VarSet, states)
  ccall( (:wrapdai_varset_calcLinearState, libdai), Csize_t, (_VarSet, Ptr{Csize_t}), vs.hdl, uint64(states))
end
function calcState(vs::VarSet, state)
  states = Array(Csize_t, length(vs))
  ccall( (:wrapdai_varset_calcState, libdai), None, (_VarSet, Csize_t, Ptr{Csize_t}), vs.hdl, state, states)
  return states
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
  Factor(ccall( (:wrapdai_factor_create_varset_vals, libdai), _Factor, (_VarSet, Ptr{Cdouble}), vs.hdl, vals))
end

function wrapdai_factor_delete(fac::Factor)
  ccall( (:wrapdai_factor_delete, libdai), None, (_Factor,), fac.hdl)
end

function setindex!(fac::Factor, val, index)
  ccall( (:wrapdai_factor_set, libdai), None, (_Factor, Csize_t, Cdouble), fac.hdl, index, val)
end
function getindex(fac::Factor, index)
  ccall( (:wrapdai_factor_get, libdai), Cdouble, (_Factor, Csize_t), fac.hdl, index)
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
  ccall( (:wrapdai_factor_embed, libdai), _Factor, (_Factor, _VarSet), fac.hdl, vs.hdl)
end
function normalize!(fac::Factor)
  ccall( (:wrapdai_factor_normalize, libdai), Cdouble, (_Factor,), fac.hdl)
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

function getindex(fg::FactorGraph, ind)
  Var(ccall( (:wrapdai_fg_var, libdai), _Var, (_FactorGraph, Csize_t), fg.hdl, ind))
end
function vars(fg::FactorGraph)
  FactorGraph(ccall( (:wrapdai_fg_vars, libdai), Ptr{_Var}, (_FactorGraph,), fg.hdl))
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
  Factor(ccall( (:wrapdai_fg_factor, libdai), _Factor, (_FactorGraph, Cint), fg.hdl, ind))
end
function setindex!(fg::FactorGraph, fac::Factor, ind)
  ccall( (:wrapdai_fg_setCFactor, libdai), None, (_FactorGraph, Cint, _Factor), fg.hdl, ind, fac.hdl)
end
function setFactor(fg::FactorGraph, ind, fac::Factor, backup::Bool)
  ccall( (:wrapdai_fg_setCFactor_bool, libdai), None, 
    (_FactorGraph, Cint, _Factor, Cbool), fg.hdl, ind, fac.hdl, backup)
end
function clearBackups!(fg::FactorGraph)
  ccall( (:wrapdai_fg_clearBackups, libdai), None, (_FactorGraph,), fg.hdl)
end
function restoreFactors!(fg::FactorGraph)
  ccall( (:wrapdai_fg_restoreCFactors, libdai), None, (_FactorGraph,), fg.hdl)
end
function readFromFile(fg::FactorGraph, text)
  FactorGraph(ccall( (:wrapdai_fg_readFromFile, libdai), 
    None, (_FactorGraph, Ptr{Uint8}), fg.hdl, text))
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
