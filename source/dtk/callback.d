module dtk.callback;

import tcl;
import dtk.core;
import std.conv : to;
import core.stdc.stdlib : strtoull;

alias CallbackDg = void delegate();

/// Registry that maps integer IDs to D delegates for Tcl command bridging.
class CallbackRegistry
{
private:
    size_t _nextId = 0;
    CallbackDg[size_t] _callbacks;

public:
    /// Registers a D delegate and returns a unique callback ID.
    size_t register(CallbackDg dg)
    {
        if (dg is null)
            return 0;
        size_t id = ++_nextId;
        _callbacks[id] = dg;
        return id;
    }

    /// Unregisters a callback ID.
    void unregister(size_t id)
    {
        if (id in _callbacks)
            _callbacks.remove(id);
    }

    /// Dispatches a callback by ID.
    void dispatch(size_t id)
    {
        if (auto dg = id in _callbacks)
        {
            (*dg)();
        }
    }

    /// Clears all registered callbacks.
    void clear()
    {
        _callbacks.clear();
    }

    /// Returns true if a callback ID is currently registered.
    bool isRegistered(size_t id) const
    {
        return (id in _callbacks) !is null;
    }
}

/// The C callback function invoked by Tcl when 'd_callback <id>' is evaluated.
extern(C) int d_callback_dispatcher(ClientData clientData, Tcl_Interp* interp, int objc, Tcl_Obj** objv) @trusted
{
    if (objc < 2 || objv is null)
    {
        return TCL_OK;
    }

    Tcl_Obj* idObj = *(objv + 1);
    if (!idObj)
        return TCL_OK;

    const(char)* idStr = Tcl_GetString(idObj);
    if (!idStr)
        return TCL_OK;

    ulong id = strtoull(idStr, null, 10);
    auto registry = cast(CallbackRegistry)clientData;
    if (registry !is null)
    {
        try
        {
            registry.dispatch(cast(size_t)id);
        }
        catch (Throwable t)
        {
            import std.stdio : stderr;
            stderr.writeln("Exception during D callback execution #", id, ": ", t.msg);
        }
    }

    return TCL_OK;
}
