# Julia wrapper for header: src/dai.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

function wrapdai_var_create(label::Cint, states::Cint)
  ccall( (:wrapdai_var_create, "src/libdaiwrap.so"), Ptr{Var}, (Cint, Cint), label, states)
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
function wrapdai_propertyset_create(name::Ptr{Uint8})
  ccall( (:wrapdai_propertyset_create, "src/libdaiwrap.so"), Ptr{PropertySet}, (Ptr{Uint8},), name)
end
function wrapdai_propertyset_delete(ps::Ptr{PropertySet})
  ccall( (:wrapdai_propertyset_delete, "src/libdaiwrap.so"), Ptr{PropertySet}, (Ptr{PropertySet},), ps)
end

