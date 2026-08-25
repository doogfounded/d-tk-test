module dtk.core;

import tcl;
import std.conv : to;
import std.string : toStringz;

/// Exception thrown when a Tcl/Tk operation returns an error code.
class TclException : Exception
{
    int returnCode;

    this(string message, int returnCode = TCL_ERROR, string file = __FILE__, size_t line = __LINE__)
    {
        this.returnCode = returnCode;
        super(message, file, line);
    }
}

/// Helper to extract the Tcl interpreter string result.
string getTclResult(Tcl_Interp* interp)
{
    if (!interp)
        return "";
    const(char)* res = Tcl_GetStringResult(interp);
    return res ? res.to!string : "";
}

/// Checks the Tcl return code and throws TclException if not TCL_OK.
void checkTcl(Tcl_Interp* interp, int code, string contextMsg = "")
{
    if (code != TCL_OK)
    {
        string err = getTclResult(interp);
        if (contextMsg.length > 0)
            throw new TclException(contextMsg ~ ": " ~ err, code);
        else
            throw new TclException(err, code);
    }
}

/// Safely executes a Tcl command with string arguments using Tcl_Obj to prevent string injection.
string evalCmd(Tcl_Interp* interp, in string[] args...)
{
    if (!interp)
        throw new TclException("Invalid interpreter handle");

    if (args.length == 0)
        return "";

    auto objs = new Tcl_Obj*[args.length];
    for (size_t i = 0; i < args.length; ++i)
    {
        objs[i] = Tcl_NewStringObj(args[i].ptr, cast(int)args[i].length);
        dtk_incr_ref_count(objs[i]);
    }

    scope(exit)
    {
        for (size_t i = 0; i < args.length; ++i)
            dtk_decr_ref_count(objs[i]);
    }

    int code = Tcl_EvalObjv(interp, cast(int)objs.length, objs.ptr, TCL_EVAL_GLOBAL);
    checkTcl(interp, code, "Command failed: " ~ args[0]);
    return getTclResult(interp);
}
