#include <stddef.h>

typedef struct Var Var;
typedef struct VarSet VarSet;
typedef struct PropertySet PropertySet;
typedef struct Factor Factor;
typedef struct FactorGraph FactorGraph;
typedef struct bool bool;
typedef struct InfAlg InfAlg;

Var* wrapdai_var_create(size_t label, size_t states);
void wrapdai_var_destroy(Var *hdl);
unsigned int wrapdai_var_label(Var *hdl);
unsigned int wrapdai_var_states(Var *hdl);

VarSet* wrapdai_varset_create();
void wrapdai_varset_delete(VarSet *ps);
VarSet* wrapdai_varset_clone(VarSet *vs);
int wrapdai_varset_searchsortedlast(VarSet *vs, Var *v);
VarSet* wrapdai_varset_insert(VarSet *vs, Var *v);
int wrapdai_varset_nrStates(VarSet *vs);
int wrapdai_varset_size(VarSet *vs);
VarSet* wrapdai_varset_erase(VarSet *vs, Var *v);
VarSet* wrapdai_varset_remove(VarSet *vs1, VarSet *vs2);
VarSet* wrapdai_varset_addm(VarSet *vs1, VarSet *vs2);
VarSet* wrapdai_varset_add(VarSet *vs1, VarSet *vs2);
VarSet* wrapdai_varset_sub(VarSet *vs1, VarSet *vs2);
VarSet* wrapdai_varset_sub_one(VarSet *vs, Var *v);

bool wrapdai_varset_contains(VarSet *vs, Var *v);
bool wrapdai_varset_isequal(VarSet *v2, VarSet *vs2);
bool wrapdai_varset_isless(VarSet *v2, VarSet *vs2);

Var* wrapdai_varset_vars(VarSet *vs);

size_t wrapdai_varset_calcLinearState(VarSet *vs, size_t *states, VarSet* orig);
void wrapdai_varset_calcState(VarSet *vs, size_t state, /*Var **vars,*/ size_t *states);
size_t wrapdai_varset_conditionalState(Var* v, VarSet *vs, size_t state, size_t parstates);
size_t wrapdai_varset_conditionalState2(Var* v1, Var* v2, VarSet *vs, size_t state1, 
    size_t state2, size_t parstates);

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
Factor* wrapdai_factor_clone(Factor *fac);
void wrapdai_factor_delete(Factor *fac) ;
void wrapdai_factor_set(Factor *fac, size_t index, double val) ;
double wrapdai_factor_get(Factor *fac, size_t index) ;
VarSet* wrapdai_factor_vars(Factor *fac) ;
VarSet* wrapdai_factor_vars_unsafe(Factor *fac);
size_t wrapdai_factor_nrStates(Factor *fac) ;
double wrapdai_factor_entropy(Factor *fac);
Factor* wrapdai_factor_marginal(Factor *fac, VarSet *vs);
Factor* wrapdai_factor_embed(Factor *fac, VarSet *vs);
Factor* wrapdai_factor_embed_one(Factor *fac, Var *v);
double wrapdai_factor_normalize(Factor *fac);
bool wrapdai_factor_isequal(Factor *fac1, Factor *fac2);
double* wrapdai_factor_p(Factor *fac);
int wrapdai_factor_numvars(Factor *fac);


FactorGraph* wrapdai_fg_create();
FactorGraph* wrapdai_fg_create_facs(Factor **facs, int numfacs);
void wrapdai_fg_delete(FactorGraph *fg);
Var* wrapdai_fg_var(FactorGraph *fg, size_t ind) ;
Var* wrapdai_fg_vars(FactorGraph *fg);
FactorGraph* wrapdai_fg_clone(FactorGraph *fg) ;
size_t wrapdai_fg_nrVars(FactorGraph *fg) ;
size_t wrapdai_fg_nrFactors(FactorGraph *fg) ;
size_t wrapdai_fg_nrEdges(FactorGraph *fg) ;
Factor* wrapdai_fg_factor(FactorGraph *fg, int ind) ;
//Factor* wrapdai_fg_factor_unsafe(FactorGraph *fg, int ind);
void wrapdai_fg_setFactor(FactorGraph *fg, int ind, Factor *fac) ;
void wrapdai_fg_setFactor_backup(FactorGraph *fg, int ind, Factor *fac) ;
void wrapdai_fg_clearBackups(FactorGraph *fg) ;
void wrapdai_fg_restoreFactors(FactorGraph *fg) ;
void wrapdai_fg_readFromFile(FactorGraph *fg, char* text) ;
void wrapdai_fg_printBPG(FactorGraph *fg);


InfAlg* wrapdai_newInfAlg(const std::string &name, const FactorGraph &fg, PropertySet *ps);
InfAlg* wrapdai_newInfAlgFromString(const char* name, const FactorGraph &fg);
void wrapdai_ia_delete(InfAlg *ia);
InfAlg* wrapdai_ia_clone(InfAlg *ia);
void wrapdai_ia_init(InfAlg *ia);
void wrapdai_ia_run(InfAlg *ia);
size_t wrapdai_ia_iterations(InfAlg *ia);
const char* wrapdai_ia_printProperties(InfAlg *ia);
Factor* wrapdai_ia_belief(InfAlg *ia, VarSet *vs);
Factor* wrapdai_ia_calcMarginal(const InfAlg *ia, const VarSet *vs, bool reInit);
