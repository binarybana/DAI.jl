#include <stddef.h>

typedef struct Var Var;
typedef struct VarSet VarSet;
typedef struct PropertySet PropertySet;
typedef struct Factor Factor;
typedef struct FactorGraph FactorGraph;
typedef struct bool bool;
typedef struct JTree JTree;

Var* wrapdai_var_create(size_t label, size_t states);
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

size_t wrapdai_varset_calcLinearState(VarSet *vs, size_t *states);
void wrapdai_varset_calcState(VarSet *vs, size_t state, /*Var **vars,*/ size_t *states);
//cdef extern from "dai/properties.h" namespace "dai":
    //cdef cppclass PropertySet:
        //PropertySet()
        //PropertySet(string)

PropertySet* wrapdai_ps_create(const char *name);
PropertySet* wrapdai_ps_delete(PropertySet *ps);


Factor* wrapdai_factor_create_empty() ;
Factor* wrapdai_factor_create_var(Var *v) ;
Factor* wrapdai_factor_create_varset(VarSet *vs) ;
Factor* wrapdai_factor_create_varset_vals(VarSet *vs, double *vals);
void wrapdai_factor_delete(Factor *fac) ;
void wrapdai_factor_set(Factor *fac, size_t index, double val) ;
double wrapdai_factor_get(Factor *fac, size_t index) ;
VarSet* wrapdai_factor_vars(Factor *fac) ;
size_t wrapdai_factor_nrStates(Factor *fac) ;
double wrapdai_factor_entropy(Factor *fac);
Factor* wrapdai_factor_marginal(Factor *fac, VarSet *vs);
Factor* wrapdai_factor_embed(Factor *fac, VarSet *vs);
double wrapdai_factor_normalize(Factor *fac);


FactorGraph* wrapdai_fg_create();
FactorGraph* wrapdai_fg_create_facs(Factor **facs, int numfacs);
Var* wrapdai_fg_var(FactorGraph *fg, size_t ind) ;
Var** wrapdai_fg_vars(FactorGraph *fg) ;
FactorGraph* wrapdai_fg_clone(FactorGraph *fg) ;
size_t wrapdai_fg_nrVars(FactorGraph *fg) ;
size_t wrapdai_fg_nrFactors(FactorGraph *fg) ;
size_t wrapdai_fg_nrEdges(FactorGraph *fg) ;
Factor* wrapdai_fg_factor(FactorGraph *fg, int ind) ;
void wrapdai_fg_setFactor(FactorGraph *fg, int ind, Factor *fac) ;
void wrapdai_fg_setFactor_bool(FactorGraph *fg, int ind, Factor *fac, bool backup) ;
void wrapdai_fg_clearBackups(FactorGraph *fg) ;
void wrapdai_fg_restoreFactors(FactorGraph *fg) ;
void wrapdai_fg_readFromFile(FactorGraph *fg, char* text) ;


JTree* wrapdai_jt_create();
JTree* wrapdai_jt_create_fgps(FactorGraph *fg, PropertySet *ps);
void wrapdai_jt_init(JTree *jt);
void wrapdai_jt_run(JTree *jt);
size_t wrapdai_jt_iterations(JTree *jt);
const char* wrapdai_jt_printProperties(JTree *jt);
Factor* wrapdai_jt_calcMarginal(JTree *jt, VarSet *vs);
Factor* wrapdai_jt_belief(JTree *jt, VarSet *vs);
