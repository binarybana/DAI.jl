#include <stddef.h>

typedef struct VarHandle VarHandle;

VarHandle* wrapdai_var_create();
VarHandle* wrapdai_var_create_label(size_t label, size_t states);
void wrapdai_var_destroy(VarHandle *hdl);
size_t wrapdai_var_label(VarHandle *hdl);
size_t wrapdai_var_states(VarHandle *hdl);
