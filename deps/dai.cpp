#include <stddef.h>
#include <stdlib.h>
#include <exception>
#include <iostream>
#include <vector>
#include <map>

#include <dai/var.h>
#include <dai/varset.h>
#include <dai/properties.h>
#include <dai/factor.h>
#include <dai/factorgraph.h>
#include <dai/jtree.h>
#include <dai/util.h>
#include <dai/exceptions.h>

#define TRYCATCH(block) \
  try{\
    block\
  }\
  catch(Exception &e)\
  {\
    std::cerr<<e.getDetailedMsg();\
    std::cerr.flush();\
    exit(-1);\
  }

using namespace dai;

extern "C" {

//cdef extern from "dai/var.h" namespace "dai":
    //cdef cppclass Var:
        //Var(size_t, size_t)
        //size_t states()
        //size_t label()

Var* wrapdai_var_create(size_t label, size_t states) {
  TRYCATCH(Var *vh = new Var(label, states); 
  return vh;)
}

void wrapdai_var_destroy(Var *hdl) {
  delete hdl;
}

unsigned int wrapdai_var_label(Var *hdl) {
  return (unsigned int) hdl->label();
}

unsigned int wrapdai_var_states(Var *hdl) {
  return (unsigned int) hdl->states();
}

//cdef extern from "dai/varset.h" namespace "dai":
    //cdef cppclass VarSet:
        //VarSet()
        //#VarSet(SmallSet[Var] &)
        //VarSet(Var &)
        //VarSet(Var &, Var &)
        //VarSet(vector[Var].iterator, vector[Var].iterator, size_t)
        //BigInt nrStates()
        //#SmallSet[Var] & operator|(SmallSet[Var] &)
        //size_t size()
        //vector[Var] & elements()
        //vector[Var].iterator begin()
        //vector[Var].iterator end()
        //VarSet& insert(Var &)
        //VarSet& erase(Var &)
        //VarSet operator/(VarSet &)
        //VarSet operator|(VarSet &)
        //#VarSet& remove(VarSet &)
        //#VarSet& add(VarSet &)
    //bint operator==(VarSet&, VarSet&)

VarSet* wrapdai_varset_create() { return new VarSet(); }
void wrapdai_varset_delete(VarSet *vs) { delete vs; }

VarSet* wrapdai_varset_insert(VarSet *vs, Var *v) { 
  TRYCATCH(return static_cast<VarSet*>(&(vs->insert(*v)));)
}

unsigned int wrapdai_varset_nrStates(VarSet *vs) { 
  BigInt num = vs->nrStates(); 
  return (unsigned int) BigInt_size_t(num);

}

int wrapdai_varset_size(VarSet *vs) { return vs->size(); }
VarSet* wrapdai_varset_erase(VarSet *vs, Var *v) { return static_cast<VarSet*>(&(vs->erase(*v))); }
VarSet* wrapdai_varset_remove(VarSet *vs1, VarSet *vs2) { return static_cast<VarSet*>(&((*vs1)/=(*vs2))); }
VarSet* wrapdai_varset_add(VarSet *vs1, VarSet *vs2) { return static_cast<VarSet*>(&((*vs1)|=(*vs2))); }

    //size_t calcLinearState( VarSet &, map[Var, size_t] &)
    //map[Var, size_t] calcState( VarSet &, size_t)
    
size_t wrapdai_varset_calcLinearState(VarSet *vs, size_t *states) {
  std::vector<Var>& vars = vs->elements();
  std::map<Var,size_t> tempmap;
  for (int i=0; i < vs->size(); i++) {
    tempmap[vars[i]] = states[i];
  }
  return calcLinearState(*vs, tempmap);
}

void wrapdai_varset_calcState(VarSet *vs, size_t state, /*Var **vars,*/ size_t *states) {
  // Need to preallocate vars and states
  std::map<Var,size_t> tempmap = calcState(*vs, state);
  int counter = 0;
  for (std::map<Var,size_t>::iterator it=tempmap.begin(); it!=tempmap.end(); ++it) {
    //vars[counter] =  it->first
    states[counter++] = it->second;
  }
}

//cdef extern from "dai/properties.h" namespace "dai":
    //cdef cppclass PropertySet:
        //PropertySet()
        //PropertySet(string)

PropertySet* wrapdai_ps_create(const char *name) { return new PropertySet(name); }
void wrapdai_ps_delete(PropertySet *ps) { delete ps; }

//cdef extern from "dai/factor.h" namespace "dai":
    //cdef cppclass TFactor[T]:
        //TFactor()
        //TFactor(Var &)
        //TFactor(VarSet &)
        //void set(size_t, T)
        //T get(size_t)
        //VarSet & vars()
        //size_t nrStates()
        //T entropy()
        //TFactor[T] marginal(VarSet &)
        //TFactor[T] embed(VarSet &)
        //T operator[](size_t)
        //T normalize()

typedef TFactor<double> Factor;

Factor* wrapdai_factor_create_empty() { return new Factor(); }
Factor* wrapdai_factor_create_var(Var *v) { return new Factor(*v); }
Factor* wrapdai_factor_create_varset(VarSet *vs) { return new Factor(*vs); }
Factor* wrapdai_factor_create_varset_vals(VarSet *vs, double *vals) { return new Factor(*vs, vals); }
void wrapdai_factor_delete(Factor *fac) { delete fac; }
void wrapdai_factor_set(Factor *fac, size_t index, double val) { fac->set(index, val); }
double wrapdai_factor_get(Factor *fac, size_t index) { return fac->get(index); }
VarSet* wrapdai_factor_vars(Factor *fac) { 
  // lets try proper copying
  VarSet *vs = new VarSet();
  *vs = fac->vars();
  return vs;
}
size_t wrapdai_factor_nrStates(Factor *fac) { return fac->nrStates(); }
double wrapdai_factor_entropy(Factor *fac) { return fac->entropy(); }
Factor* wrapdai_factor_marginal(Factor *fac, VarSet *vs) { 
  // lets try proper copying
  Factor *newfac = new Factor();
  *newfac = fac->marginal(*vs);
  return newfac;
}
Factor* wrapdai_factor_embed(Factor *fac, VarSet *vs) { 
  // lets try proper copying
  Factor *newfac = new Factor();
  *newfac = fac->embed(*vs);
  return newfac;
}
double wrapdai_factor_normalize(Factor *fac) { return fac->normalize(); }

//cdef extern from "dai/factorgraph.h" namespace "dai":
    //cdef cppclass FactorGraph:
        //FactorGraph()
        //FactorGraph(vector[Factor] &)
        //Var & var(size_t)
        //FactorGraph* clone()
        //vector[Var] & vars()
        //size_t nrVars()
        //size_t nrFactors()
        //size_t nrEdges()
        //double logScore(vector[long unsigned int] &)
        //Factor factor(int)
        //void setFactor(int, Factor, bool) except +
        //void setFactor(int, Factor) except +
        //void clearBackups() except +
        //void restoreFactors() except +
        //void ReadFromFile(char*)

FactorGraph* wrapdai_fg_create() { return new FactorGraph; }
FactorGraph* wrapdai_fg_create_facs(Factor **facs, int numfacs) { 
  std::vector<Factor> facvec;
  for (int i=0; i<numfacs; i++) {
    facvec.push_back(*facs[i]);
  }
  return new FactorGraph(facvec); 
}
Var* wrapdai_fg_var(FactorGraph *fg, size_t ind) { return new Var (fg->var(ind)); }
Var** wrapdai_fg_vars(FactorGraph *fg) { 
  std::vector<Var> vars = fg->vars(); 
  int numvars = vars.size();
  Var **varsvec = (Var **) malloc(sizeof(Var*)*numvars);
  for (int i=0; i<numvars; i++) {
    *varsvec[i] = vars[i];
  }
  return varsvec;
}
FactorGraph* wrapdai_fg_clone(FactorGraph *fg) { return fg->clone(); }
size_t wrapdai_fg_nrVars(FactorGraph *fg) { return fg->nrVars(); }
size_t wrapdai_fg_nrFactors(FactorGraph *fg) { return fg->nrFactors(); }
size_t wrapdai_fg_nrEdges(FactorGraph *fg) { return fg->nrEdges(); }
Factor* wrapdai_fg_factor(FactorGraph *fg, int ind) { return new Factor (fg->factor(ind)); }
void wrapdai_fg_setFactor(FactorGraph *fg, int ind, Factor *fac) { TRYCATCH(fg->setFactor(ind, *fac);) }
void wrapdai_fg_setFactor_bool(FactorGraph *fg, int ind, Factor *fac, bool backup) { TRYCATCH(fg->setFactor(ind, *fac, backup);) }
void wrapdai_fg_clearBackups(FactorGraph *fg) { TRYCATCH(fg->clearBackups();) }
void wrapdai_fg_restoreFactors(FactorGraph *fg) { TRYCATCH(fg->restoreFactors();) }
void wrapdai_fg_readFromFile(FactorGraph *fg, char* text) { fg->ReadFromFile(text); }
//double wrapdai_fg_logScore(FactorGraph *fg, statevec) { return fg->nrEdges(); }


//cdef extern from "dai/jtree.h" namespace "dai":
    //cdef cppclass JTree:
        //JTree()
        //JTree(FactorGraph &, PropertySet &)
        //void init()
        //void run()
        //size_t Iterations()
        //string printProperties()
        //Factor calcMarginal(VarSet &)
        //Factor belief(VarSet &)

JTree* wrapdai_jt_create() { return new JTree(); }
JTree* wrapdai_jt_create_fgps(FactorGraph *fg, PropertySet *ps) { return new JTree(*fg, *ps); }
void wrapdai_jt_init(JTree *jt) { jt->init(); }
void wrapdai_jt_run(JTree *jt) { jt->run(); }
size_t wrapdai_jt_iterations(JTree *jt) { return jt->Iterations(); }
const char* wrapdai_jt_printProperties(JTree *jt) { return jt->printProperties().c_str(); }
Factor* wrapdai_jt_calcMarginal(JTree *jt, VarSet *vs) { return new Factor (jt->calcMarginal(*vs)); }
Factor* wrapdai_jt_belief(JTree *jt, VarSet *vs) { return new Factor (jt->belief(*vs)); }

}
