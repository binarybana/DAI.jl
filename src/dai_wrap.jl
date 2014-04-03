# Julia wrapper for header: src/dai.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0
# and then hand modified by Jason Knight <jason@jasonknight.us>

#typealias ptrdiff_t Clong
#typealias size_t Culong
#typealias wchar_t Cint
typealias Var Void
typealias VarSet Void
typealias PropertySet Void
typealias Factor Void
typealias FactorGraph Void
typealias JTree Void

############################
# Var
############################
function wrapdai_var_create(label, states)
  ccall( (:wrapdai_var_create, libdai), Ptr{Var}, (Csize_t, Csize_t), label, states)
end
function wrapdai_var_destroy(hdl::Ptr{Var})
  ccall( (:wrapdai_var_destroy, libdai), None, (Ptr{Var},), hdl)
end
function wrapdai_var_label(hdl::Ptr{Var})
  ccall( (:wrapdai_var_label, libdai), Uint32, (Ptr{Var},), hdl)
end
function wrapdai_var_states(hdl::Ptr{Var})
  ccall( (:wrapdai_var_states, libdai), Uint32, (Ptr{Var},), hdl)
end
############################
# VarSet
############################
function wrapdai_varset_create()
  ccall( (:wrapdai_varset_create, libdai), Ptr{VarSet}, ())
end
function wrapdai_varset_delete(ps::Ptr{VarSet})
  ccall( (:wrapdai_varset_delete, libdai), None, (Ptr{VarSet},), ps)
end
function wrapdai_varset_insert(vs::Ptr{VarSet}, v::Ptr{Var})
  ccall( (:wrapdai_varset_insert, libdai), Ptr{VarSet}, (Ptr{VarSet}, Ptr{Var}), vs, v)
end
function wrapdai_varset_nrStates(vs::Ptr{VarSet})
  ccall( (:wrapdai_varset_nrStates, libdai), Cint, (Ptr{VarSet},), vs)
end
function wrapdai_varset_size(vs::Ptr{VarSet})
  ccall( (:wrapdai_varset_size, libdai), Cint, (Ptr{VarSet},), vs)
end
function wrapdai_varset_erase(vs::Ptr{VarSet}, v::Ptr{Var})
  ccall( (:wrapdai_varset_erase, libdai), Ptr{VarSet}, (Ptr{VarSet}, Ptr{Var}), vs, v)
end
function wrapdai_varset_remove(vs1::Ptr{VarSet}, vs2::Ptr{VarSet})
  ccall( (:wrapdai_varset_remove, libdai), Ptr{VarSet}, (Ptr{VarSet}, Ptr{VarSet}), vs1, vs2)
end
function wrapdai_varset_add(vs1::Ptr{VarSet}, vs2::Ptr{VarSet})
  ccall( (:wrapdai_varset_add, libdai), Ptr{VarSet}, (Ptr{VarSet}, Ptr{VarSet}), vs1, vs2)
end
function wrapdai_varset_calcLinearState(vs::Ptr{VarSet}, states)
  ccall( (:wrapdai_varset_calcLinearState, libdai), Csize_t, (Ptr{VarSet}, Ptr{Csize_t}), vs, uint64(states))
end
function wrapdai_varset_calcState(vs::Ptr{VarSet}, state)
  states = Array(Csize_t, wrapdai_varset_size(vs))
  ccall( (:wrapdai_varset_calcState, libdai), None, (Ptr{VarSet}, Csize_t, Ptr{Csize_t}), vs, state, states)
  return states
end
############################
# PropertySet
############################
function wrapdai_ps_create(name)
  ccall( (:wrapdai_ps_create, libdai), Ptr{PropertySet}, (Ptr{Uint8},), name)
end
function wrapdai_ps_delete(ps::Ptr{PropertySet})
  ccall( (:wrapdai_ps_delete, libdai), Ptr{PropertySet}, (Ptr{PropertySet},), ps)
end
############################
# Factor
############################
function wrapdai_factor_create_var(v::Ptr{Var})
  ccall( (:wrapdai_factor_create_var, libdai), Ptr{Factor}, (Ptr{Var},), v)
end
function wrapdai_factor_create_varset(vs::Ptr{VarSet})
  ccall( (:wrapdai_factor_create_varset, libdai), Ptr{Factor}, (Ptr{VarSet},), vs)
end
function wrapdai_factor_create_varset_vals(vs::Ptr{VarSet}, vals)
  ccall( (:wrapdai_factor_create_varset_vals, libdai), Ptr{Factor}, (Ptr{VarSet}, Ptr{Cdouble}), vs, vals)
end
function wrapdai_factor_delete(fac::Ptr{Factor})
  ccall( (:wrapdai_factor_delete, libdai), None, (Ptr{Factor},), fac)
end
function wrapdai_factor_set(fac::Ptr{Factor}, index, val)
  ccall( (:wrapdai_factor_set, libdai), None, (Ptr{Factor}, Csize_t, Cdouble), fac, index, val)
end
function wrapdai_factor_get(fac::Ptr{Factor}, index)
  ccall( (:wrapdai_factor_get, libdai), Cdouble, (Ptr{Factor}, Csize_t), fac, index)
end
function wrapdai_factor_vars(fac::Ptr{Factor})
  ccall( (:wrapdai_factor_vars, libdai), Ptr{VarSet}, (Ptr{Factor},), fac)
end
function wrapdai_factor_nrStates(fac::Ptr{Factor})
  ccall( (:wrapdai_factor_nrStates, libdai), Csize_t, (Ptr{Factor},), fac)
end
function wrapdai_factor_entropy(fac::Ptr{Factor})
  ccall( (:wrapdai_factor_entropy, libdai), Cdouble, (Ptr{Factor},), fac)
end
function wrapdai_factor_marginal(fac::Ptr{Factor}, vs::Ptr{VarSet})
  ccall( (:wrapdai_factor_marginal, libdai), Ptr{Factor}, (Ptr{Factor}, Ptr{VarSet}), fac, vs)
end
function wrapdai_factor_embed(fac::Ptr{Factor}, vs::Ptr{VarSet})
  ccall( (:wrapdai_factor_embed, libdai), Ptr{Factor}, (Ptr{Factor}, Ptr{VarSet}), fac, vs)
end
function wrapdai_factor_normalize(fac::Ptr{Factor})
  ccall( (:wrapdai_factor_normalize, libdai), Cdouble, (Ptr{Factor},), fac)
end
############################
# FactorGraph
############################
function wrapdai_fg_create_facs(facs)
  numfacs = length(facs)
  ccall( (:wrapdai_fg_create_facs, libdai), Ptr{FactorGraph}, (Ptr{Factor}, Cint), facs, numfacs)
end
function wrapdai_fg_var(fg::Ptr{FactorGraph}, ind::Csize_t)
  ccall( (:wrapdai_fg_var, libdai), Ptr{Var}, (Ptr{FactorGraph}, Csize_t), fg, ind)
end
function wrapdai_fg_vars(fg::Ptr{FactorGraph})
  ccall( (:wrapdai_fg_vars, libdai), Ptr{Ptr{Var}}, (Ptr{FactorGraph},), fg)
end
function wrapdai_fg_clone(fg::Ptr{FactorGraph})
  ccall( (:wrapdai_fg_clone, libdai), Ptr{FactorGraph}, (Ptr{FactorGraph},), fg)
end
function wrapdai_fg_nrVars(fg::Ptr{FactorGraph})
  ccall( (:wrapdai_fg_nrVars, libdai), Csize_t, (Ptr{FactorGraph},), fg)
end
function wrapdai_fg_nrFactors(fg::Ptr{FactorGraph})
  ccall( (:wrapdai_fg_nrFactors, libdai), Csize_t, (Ptr{FactorGraph},), fg)
end
function wrapdai_fg_nrEdges(fg::Ptr{FactorGraph})
  ccall( (:wrapdai_fg_nrEdges, libdai), Csize_t, (Ptr{FactorGraph},), fg)
end
function wrapdai_fg_factor(fg::Ptr{FactorGraph}, ind::Cint)
  ccall( (:wrapdai_fg_factor, libdai), Ptr{Factor}, (Ptr{FactorGraph}, Cint), fg, ind)
end
function wrapdai_fg_setFactor(fg::Ptr{FactorGraph}, ind::Cint, fac::Ptr{Factor})
  ccall( (:wrapdai_fg_setFactor, libdai), None, (Ptr{FactorGraph}, Cint, Ptr{Factor}), fg, ind, fac)
end
function wrapdai_fg_setFactor_bool(fg::Ptr{FactorGraph}, ind::Cint, fac::Ptr{Factor}, backup)
  ccall( (:wrapdai_fg_setFactor_bool, libdai), None, (Ptr{FactorGraph}, Cint, Ptr{Factor}, Cbool), fg, ind, fac, backup)
end
function wrapdai_fg_clearBackups(fg::Ptr{FactorGraph})
  ccall( (:wrapdai_fg_clearBackups, libdai), None, (Ptr{FactorGraph},), fg)
end
function wrapdai_fg_restoreFactors(fg::Ptr{FactorGraph})
  ccall( (:wrapdai_fg_restoreFactors, libdai), None, (Ptr{FactorGraph},), fg)
end
function wrapdai_fg_readFromFile(fg::Ptr{FactorGraph}, text::Ptr{Uint8})
  ccall( (:wrapdai_fg_readFromFile, libdai), None, (Ptr{FactorGraph}, Ptr{Uint8}), fg, text)
end
############################
# JunctionTree
############################
function wrapdai_jt_create_fgps(fg::Ptr{FactorGraph}, ps::Ptr{PropertySet})
  ccall( (:wrapdai_jt_create_fgps, libdai), Ptr{JTree}, (Ptr{FactorGraph}, Ptr{PropertySet}), fg, ps)
end
function wrapdai_jt_init(jt::Ptr{JTree})
  ccall( (:wrapdai_jt_init, libdai), None, (Ptr{JTree},), jt)
end
function wrapdai_jt_run(jt::Ptr{JTree})
  ccall( (:wrapdai_jt_run, libdai), None, (Ptr{JTree},), jt)
end
function wrapdai_jt_iterations(jt::Ptr{JTree})
  ccall( (:wrapdai_jt_iterations, libdai), Csize_t, (Ptr{JTree},), jt)
end
function wrapdai_jt_printProperties(jt::Ptr{JTree})
  ptr = ccall( (:wrapdai_jt_printProperties, libdai), Ptr{Uint8}, (Ptr{JTree},), jt)
  bytestring(ptr)
end
function wrapdai_jt_calcMarginal(jt::Ptr{JTree}, vs::Ptr{VarSet})
  ccall( (:wrapdai_jt_calcMarginal, libdai), Ptr{Factor}, (Ptr{JTree}, Ptr{VarSet}), jt, vs)
end
function wrapdai_jt_belief(jt::Ptr{JTree}, vs::Ptr{VarSet})
  ccall( (:wrapdai_jt_belief, libdai), Ptr{Factor}, (Ptr{JTree}, Ptr{VarSet}), jt, vs)
end
