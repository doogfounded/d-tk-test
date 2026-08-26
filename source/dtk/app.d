module dtk.app;

import tcl;
import dtk.core;
import dtk.callback;
import dtk.root;
import std.string : toStringz;
import std.process : environment;
import std.file : exists, isDir;
import std.path : buildPath;

/// Manages the Tcl/Tk interpreter lifecycle, callback registry, and event loop.
class TkApp
{
private:
    Tcl_Interp* _interp;
    CallbackRegistry _registry;
    TkRoot _root;
    bool _isDisposed = false;

    enum defaultTclLibBase = `C:\Users\Doug\AppData\Local\Apps\Tcl86\lib`;

    /// Finds a valid Tcl script directory containing init.tcl
    static string findTclLibrary()
    {
        // 1. Check known default Magicsplat path first
        string defaultPath = buildPath(defaultTclLibBase, "tcl8.6");
        if (exists(buildPath(defaultPath, "init.tcl")))
            return defaultPath;

        // 2. Check TCL_LIBRARY environment variable if valid
        string envPath = environment.get("TCL_LIBRARY", "");
        if (envPath.length > 0 && exists(buildPath(envPath, "init.tcl")))
            return envPath;

        return defaultPath;
    }

    /// Finds a valid Tk script directory containing tk.tcl
    static string findTkLibrary()
    {
        // 1. Check known default Magicsplat path first
        string defaultPath = buildPath(defaultTclLibBase, "tk8.6");
        if (exists(buildPath(defaultPath, "tk.tcl")))
            return defaultPath;

        // 2. Check TK_LIBRARY environment variable if valid
        string envPath = environment.get("TK_LIBRARY", "");
        if (envPath.length > 0 && exists(buildPath(envPath, "tk.tcl")))
            return envPath;

        return defaultPath;
    }

    void initInterp()
    {
        _interp = Tcl_CreateInterp();
        if (!_interp)
            throw new TclException("Failed to create Tcl interpreter");

        // Validate and set tcl_library and tk_library to valid paths
        string tclLib = findTclLibrary();
        string tkLib = findTkLibrary();

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

        // Initialize callback registry and register the 'd_callback' command in Tcl
        _registry = new CallbackRegistry();
        Tcl_CreateObjCommand(
            _interp,
            "d_callback".ptr,
            &d_callback_dispatcher,
            cast(ClientData)cast(void*)_registry,
            null
        );

        _root = new TkRoot(_interp, _registry);
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

    /// Explicitly shuts down the interpreter, clears callbacks, and frees resources.
    void dispose()
    {
        if (!_isDisposed)
        {
            if (_registry !is null)
            {
                _registry.clear();
                _registry = null;
            }

            if (_interp !is null)
            {
                Tcl_DeleteInterp(_interp);
                _interp = null;
            }

            _isDisposed = true;
        }
    }

    /// Returns the underlying Tcl interpreter pointer.
    @property Tcl_Interp* interp() pure nothrow @nogc @safe
    {
        return _interp;
    }

    /// Returns the callback registry.
    @property CallbackRegistry registry() pure nothrow @nogc @safe
    {
        return _registry;
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
