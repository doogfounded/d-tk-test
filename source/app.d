module app;

import tcl;
import std.conv : to;
import std.stdio;

/// Helper to extract the Tcl interpreter error string.
string tclError(Tcl_Interp* interp)
{
    auto result = Tcl_GetStringResult(interp);
    return result ? result.to!string : "(no error message)";
}

enum tclLibPath = `C:\Users\Doug\AppData\Local\Apps\Tcl86\lib`;

void main()
{
    auto interp = Tcl_CreateInterp();

    // Tell Tcl/Tk where to find their init scripts.
    Tcl_Eval(interp, `set tcl_library {` ~ tclLibPath ~ `/tcl8.6}`);
    Tcl_Eval(interp, `set tk_library {`  ~ tclLibPath ~ `/tk8.6}`);

    if (Tcl_Init(interp) != TCL_OK)
        throw new Exception("Tcl_Init failed: " ~ tclError(interp));

    if (Tk_Init(interp) != TCL_OK)
        throw new Exception("Tk_Init failed: " ~ tclError(interp));

    Tcl_Eval(interp,
        "wm title . {D + Tk}\n" ~
        "button .b -text {Hello from D} -command {puts {Button clicked!}}\n" ~
        "pack .b -padx 30 -pady 30"
    );

    Tcl_Eval(interp, "tkwait window .");

    Tcl_DeleteInterp(interp);
}