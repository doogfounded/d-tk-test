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
