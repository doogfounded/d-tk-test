#ifndef crimp_core_DECLS_H
#define crimp_core_DECLS_H

#include <tcl.h>

#include "common.h"
#include "image_type.h"
#include "image.h"
#include "volume.h"
#include "buffer.h"
#include "rect.h"
/*
 * These macros are used to control whether functions are being declared for
 * import or export. If a function is being declared while it is being built
 * to be included in a shared library, then it should have the DLLEXPORT
 * storage class. If is being declared for use by a module that is going to
 * link against the shared library, then it should have the DLLIMPORT storage
 * class. If the symbol is beind declared for a static build or for use from a
 * stub library, then the storage class should be empty.
 *
 * The convention is that a macro called BUILD_xxxx, where xxxx is the name of
 * a library we are building, is set on the compile line for sources that are
 * to be placed in the library. When this macro is set, the storage class will
 * be set to DLLEXPORT. At the end of the header file, the storage class will
 * be reset to DLLIMPORT.
 */

#undef TCL_STORAGE_CLASS
#ifdef BUILD_crimp_core
#   define TCL_STORAGE_CLASS DLLEXPORT
#else
#   ifdef USE_CRIMP_CORE_STUBS
#      define TCL_STORAGE_CLASS
#   else
#      define TCL_STORAGE_CLASS DLLIMPORT
#   endif
#endif


/*
 * Exported function declarations:
 */

/* 0 */
EXTERN const crimp_imagetype* crimp_imagetype_find(const char*name);
/* 1 */
EXTERN void		crimp_imagetype_def(const crimp_imagetype*imagetype);
/* 2 */
EXTERN Tcl_Obj*		crimp_new_imagetype_obj(
				const crimp_imagetype*imagetype);
/* 3 */
EXTERN int		crimp_get_imagetype_from_obj(Tcl_Interp*interp,
				Tcl_Obj*imagetypeObj,
				crimp_imagetype**imagetype);
/* 4 */
EXTERN crimp_image*	crimp_new_at(const crimp_imagetype*type, int x,
				int y, int w, int h);
/* 5 */
EXTERN crimp_image*	crimp_newm_at(const crimp_imagetype*type, int x,
				int y, int w, int h, Tcl_Obj*meta);
/* 6 */
EXTERN crimp_image*	crimp_dup(crimp_image*image);
/* 7 */
EXTERN void		crimp_del(crimp_image*image);
/* 8 */
EXTERN Tcl_Obj*		crimp_new_image_obj(crimp_image*image);
/* 9 */
EXTERN int		crimp_get_image_from_obj(Tcl_Interp*interp,
				Tcl_Obj*imageObj, crimp_image**image);
/* 10 */
EXTERN crimp_volume*	crimp_vnew_at(const crimp_imagetype*type, int x,
				int y, int z, int w, int h, int d);
/* 11 */
EXTERN crimp_volume*	crimp_vnewm_at(const crimp_imagetype*type, int x,
				int y, int z, int w, int h, int d,
				Tcl_Obj*meta);
/* 12 */
EXTERN crimp_volume*	crimp_vdup(crimp_volume*volume);
/* 13 */
EXTERN void		crimp_vdel(crimp_volume*volume);
/* 14 */
EXTERN Tcl_Obj*		crimp_new_volume_obj(crimp_volume*volume);
/* 15 */
EXTERN int		crimp_get_volume_from_obj(Tcl_Interp*interp,
				Tcl_Obj*volumeObj, crimp_volume**volume);
/* 16 */
EXTERN void		crimp_buf_init(crimp_buffer*b, Tcl_Obj*obj);
/* 17 */
EXTERN int		crimp_buf_has(crimp_buffer*b, int n);
/* 18 */
EXTERN int		crimp_buf_size(crimp_buffer*b);
/* 19 */
EXTERN int		crimp_buf_tell(crimp_buffer*b);
/* 20 */
EXTERN int		crimp_buf_check(crimp_buffer*b, int location);
/* 21 */
EXTERN void		crimp_buf_moveto(crimp_buffer*b, int location);
/* 22 */
EXTERN void		crimp_buf_skip(crimp_buffer*b, int n);
/* 23 */
EXTERN void		crimp_buf_align(crimp_buffer*b, int n);
/* 24 */
EXTERN void		crimp_buf_alignr(crimp_buffer*b, int base, int n);
/* 25 */
EXTERN int		crimp_buf_match(crimp_buffer*b, int n, char*str);
/* 26 */
EXTERN void		crimp_buf_read_uint8(crimp_buffer*b,
				unsigned int*value);
/* 27 */
EXTERN void		crimp_buf_read_uint16le(crimp_buffer*b,
				unsigned int*value);
/* 28 */
EXTERN void		crimp_buf_read_uint32le(crimp_buffer*b,
				unsigned int*value);
/* 29 */
EXTERN void		crimp_buf_read_uint16be(crimp_buffer*b,
				unsigned int*value);
/* 30 */
EXTERN void		crimp_buf_read_uint32be(crimp_buffer*b,
				unsigned int*value);
/* 31 */
EXTERN void		crimp_buf_read_int8(crimp_buffer*b, int*value);
/* 32 */
EXTERN void		crimp_buf_read_int16le(crimp_buffer*b, int*value);
/* 33 */
EXTERN void		crimp_buf_read_int32le(crimp_buffer*b, int*value);
/* 34 */
EXTERN void		crimp_buf_read_int16be(crimp_buffer*b, int*value);
/* 35 */
EXTERN void		crimp_buf_read_int32be(crimp_buffer*b, int*value);
/* 36 */
EXTERN void		crimp_rect_union(const crimp_geometry*a,
				const crimp_geometry*b,
				crimp_geometry*result);

typedef struct Crimp_coreStubs {
    int magic;
    const struct Crimp_coreStubHooks *hooks;

    const crimp_imagetype* (*crimp_imagetype_find) (const char*name); /* 0 */
    void (*crimp_imagetype_def) (const crimp_imagetype*imagetype); /* 1 */
    Tcl_Obj* (*crimp_new_imagetype_obj) (const crimp_imagetype*imagetype); /* 2 */
    int (*crimp_get_imagetype_from_obj) (Tcl_Interp*interp, Tcl_Obj*imagetypeObj, crimp_imagetype**imagetype); /* 3 */
    crimp_image* (*crimp_new_at) (const crimp_imagetype*type, int x, int y, int w, int h); /* 4 */
    crimp_image* (*crimp_newm_at) (const crimp_imagetype*type, int x, int y, int w, int h, Tcl_Obj*meta); /* 5 */
    crimp_image* (*crimp_dup) (crimp_image*image); /* 6 */
    void (*crimp_del) (crimp_image*image); /* 7 */
    Tcl_Obj* (*crimp_new_image_obj) (crimp_image*image); /* 8 */
    int (*crimp_get_image_from_obj) (Tcl_Interp*interp, Tcl_Obj*imageObj, crimp_image**image); /* 9 */
    crimp_volume* (*crimp_vnew_at) (const crimp_imagetype*type, int x, int y, int z, int w, int h, int d); /* 10 */
    crimp_volume* (*crimp_vnewm_at) (const crimp_imagetype*type, int x, int y, int z, int w, int h, int d, Tcl_Obj*meta); /* 11 */
    crimp_volume* (*crimp_vdup) (crimp_volume*volume); /* 12 */
    void (*crimp_vdel) (crimp_volume*volume); /* 13 */
    Tcl_Obj* (*crimp_new_volume_obj) (crimp_volume*volume); /* 14 */
    int (*crimp_get_volume_from_obj) (Tcl_Interp*interp, Tcl_Obj*volumeObj, crimp_volume**volume); /* 15 */
    void (*crimp_buf_init) (crimp_buffer*b, Tcl_Obj*obj); /* 16 */
    int (*crimp_buf_has) (crimp_buffer*b, int n); /* 17 */
    int (*crimp_buf_size) (crimp_buffer*b); /* 18 */
    int (*crimp_buf_tell) (crimp_buffer*b); /* 19 */
    int (*crimp_buf_check) (crimp_buffer*b, int location); /* 20 */
    void (*crimp_buf_moveto) (crimp_buffer*b, int location); /* 21 */
    void (*crimp_buf_skip) (crimp_buffer*b, int n); /* 22 */
    void (*crimp_buf_align) (crimp_buffer*b, int n); /* 23 */
    void (*crimp_buf_alignr) (crimp_buffer*b, int base, int n); /* 24 */
    int (*crimp_buf_match) (crimp_buffer*b, int n, char*str); /* 25 */
    void (*crimp_buf_read_uint8) (crimp_buffer*b, unsigned int*value); /* 26 */
    void (*crimp_buf_read_uint16le) (crimp_buffer*b, unsigned int*value); /* 27 */
    void (*crimp_buf_read_uint32le) (crimp_buffer*b, unsigned int*value); /* 28 */
    void (*crimp_buf_read_uint16be) (crimp_buffer*b, unsigned int*value); /* 29 */
    void (*crimp_buf_read_uint32be) (crimp_buffer*b, unsigned int*value); /* 30 */
    void (*crimp_buf_read_int8) (crimp_buffer*b, int*value); /* 31 */
    void (*crimp_buf_read_int16le) (crimp_buffer*b, int*value); /* 32 */
    void (*crimp_buf_read_int32le) (crimp_buffer*b, int*value); /* 33 */
    void (*crimp_buf_read_int16be) (crimp_buffer*b, int*value); /* 34 */
    void (*crimp_buf_read_int32be) (crimp_buffer*b, int*value); /* 35 */
    void (*crimp_rect_union) (const crimp_geometry*a, const crimp_geometry*b, crimp_geometry*result); /* 36 */
} Crimp_coreStubs;

#ifdef __cplusplus
extern "C" {
#endif
extern const Crimp_coreStubs *crimp_coreStubsPtr;
#ifdef __cplusplus
}
#endif

#if defined(USE_CRIMP_CORE_STUBS)

/*
 * Inline function declarations:
 */

#define crimp_imagetype_find \
	(crimp_coreStubsPtr->crimp_imagetype_find) /* 0 */
#define crimp_imagetype_def \
	(crimp_coreStubsPtr->crimp_imagetype_def) /* 1 */
#define crimp_new_imagetype_obj \
	(crimp_coreStubsPtr->crimp_new_imagetype_obj) /* 2 */
#define crimp_get_imagetype_from_obj \
	(crimp_coreStubsPtr->crimp_get_imagetype_from_obj) /* 3 */
#define crimp_new_at \
	(crimp_coreStubsPtr->crimp_new_at) /* 4 */
#define crimp_newm_at \
	(crimp_coreStubsPtr->crimp_newm_at) /* 5 */
#define crimp_dup \
	(crimp_coreStubsPtr->crimp_dup) /* 6 */
#define crimp_del \
	(crimp_coreStubsPtr->crimp_del) /* 7 */
#define crimp_new_image_obj \
	(crimp_coreStubsPtr->crimp_new_image_obj) /* 8 */
#define crimp_get_image_from_obj \
	(crimp_coreStubsPtr->crimp_get_image_from_obj) /* 9 */
#define crimp_vnew_at \
	(crimp_coreStubsPtr->crimp_vnew_at) /* 10 */
#define crimp_vnewm_at \
	(crimp_coreStubsPtr->crimp_vnewm_at) /* 11 */
#define crimp_vdup \
	(crimp_coreStubsPtr->crimp_vdup) /* 12 */
#define crimp_vdel \
	(crimp_coreStubsPtr->crimp_vdel) /* 13 */
#define crimp_new_volume_obj \
	(crimp_coreStubsPtr->crimp_new_volume_obj) /* 14 */
#define crimp_get_volume_from_obj \
	(crimp_coreStubsPtr->crimp_get_volume_from_obj) /* 15 */
#define crimp_buf_init \
	(crimp_coreStubsPtr->crimp_buf_init) /* 16 */
#define crimp_buf_has \
	(crimp_coreStubsPtr->crimp_buf_has) /* 17 */
#define crimp_buf_size \
	(crimp_coreStubsPtr->crimp_buf_size) /* 18 */
#define crimp_buf_tell \
	(crimp_coreStubsPtr->crimp_buf_tell) /* 19 */
#define crimp_buf_check \
	(crimp_coreStubsPtr->crimp_buf_check) /* 20 */
#define crimp_buf_moveto \
	(crimp_coreStubsPtr->crimp_buf_moveto) /* 21 */
#define crimp_buf_skip \
	(crimp_coreStubsPtr->crimp_buf_skip) /* 22 */
#define crimp_buf_align \
	(crimp_coreStubsPtr->crimp_buf_align) /* 23 */
#define crimp_buf_alignr \
	(crimp_coreStubsPtr->crimp_buf_alignr) /* 24 */
#define crimp_buf_match \
	(crimp_coreStubsPtr->crimp_buf_match) /* 25 */
#define crimp_buf_read_uint8 \
	(crimp_coreStubsPtr->crimp_buf_read_uint8) /* 26 */
#define crimp_buf_read_uint16le \
	(crimp_coreStubsPtr->crimp_buf_read_uint16le) /* 27 */
#define crimp_buf_read_uint32le \
	(crimp_coreStubsPtr->crimp_buf_read_uint32le) /* 28 */
#define crimp_buf_read_uint16be \
	(crimp_coreStubsPtr->crimp_buf_read_uint16be) /* 29 */
#define crimp_buf_read_uint32be \
	(crimp_coreStubsPtr->crimp_buf_read_uint32be) /* 30 */
#define crimp_buf_read_int8 \
	(crimp_coreStubsPtr->crimp_buf_read_int8) /* 31 */
#define crimp_buf_read_int16le \
	(crimp_coreStubsPtr->crimp_buf_read_int16le) /* 32 */
#define crimp_buf_read_int32le \
	(crimp_coreStubsPtr->crimp_buf_read_int32le) /* 33 */
#define crimp_buf_read_int16be \
	(crimp_coreStubsPtr->crimp_buf_read_int16be) /* 34 */
#define crimp_buf_read_int32be \
	(crimp_coreStubsPtr->crimp_buf_read_int32be) /* 35 */
#define crimp_rect_union \
	(crimp_coreStubsPtr->crimp_rect_union) /* 36 */

#endif /* defined(USE_CRIMP_CORE_STUBS) */
#endif /* crimp_core_DECLS_H */

