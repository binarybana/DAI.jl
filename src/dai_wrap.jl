# Julia wrapper for header: src/dai.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0
# and then hand modified by Jason Knight <jason@jasonknight.us>

#typealias ptrdiff_t Clong
#typealias size_t Culong
#typealias wchar_t Cint
typealias CVar Void
typealias CVarSet Void
typealias CPropertySet Void
typealias CFactor Void
typealias CFactorGraph Void
typealias CJTree Void


############################
# Var
############################
export Var, var_label, var_states
type Var
  hdl::Ptr{CVar}
end

function Var(label, states)
  assert(label>=0)
  assert(states>0)
  Var(ccall( (:wrapdai_var_create, libdai), Ptr{CVar}, (Csize_t, Csize_t), label, states))
end

function wrapdai_var_destroy(x::Var)
  ccall( (:wrapdai_var_destroy, libdai), None, (Ptr{CVar},), x.hdl)
end
finalizer(Var, wrapdai_var_destroy)

function var_label(x::Var)
  ccall( (:wrapdai_var_label, libdai), Uint32, (Ptr{CVar},), x.hdl)
end
function var_states(X::Var)
  ccall( (:wrapdai_var_states, libdai), Uint32, (Ptr{CVar},), x.hdl)
end
############################
# VarSet
############################
function wrapdai_varset_create()
  ccall( (:wrapdai_varset_create, libdai), Ptr{CVarSet}, ())
end
function wrapdai_varset_delete(ps::Ptr{CVarSet})
  ccall( (:wrapdai_varset_delete, libdai), None, (Ptr{CVarSet},), ps)
end
function wrapdai_varset_insert(vs::Ptr{CVarSet}, v::Ptr{CVar})
  ccall( (:wrapdai_varset_insert, libdai), Ptr{CVarSet}, (Ptr{CVarSet}, Ptr{CVar}), vs, v)
end
function wrapdai_varset_nrStates(vs::Ptr{CVarSet})
  ccall( (:wrapdai_varset_nrStates, libdai), Cint, (Ptr{CVarSet},), vs)
end
function wrapdai_varset_size(vs::Ptr{CVarSet})
  ccall( (:wrapdai_varset_size, libdai), Cint, (Ptr{CVarSet},), vs)
end
function wrapdai_varset_erase(vs::Ptr{CVarSet}, v::Ptr{CVar})
  ccall( (:wrapdai_varset_erase, libdai), Ptr{CVarSet}, (Ptr{CVarSet}, Ptr{CVar}), vs, v)
end
function wrapdai_varset_remove(vs1::Ptr{CVarSet}, vs2::Ptr{CVarSet})
  ccall( (:wrapdai_varset_remove, libdai), Ptr{CVarSet}, (Ptr{CVarSet}, Ptr{CVarSet}), vs1, vs2)
end
function wrapdai_varset_add(vs1::Ptr{CVarSet}, vs2::Ptr{CVarSet})
  ccall( (:wrapdai_varset_add, libdai), Ptr{CVarSet}, (Ptr{CVarSet}, Ptr{CVarSet}), vs1, vs2)
end
function wrapdai_varset_calcLinearState(vs::Ptr{CVarSet}, states)
  ccall( (:wrapdai_varset_calcLinearState, libdai), Csize_t, (Ptr{CVarSet}, Ptr{Csize_t}), vs, uint64(states))
end
function wrapdai_varset_calcState(vs::Ptr{CVarSet}, state)
  states = Array(Csize_t, wrapdai_varset_size(vs))
  ccall( (:wrapdai_varset_calcState, libdai), None, (Ptr{CVarSet}, Csize_t, Ptr{Csize_t}), vs, state, states)
  return states
end
############################
# PropertySet
############################
function wrapdai_ps_create(name)
  ccall( (:wrapdai_ps_create, libdai), Ptr{CPropertySet}, (Ptr{Uint8},), name)
end
function wrapdai_ps_delete(ps::Ptr{CPropertySet})
  ccall( (:wrapdai_ps_delete, libdai), Ptr{CPropertySet}, (Ptr{CPropertySet},), ps)
end
############################
# Factor
############################
function wrapdai_factor_create_var(v::Ptr{CVar})
  ccall( (:wrapdai_factor_create_var, libdai), Ptr{CFactor}, (Ptr{CVar},), v)
end
function wrapdai_factor_create_varset(vs::Ptr{CVarSet})
  ccall( (:wrapdai_factor_create_varset, libdai), Ptr{CFactor}, (Ptr{CVarSet},), vs)
end
function wrapdai_factor_create_varset_vals(vs::Ptr{CVarSet}, vals)
  ccall( (:wrapdai_factor_create_varset_vals, libdai), Ptr{CFactor}, (Ptr{CVarSet}, Ptr{Cdouble}), vs, vals)
end
function wrapdai_factor_delete(fac::Ptr{CFactor})
  ccall( (:wrapdai_factor_delete, libdai), None, (Ptr{CFactor},), fac)
end
function wrapdai_factor_set(fac::Ptr{CFactor}, index, val)
  ccall( (:wrapdai_factor_set, libdai), None, (Ptr{CFactor}, Csize_t, Cdouble), fac, index, val)
end
function wrapdai_factor_get(fac::Ptr{CFactor}, index)
  ccall( (:wrapdai_factor_get, libdai), Cdouble, (Ptr{CFactor}, Csize_t), fac, index)
end
function wrapdai_factor_vars(fac::Ptr{CFactor})
  ccall( (:wrapdai_factor_vars, libdai), Ptr{CVarSet}, (Ptr{CFactor},), fac)
end
function wrapdai_factor_nrStates(fac::Ptr{CFactor})
  ccall( (:wrapdai_factor_nrStates, libdai), Csize_t, (Ptr{CFactor},), fac)
end
function wrapdai_factor_entropy(fac::Ptr{CFactor})
  ccall( (:wrapdai_factor_entropy, libdai), Cdouble, (Ptr{CFactor},), fac)
end
function wrapdai_factor_marginal(fac::Ptr{CFactor}, vs::Ptr{CVarSet})
  ccall( (:wrapdai_factor_marginal, libdai), Ptr{CFactor}, (Ptr{CFactor}, Ptr{CVarSet}), fac, vs)
end
function wrapdai_factor_embed(fac::Ptr{CFactor}, vs::Ptr{CVarSet})
  ccall( (:wrapdai_factor_embed, libdai), Ptr{CFactor}, (Ptr{CFactor}, Ptr{CVarSet}), fac, vs)
end
function wrapdai_factor_normalize(fac::Ptr{CFactor})
  ccall( (:wrapdai_factor_normalize, libdai), Cdouble, (Ptr{CFactor},), fac)
end
############################
# FactorGraph
############################
function wrapdai_fg_create_facs(facs)
  numfacs = length(facs)
  ccall( (:wrapdai_fg_create_facs, libdai), Ptr{CFactorGraph}, (Ptr{CFactor}, Cint), facs, numfacs)
end
function wrapdai_fg_var(fg::Ptr{CFactorGraph}, ind::Csize_t)
  ccall( (:wrapdai_fg_var, libdai), Ptr{CVar}, (Ptr{CFactorGraph}, Csize_t), fg, ind)
end
function wrapdai_fg_vars(fg::Ptr{CFactorGraph})
  ccall( (:wrapdai_fg_vars, libdai), Ptr{Ptr{CVar}}, (Ptr{CFactorGraph},), fg)
end
function wrapdai_fg_clone(fg::Ptr{CFactorGraph})
  ccall( (:wrapdai_fg_clone, libdai), Ptr{CFactorGraph}, (Ptr{CFactorGraph},), fg)
end
function wrapdai_fg_nrVars(fg::Ptr{CFactorGraph})
  ccall( (:wrapdai_fg_nrVars, libdai), Csize_t, (Ptr{CFactorGraph},), fg)
end
function wrapdai_fg_nrCFactors(fg::Ptr{CFactorGraph})
  ccall( (:wrapdai_fg_nrCFactors, libdai), Csize_t, (Ptr{CFactorGraph},), fg)
end
function wrapdai_fg_nrEdges(fg::Ptr{CFactorGraph})
  ccall( (:wrapdai_fg_nrEdges, libdai), Csize_t, (Ptr{CFactorGraph},), fg)
end
function wrapdai_fg_factor(fg::Ptr{CFactorGraph}, ind::Cint)
  ccall( (:wrapdai_fg_factor, libdai), Ptr{CFactor}, (Ptr{CFactorGraph}, Cint), fg, ind)
end
function wrapdai_fg_setCFactor(fg::Ptr{CFactorGraph}, ind::Cint, fac::Ptr{CFactor})
  ccall( (:wrapdai_fg_setCFactor, libdai), None, (Ptr{CFactorGraph}, Cint, Ptr{CFactor}), fg, ind, fac)
end
function wrapdai_fg_setCFactor_bool(fg::Ptr{CFactorGraph}, ind::Cint, fac::Ptr{CFactor}, backup)
  ccall( (:wrapdai_fg_setCFactor_bool, libdai), None, (Ptr{CFactorGraph}, Cint, Ptr{CFactor}, Cbool), fg, ind, fac, backup)
end
function wrapdai_fg_clearBackups(fg::Ptr{CFactorGraph})
  ccall( (:wrapdai_fg_clearBackups, libdai), None, (Ptr{CFactorGraph},), fg)
end
function wrapdai_fg_restoreCFactors(fg::Ptr{CFactorGraph})
  ccall( (:wrapdai_fg_restoreCFactors, libdai), None, (Ptr{CFactorGraph},), fg)
end
function wrapdai_fg_readFromFile(fg::Ptr{CFactorGraph}, text::Ptr{Uint8})
  ccall( (:wrapdai_fg_readFromFile, libdai), None, (Ptr{CFactorGraph}, Ptr{Uint8}), fg, text)
end
############################
# JunctionTree
############################
function wrapdai_jt_create_fgps(fg::Ptr{CFactorGraph}, ps::Ptr{CPropertySet})
  ccall( (:wrapdai_jt_create_fgps, libdai), Ptr{CJTree}, (Ptr{CFactorGraph}, Ptr{CPropertySet}), fg, ps)
end
function wrapdai_jt_init(jt::Ptr{CJTree})
  ccall( (:wrapdai_jt_init, libdai), None, (Ptr{CJTree},), jt)
end
function wrapdai_jt_run(jt::Ptr{CJTree})
  ccall( (:wrapdai_jt_run, libdai), None, (Ptr{CJTree},), jt)
end
function wrapdai_jt_iterations(jt::Ptr{CJTree})
  ccall( (:wrapdai_jt_iterations, libdai), Csize_t, (Ptr{CJTree},), jt)
end
function wrapdai_jt_printProperties(jt::Ptr{CJTree})
  ptr = ccall( (:wrapdai_jt_printProperties, libdai), Ptr{Uint8}, (Ptr{CJTree},), jt)
  bytestring(ptr)
end
function wrapdai_jt_calcMarginal(jt::Ptr{CJTree}, vs::Ptr{CVarSet})
  ccall( (:wrapdai_jt_calcMarginal, libdai), Ptr{CFactor}, (Ptr{CJTree}, Ptr{CVarSet}), jt, vs)
end
function wrapdai_jt_belief(jt::Ptr{CJTree}, vs::Ptr{CVarSet})
  ccall( (:wrapdai_jt_belief, libdai), Ptr{CFactor}, (Ptr{CJTree}, Ptr{CVarSet}), jt, vs)
end
