# Julia wrapper for header: src/dai.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

function wrapdai_var_create(label::Csize_t, states::Csize_t)
  ccall( (:wrapdai_var_create, "src/libdaiwrap.so"), Ptr{Var}, (Csize_t, Csize_t), label, states)
end
function wrapdai_var_destroy(hdl::Ptr{Var})
  ccall( (:wrapdai_var_destroy, "src/libdaiwrap.so"), None, (Ptr{Var},), hdl)
end
function wrapdai_var_label(hdl::Ptr{Var})
  ccall( (:wrapdai_var_label, "src/libdaiwrap.so"), Uint32, (Ptr{Var},), hdl)
end
function wrapdai_var_states(hdl::Ptr{Var})
  ccall( (:wrapdai_var_states, "src/libdaiwrap.so"), Uint32, (Ptr{Var},), hdl)
end
function wrapdai_varset_delete(ps::Ptr{VarSet})
  ccall( (:wrapdai_varset_delete, "src/libdaiwrap.so"), None, (Ptr{VarSet},), ps)
end
function wrapdai_varset_insert(vs::Ptr{VarSet}, v::Ptr{Var})
  ccall( (:wrapdai_varset_insert, "src/libdaiwrap.so"), Ptr{VarSet}, (Ptr{VarSet}, Ptr{Var}), vs, v)
end
function wrapdai_varset_nrStates(vs::Ptr{VarSet})
  ccall( (:wrapdai_varset_nrStates, "src/libdaiwrap.so"), Cint, (Ptr{VarSet},), vs)
end
function wrapdai_varset_size(vs::Ptr{VarSet})
  ccall( (:wrapdai_varset_size, "src/libdaiwrap.so"), Cint, (Ptr{VarSet},), vs)
end
function wrapdai_varset_erase(vs::Ptr{VarSet}, v::Ptr{Var})
  ccall( (:wrapdai_varset_erase, "src/libdaiwrap.so"), Ptr{VarSet}, (Ptr{VarSet}, Ptr{Var}), vs, v)
end
function wrapdai_varset_remove(vs1::Ptr{VarSet}, vs2::Ptr{VarSet})
  ccall( (:wrapdai_varset_remove, "src/libdaiwrap.so"), Ptr{VarSet}, (Ptr{VarSet}, Ptr{VarSet}), vs1, vs2)
end
function wrapdai_varset_add(vs1::Ptr{VarSet}, vs2::Ptr{VarSet})
  ccall( (:wrapdai_varset_add, "src/libdaiwrap.so"), Ptr{VarSet}, (Ptr{VarSet}, Ptr{VarSet}), vs1, vs2)
end
function wrapdai_varset_calcLinearState(vs::Ptr{VarSet}, states::Ptr{Csize_t})
  ccall( (:wrapdai_varset_calcLinearState, "src/libdaiwrap.so"), Csize_t, (Ptr{VarSet}, Ptr{Csize_t}), vs, states)
end
function wrapdai_varset_calcState(vs::Ptr{VarSet}, state::Csize_t, states::Ptr{Csize_t})
  ccall( (:wrapdai_varset_calcState, "src/libdaiwrap.so"), None, (Ptr{VarSet}, Csize_t, Ptr{Csize_t}), vs, state, states)
end
function wrapdai_ps_create(name::Ptr{Uint8})
  ccall( (:wrapdai_ps_create, "src/libdaiwrap.so"), Ptr{PropertySet}, (Ptr{Uint8},), name)
end
function wrapdai_ps_delete(ps::Ptr{PropertySet})
  ccall( (:wrapdai_ps_delete, "src/libdaiwrap.so"), Ptr{PropertySet}, (Ptr{PropertySet},), ps)
end
function wrapdai_factor_create_var(v::Ptr{Var})
  ccall( (:wrapdai_factor_create_var, "src/libdaiwrap.so"), Ptr{Factor}, (Ptr{Var},), v)
end
function wrapdai_factor_create_varset(vs::Ptr{VarSet})
  ccall( (:wrapdai_factor_create_varset, "src/libdaiwrap.so"), Ptr{Factor}, (Ptr{VarSet},), vs)
end
function wrapdai_factor_create_varset_vals(vs::Ptr{VarSet}, vals::Ptr{Cdouble})
  ccall( (:wrapdai_factor_create_varset_vals, "src/libdaiwrap.so"), Ptr{Factor}, (Ptr{VarSet}, Ptr{Cdouble}), vs, vals)
end
function wrapdai_factor_delete(fac::Ptr{Factor})
  ccall( (:wrapdai_factor_delete, "src/libdaiwrap.so"), None, (Ptr{Factor},), fac)
end
function wrapdai_factor_set(fac::Ptr{Factor}, index::Csize_t, val::Cdouble)
  ccall( (:wrapdai_factor_set, "src/libdaiwrap.so"), None, (Ptr{Factor}, Csize_t, Cdouble), fac, index, val)
end
function wrapdai_factor_get(fac::Ptr{Factor}, index::Csize_t)
  ccall( (:wrapdai_factor_get, "src/libdaiwrap.so"), Cdouble, (Ptr{Factor}, Csize_t), fac, index)
end
function wrapdai_factor_vars(fac::Ptr{Factor})
  ccall( (:wrapdai_factor_vars, "src/libdaiwrap.so"), Ptr{VarSet}, (Ptr{Factor},), fac)
end
function wrapdai_factor_nrStates(fac::Ptr{Factor})
  ccall( (:wrapdai_factor_nrStates, "src/libdaiwrap.so"), Csize_t, (Ptr{Factor},), fac)
end
function wrapdai_factor_entropy(fac::Ptr{Factor})
  ccall( (:wrapdai_factor_entropy, "src/libdaiwrap.so"), Cdouble, (Ptr{Factor},), fac)
end
function wrapdai_factor_marginal(fac::Ptr{Factor}, vs::Ptr{VarSet})
  ccall( (:wrapdai_factor_marginal, "src/libdaiwrap.so"), Ptr{Factor}, (Ptr{Factor}, Ptr{VarSet}), fac, vs)
end
function wrapdai_factor_embed(fac::Ptr{Factor}, vs::Ptr{VarSet})
  ccall( (:wrapdai_factor_embed, "src/libdaiwrap.so"), Ptr{Factor}, (Ptr{Factor}, Ptr{VarSet}), fac, vs)
end
function wrapdai_factor_normalize(fac::Ptr{Factor})
  ccall( (:wrapdai_factor_normalize, "src/libdaiwrap.so"), Cdouble, (Ptr{Factor},), fac)
end
function wrapdai_fg_create_facs(facs::Ptr{Ptr{Factor}}, numfacs::Cint)
  ccall( (:wrapdai_fg_create_facs, "src/libdaiwrap.so"), Ptr{FactorGraph}, (Ptr{Ptr{Factor}}, Cint), facs, numfacs)
end
function wrapdai_fg_var(fg::Ptr{FactorGraph}, ind::Csize_t)
  ccall( (:wrapdai_fg_var, "src/libdaiwrap.so"), Ptr{Var}, (Ptr{FactorGraph}, Csize_t), fg, ind)
end
function wrapdai_fg_vars(fg::Ptr{FactorGraph})
  ccall( (:wrapdai_fg_vars, "src/libdaiwrap.so"), Ptr{Ptr{Var}}, (Ptr{FactorGraph},), fg)
end
function wrapdai_fg_clone(fg::Ptr{FactorGraph})
  ccall( (:wrapdai_fg_clone, "src/libdaiwrap.so"), Ptr{FactorGraph}, (Ptr{FactorGraph},), fg)
end
function wrapdai_fg_nrVars(fg::Ptr{FactorGraph})
  ccall( (:wrapdai_fg_nrVars, "src/libdaiwrap.so"), Csize_t, (Ptr{FactorGraph},), fg)
end
function wrapdai_fg_nrFactors(fg::Ptr{FactorGraph})
  ccall( (:wrapdai_fg_nrFactors, "src/libdaiwrap.so"), Csize_t, (Ptr{FactorGraph},), fg)
end
function wrapdai_fg_nrEdges(fg::Ptr{FactorGraph})
  ccall( (:wrapdai_fg_nrEdges, "src/libdaiwrap.so"), Csize_t, (Ptr{FactorGraph},), fg)
end
function wrapdai_fg_factor(fg::Ptr{FactorGraph}, ind::Cint)
  ccall( (:wrapdai_fg_factor, "src/libdaiwrap.so"), Ptr{Factor}, (Ptr{FactorGraph}, Cint), fg, ind)
end
function wrapdai_fg_setFactor(fg::Ptr{FactorGraph}, ind::Cint, fac::Ptr{Factor})
  ccall( (:wrapdai_fg_setFactor, "src/libdaiwrap.so"), None, (Ptr{FactorGraph}, Cint, Ptr{Factor}), fg, ind, fac)
end
function wrapdai_fg_setFactor_bool(fg::Ptr{FactorGraph}, ind::Cint, fac::Ptr{Factor}, backup::bool)
  ccall( (:wrapdai_fg_setFactor_bool, "src/libdaiwrap.so"), None, (Ptr{FactorGraph}, Cint, Ptr{Factor}, bool), fg, ind, fac, backup)
end
function wrapdai_fg_clearBackups(fg::Ptr{FactorGraph})
  ccall( (:wrapdai_fg_clearBackups, "src/libdaiwrap.so"), None, (Ptr{FactorGraph},), fg)
end
function wrapdai_fg_restoreFactors(fg::Ptr{FactorGraph})
  ccall( (:wrapdai_fg_restoreFactors, "src/libdaiwrap.so"), None, (Ptr{FactorGraph},), fg)
end
function wrapdai_fg_readFromFile(fg::Ptr{FactorGraph}, text::Ptr{Uint8})
  ccall( (:wrapdai_fg_readFromFile, "src/libdaiwrap.so"), None, (Ptr{FactorGraph}, Ptr{Uint8}), fg, text)
end
function wrapdai_jt_create_fgps(fg::Ptr{FactorGraph}, ps::Ptr{PropertySet})
  ccall( (:wrapdai_jt_create_fgps, "src/libdaiwrap.so"), Ptr{JTree}, (Ptr{FactorGraph}, Ptr{PropertySet}), fg, ps)
end
function wrapdai_jt_init(jt::Ptr{JTree})
  ccall( (:wrapdai_jt_init, "src/libdaiwrap.so"), None, (Ptr{JTree},), jt)
end
function wrapdai_jt_run(jt::Ptr{JTree})
  ccall( (:wrapdai_jt_run, "src/libdaiwrap.so"), None, (Ptr{JTree},), jt)
end
function wrapdai_jt_iterations(jt::Ptr{JTree})
  ccall( (:wrapdai_jt_iterations, "src/libdaiwrap.so"), Csize_t, (Ptr{JTree},), jt)
end
function wrapdai_jt_printProperties(jt::Ptr{JTree})
  ptr = ccall( (:wrapdai_jt_printProperties, "src/libdaiwrap.so"), Ptr{Uint8}, (Ptr{JTree},), jt)
  bytestring(ptr)
end
function wrapdai_jt_calcMarginal(jt::Ptr{JTree}, vs::Ptr{VarSet})
  ccall( (:wrapdai_jt_calcMarginal, "src/libdaiwrap.so"), Ptr{Factor}, (Ptr{JTree}, Ptr{VarSet}), jt, vs)
end
function wrapdai_jt_belief(jt::Ptr{JTree}, vs::Ptr{VarSet})
  ccall( (:wrapdai_jt_belief, "src/libdaiwrap.so"), Ptr{Factor}, (Ptr{JTree}, Ptr{VarSet}), jt, vs)
end

