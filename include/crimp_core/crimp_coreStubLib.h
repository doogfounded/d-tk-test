
/*
 * crimp_coreStubLib.c --
 *
 * Stub object that will be statically linked into extensions that wish
 * to access crimp_core.
 */

/*
 * We need to ensure that we use the stub macros so that this file contains
 * no references to any of the stub functions.  This will make it possible
 * to build an extension that references Crimp_core_InitStubs but doesn't end up
 * including the rest of the stub functions.
 */

#ifndef USE_TCL_STUBS
#define USE_TCL_STUBS
#endif
#undef  USE_TCL_STUB_PROCS

#include <tcl.h>

#ifndef USE_CRIMP_CORE_STUBS
#define USE_CRIMP_CORE_STUBS
#endif
#undef  USE_CRIMP_CORE_STUB_PROCS

#include "crimp_coreDecls.h"

/*
 * Ensure that Crimp_core_InitStubs is built as an exported symbol.  The other stub
 * functions should be built as non-exported symbols.
 */

#undef  TCL_STORAGE_CLASS
#define TCL_STORAGE_CLASS DLLEXPORT

const Crimp_coreStubs* crimp_coreStubsPtr;


/*
 *----------------------------------------------------------------------
 *
 * Crimp_core_InitStubs --
 *
 * Checks that the correct version of Crimp_core is loaded and that it
 * supports stubs. It then initialises the stub table pointers.
 *
 * Results:
 *  The actual version of Crimp_core that satisfies the request, or
 *  NULL to indicate that an error occurred.
 *
 * Side effects:
 *  Sets the stub table pointers.
 *
 *----------------------------------------------------------------------
 */

#ifdef Crimp_core_InitStubs
#undef Crimp_core_InitStubs
#endif

char *
Crimp_core_InitStubs(Tcl_Interp *interp, CONST char *version, int exact)
{
    CONST char *actualVersion;

    actualVersion = Tcl_PkgRequireEx(interp, "crimp::core", version,
				     exact, (ClientData *) &crimp_coreStubsPtr);
    if (!actualVersion) {
	return NULL;
    }

    if (!crimp_coreStubsPtr) {
	Tcl_SetResult(interp,
		      "This implementation of Crimp_core does not support stubs",
		      TCL_STATIC);
	return NULL;
    }
    
    return (char*) actualVersion;
}
    
