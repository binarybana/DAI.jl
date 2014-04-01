#include <dai/var.h>

using namespace dai;

extern "C" {

typedef struct {
  Var *hdl;
} VarHandle;

VarHandle* wrapdai_var_create() {
  //VarHandle *vh = (VarHandle *) malloc(sizeof(VarHandle));
  VarHandle *vh = new VarHandle();
  vh->hdl = new Var();
  return vh;
}

VarHandle* wrapdai_var_create_label(size_t label, size_t states) {
  VarHandle *vh = new VarHandle();
  vh->hdl = new Var(label, states);
  return vh;
}

void wrapdai_var_destroy(VarHandle *hdl) {
  delete hdl->hdl;
}

size_t wrapdai_var_label(VarHandle *hdl) {
  return hdl->hdl->label();
}

size_t wrapdai_var_states(VarHandle *hdl) {
  return hdl->hdl->states();
}

}
