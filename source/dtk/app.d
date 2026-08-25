module dtk.app;

import tcl;
import dtk.core;
import dtk.root;
import std.string : toStringz;
import std.process : environment;
import std.file : exists;

/// Manages the Tcl/Tk interpreter lifecycle and event loop.
class TkApp
{
private:
    Tcl_Interp* _interp;
    TkRoot _root;
    bool _isDisposed = false;

    enum defaultTclLibPath = `C:\Users\Doug\AppData\Local\Apps\Tcl86\lib`;

    void initInterp()
    {
        _interp = Tcl_CreateInterp();
        if (!_interp)
            throw new TclException("Failed to create Tcl interpreter");

        // Set up Tcl and Tk library script paths if not set in environment
        string tclLib = environment.get("TCL_LIBRARY", defaultTclLibPath ~ `\tcl8.6`);
        string tkLib = environment.get("TK_LIBRARY", defaultTclLibPath ~ `\tk8.6`);

        if (exists(tclLib))
        {
            Tcl_SetVar(_interp, "tcl_library".ptr, tclLib.toStringz, TCL_GLOBAL_ONLY);
        }
        if (exists(tkLib))
        {
            Tcl_SetVar(_interp, "tk_library".ptr, tkLib.toStringz, TCL_GLOBAL_ONLY);
        }

        int code = Tcl_Init(_interp);
        checkTcl(_interp, code, "Tcl_Init failed");

        code = Tk_Init(_interp);
        checkTcl(_interp, code, "Tk_Init failed");

        _root = new TkRoot(_interp);
    }

public:
    this()
    {
        initInterp();
    }

    ~this()
    {
        dispose();
    }

    /// Explicitly shuts down the interpreter and frees resources.
    void dispose()
    {
        if (!_isDisposed && _interp !is null)
        {
            Tcl_DeleteInterp(_interp);
            _interp = null;
            _isDisposed = true;
        }
    }

    /// Returns the underlying Tcl interpreter pointer.
    @property Tcl_Interp* interp() pure nothrow @nogc @safe
    {
        return _interp;
    }

    /// Returns the root window representation ('.').
    @property TkRoot root() pure nothrow @nogc @safe
    {
        return _root;
    }

    /// Evaluates a raw Tcl script and returns the result string, throwing TclException on failure.
    string eval(string script)
    {
        if (_isDisposed || _interp is null)
            throw new TclException("Interpreter has been destroyed");

        int code = Tcl_EvalEx(_interp, script.ptr, cast(int)script.length, TCL_EVAL_GLOBAL);
        checkTcl(_interp, code, "Tcl_Eval failed");
        return getTclResult(_interp);
    }

    /// Runs the Tk main event loop until the main window is destroyed.
    void run()
    {
        if (_isDisposed || _interp is null)
            throw new TclException("Interpreter has been destroyed");

        Tk_MainLoop();
    }
}
