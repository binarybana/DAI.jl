//c++ -shared -fPIC gen/var.cc -o gen/var
#include <dai/var.h>
extern "C" {
size_t Var_label1(Var* this ) {
  return this->label()
}
