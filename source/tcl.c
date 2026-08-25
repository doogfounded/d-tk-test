#include <tcl.h>
#include <tk.h>

void dtk_incr_ref_count(Tcl_Obj *objPtr) {
    Tcl_IncrRefCount(objPtr);
}

void dtk_decr_ref_count(Tcl_Obj *objPtr) {
    Tcl_DecrRefCount(objPtr);
}