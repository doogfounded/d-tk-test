# crimp::core.decls -- -*- tcl -*-
#
#	This file contains the declarations for all public functions
#	that are exported by the "crimp::core" library via its stubs table.
#

library   crimp::core

interface crimp_core

declare 0 generic {
    const crimp_imagetype* crimp_imagetype_find (const char* name)
}

declare 1 generic {
    void crimp_imagetype_def (const crimp_imagetype* imagetype)
}

declare 2 generic {
    Tcl_Obj* crimp_new_imagetype_obj (const crimp_imagetype* imagetype)
}

declare 3 generic {
    int crimp_get_imagetype_from_obj (Tcl_Interp* interp, Tcl_Obj* imagetypeObj, crimp_imagetype** imagetype)
}

declare 4 generic {
    crimp_image* crimp_new_at (const crimp_imagetype* type, int x, int y, int w, int h)
}

declare 5 generic {
    crimp_image* crimp_newm_at (const crimp_imagetype* type, int x, int y, int w, int h, Tcl_Obj* meta)
}

declare 6 generic {
    crimp_image* crimp_dup (crimp_image* image)
}

declare 7 generic {
    void crimp_del (crimp_image* image)
}

declare 8 generic {
    Tcl_Obj* crimp_new_image_obj (crimp_image* image)
}

declare 9 generic {
    int crimp_get_image_from_obj (Tcl_Interp* interp, Tcl_Obj* imageObj, crimp_image** image)
}

declare 10 generic {
    crimp_volume* crimp_vnew_at (const crimp_imagetype* type, int x, int y, int z, int w, int h, int d)
}

declare 11 generic {
    crimp_volume* crimp_vnewm_at (const crimp_imagetype* type, int x, int y, int z, int w, int h, int d, Tcl_Obj* meta)
}

declare 12 generic {
    crimp_volume* crimp_vdup (crimp_volume* volume)
}

declare 13 generic {
    void crimp_vdel (crimp_volume* volume)
}

declare 14 generic {
    Tcl_Obj* crimp_new_volume_obj (crimp_volume* volume)
}

declare 15 generic {
    int crimp_get_volume_from_obj (Tcl_Interp* interp, Tcl_Obj* volumeObj, crimp_volume** volume)
}

declare 16 generic {
    void crimp_buf_init (crimp_buffer* b, Tcl_Obj* obj)
}

declare 17 generic {
    int crimp_buf_has (crimp_buffer* b, int n)
}

declare 18 generic {
    int crimp_buf_size (crimp_buffer* b)
}

declare 19 generic {
    int crimp_buf_tell (crimp_buffer* b)
}

declare 20 generic {
    int crimp_buf_check (crimp_buffer* b, int location)
}

declare 21 generic {
    void crimp_buf_moveto (crimp_buffer* b, int location)
}

declare 22 generic {
    void crimp_buf_skip (crimp_buffer* b, int n)
}

declare 23 generic {
    void crimp_buf_align (crimp_buffer* b, int n)
}

declare 24 generic {
    void crimp_buf_alignr (crimp_buffer* b, int base, int n)
}

declare 25 generic {
    int crimp_buf_match (crimp_buffer* b, int n, char* str)
}

declare 26 generic {
    void crimp_buf_read_uint8 (crimp_buffer* b, unsigned int* value)
}

declare 27 generic {
    void crimp_buf_read_uint16le (crimp_buffer* b, unsigned int* value)
}

declare 28 generic {
    void crimp_buf_read_uint32le (crimp_buffer* b, unsigned int* value)
}

declare 29 generic {
    void crimp_buf_read_uint16be (crimp_buffer* b, unsigned int* value)
}

declare 30 generic {
    void crimp_buf_read_uint32be (crimp_buffer* b, unsigned int* value)
}

declare 31 generic {
    void crimp_buf_read_int8 (crimp_buffer* b, int* value)
}

declare 32 generic {
    void crimp_buf_read_int16le (crimp_buffer* b, int* value)
}

declare 33 generic {
    void crimp_buf_read_int32le (crimp_buffer* b, int* value)
}

declare 34 generic {
    void crimp_buf_read_int16be (crimp_buffer* b, int* value)
}

declare 35 generic {
    void crimp_buf_read_int32be (crimp_buffer* b, int* value)
}

declare 36 generic {
    void crimp_rect_union (const crimp_geometry* a, const crimp_geometry* b, crimp_geometry* result)
}

# END crimp::core
