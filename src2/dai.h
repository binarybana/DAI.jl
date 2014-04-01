typedef struct Var Var;
typedef struct VarSet VarSet;
typedef struct PropertySet PropertySet;

Var* wrapdai_var_create(int label, int states);
void wrapdai_var_destroy(Var *hdl);
unsigned int wrapdai_var_label(Var *hdl);
unsigned int wrapdai_var_states(Var *hdl);

VarSet* wrapdai_varset_create();
void wrapdai_varset_delete(VarSet *ps);
VarSet* wrapdai_varset_insert(VarSet *vs, Var *v);
int wrapdai_varset_nrStates(VarSet *vs);
int wrapdai_varset_size(VarSet *vs);
VarSet* wrapdai_varset_erase(VarSet *vs, Var *v);
VarSet* wrapdai_varset_remove(VarSet *vs1, VarSet *vs2);
VarSet* wrapdai_varset_add(VarSet *vs1, VarSet *vs2);

//cdef extern from "dai/properties.h" namespace "dai":
    //cdef cppclass PropertySet:
        //PropertySet()
        //PropertySet(string)

PropertySet* wrapdai_propertyset_create(const char *name);
PropertySet* wrapdai_propertyset_delete(PropertySet *ps);
