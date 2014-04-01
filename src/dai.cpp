#include <stddef.h>

#include <dai/var.h>
#include <dai/varset.h>
#include <dai/properties.h>
#include <dai/util.h>

using namespace dai;

extern "C" {

//cdef extern from "dai/var.h" namespace "dai":
    //cdef cppclass Var:
        //Var(size_t, size_t)
        //size_t states()
        //size_t label()

Var* wrapdai_var_create(int label, int states) {
  Var *vh = new Var((size_t) label, (size_t) states);
  return vh;
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
  return static_cast<VarSet*>(&(vs->insert(*v))); 
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
    

//cdef extern from "dai/properties.h" namespace "dai":
    //cdef cppclass PropertySet:
        //PropertySet()
        //PropertySet(string)

PropertySet* wrapdai_propertyset_create(const char *name) { return new PropertySet(name); }
void wrapdai_propertyset_delete(PropertySet *ps) { delete ps; }


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

//ctypedef TFactor[double] Factor

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
}
