module dtk.root;

import tcl;
import dtk.core;

/// Represents the Tk root window ('.').
class TkRoot
{
private:
    Tcl_Interp* _interp;

public:
    this(Tcl_Interp* interp)
    {
        this._interp = interp;
    }

    /// Underlying Tcl widget path.
    @property string path() const pure nothrow @nogc @safe
    {
        return ".";
    }

    /// Low-level Tcl interpreter handle for debugging or advanced interop.
    @property Tcl_Interp* interp() pure nothrow @nogc @safe
    {
        return _interp;
    }

    /// Gets the window title via 'wm title .'.
    @property string title()
    {
        Tcl_Obj*[3] objv;
        objv[0] = Tcl_NewStringObj("wm", 2);
        objv[1] = Tcl_NewStringObj("title", 5);
        objv[2] = Tcl_NewStringObj(".", 1);

        for (size_t i = 0; i < objv.length; ++i)
            dtk_incr_ref_count(objv[i]);

        scope(exit)
        {
            for (size_t i = 0; i < objv.length; ++i)
                dtk_decr_ref_count(objv[i]);
        }

        int code = Tcl_EvalObjv(_interp, cast(int)objv.length, objv.ptr, TCL_EVAL_GLOBAL);
        checkTcl(_interp, code, "Failed to get title");
        return getTclResult(_interp);
    }

    /// Sets the window title via 'wm title . <newTitle>'.
    @property void title(string newTitle)
    {
        Tcl_Obj*[4] objv;
        objv[0] = Tcl_NewStringObj("wm", 2);
        objv[1] = Tcl_NewStringObj("title", 5);
        objv[2] = Tcl_NewStringObj(".", 1);
        objv[3] = Tcl_NewStringObj(newTitle.ptr, cast(int)newTitle.length);

        for (size_t i = 0; i < objv.length; ++i)
            dtk_incr_ref_count(objv[i]);

        scope(exit)
        {
            for (size_t i = 0; i < objv.length; ++i)
                dtk_decr_ref_count(objv[i]);
        }

        int code = Tcl_EvalObjv(_interp, cast(int)objv.length, objv.ptr, TCL_EVAL_GLOBAL);
        checkTcl(_interp, code, "Failed to set title");
    }
}
