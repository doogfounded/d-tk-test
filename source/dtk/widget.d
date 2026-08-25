module dtk.widget;

import tcl;
import dtk.core;
import dtk.callback;
import dtk.geometry;
import dtk.widgets.frame;
import dtk.widgets.label;
import dtk.widgets.button;
import dtk.widgets.entry;
import std.conv : to;
import std.algorithm.mutation : remove;
import std.algorithm.searching : countUntil;

/// Base class representing a Tk widget.
class Widget
{
private:
    static size_t _nextId = 0;

protected:
    Tcl_Interp* _interp;
    string _path;
    Widget _parent;
    CallbackRegistry _registry;
    size_t[] _registeredCallbackIds;
    bool _isDestroyed = false;

public:
    /// Generates a unique child Tcl widget path under this widget.
    string generateChildPath(string prefix = "w")
    {
        size_t id = ++_nextId;
        if (_path == ".")
            return "." ~ prefix ~ id.to!string;
        else
            return _path ~ "." ~ prefix ~ id.to!string;
    }

    /// Constructor for root or wrapping an existing widget.
    this(Tcl_Interp* interp, string path, Widget parent = null, CallbackRegistry registry = null)
    {
        this._interp = interp;
        this._path = path;
        this._parent = parent;
        this._registry = (registry !is null) ? registry : (parent !is null ? parent.registry : null);
    }

    /// The full Tcl/Tk widget path (e.g., '.', '.w1', '.w1.b2').
    @property string path() const pure nothrow @nogc @safe
    {
        return _path;
    }

    /// The parent widget, or null if this is the root window.
    @property Widget parent() pure nothrow @nogc @safe
    {
        return _parent;
    }

    /// The low-level Tcl interpreter handle.
    @property Tcl_Interp* interp() pure nothrow @nogc @safe
    {
        return _interp;
    }

    /// The callback registry associated with this widget's app.
    @property CallbackRegistry registry() pure nothrow @nogc @safe
    {
        return _registry;
    }

    /// Whether this widget has been destroyed.
    @property bool isDestroyed() const pure nothrow @nogc @safe
    {
        return _isDestroyed;
    }

    /// Registers a callback with this widget's lifecycle.
    size_t registerCallback(void delegate() dg)
    {
        if (_registry is null || dg is null)
            return 0;
        size_t id = _registry.register(dg);
        _registeredCallbackIds ~= id;
        return id;
    }

    /// Unregisters a callback associated with this widget.
    void unregisterCallback(size_t id)
    {
        if (_registry is null || id == 0)
            return;
        _registry.unregister(id);
        ptrdiff_t idx = _registeredCallbackIds.countUntil(id);
        if (idx >= 0)
            _registeredCallbackIds = _registeredCallbackIds.remove(idx);
    }

    /// Destroys this widget in Tk and cleans up any registered callbacks.
    void destroy()
    {
        if (!_isDestroyed)
        {
            if (_registry !is null)
            {
                foreach (id; _registeredCallbackIds)
                    _registry.unregister(id);
                _registeredCallbackIds = null;
            }

            if (_interp !is null)
            {
                evalCmd(_interp, "destroy", _path);
            }

            _isDestroyed = true;
        }
    }

    /// Sets a widget configuration option safely using Tcl_Obj arguments.
    void configure(string option, string value)
    {
        if (_isDestroyed)
            throw new TclException("Cannot configure a destroyed widget: " ~ _path);

        string optName = (option.length > 0 && option[0] == '-') ? option : "-" ~ option;
        evalCmd(_interp, _path, "configure", optName, value);
    }

    /// Gets a widget configuration option value.
    string cget(string option)
    {
        if (_isDestroyed)
            throw new TclException("Cannot query a destroyed widget: " ~ _path);

        string optName = (option.length > 0 && option[0] == '-') ? option : "-" ~ option;
        return evalCmd(_interp, _path, "cget", optName);
    }

    // --- Widget Factory Methods ---

    Frame frame(int padding = -1)
    {
        return new Frame(this, padding);
    }

    Label label(string text = "")
    {
        return new Label(this, text);
    }

    Button button(string text = "")
    {
        return new Button(this, text);
    }

    Entry entry(string initialText = "")
    {
        return new Entry(this, initialText);
    }

    // --- Geometry: pack ---

    void pack(PackOptions options = PackOptions.init)
    {
        if (_isDestroyed)
            throw new TclException("Cannot pack a destroyed widget: " ~ _path);

        string[] cmd = ["pack", _path];
        cmd ~= options.toArgs();
        evalCmd(_interp, cmd);
    }

    void pack(int padx, int pady)
    {
        pack(PackOptions.init.setPadx(padx).setPady(pady));
    }

    void packForget()
    {
        if (_isDestroyed)
            return;
        evalCmd(_interp, "pack", "forget", _path);
    }

    // --- Geometry: grid ---

    void grid(GridOptions options = GridOptions.init)
    {
        if (_isDestroyed)
            throw new TclException("Cannot grid a destroyed widget: " ~ _path);

        string[] cmd = ["grid", _path];
        cmd ~= options.toArgs();
        evalCmd(_interp, cmd);
    }

    void grid(int row, int column)
    {
        grid(GridOptions.init.setRow(row).setColumn(column));
    }

    void gridForget()
    {
        if (_isDestroyed)
            return;
        evalCmd(_interp, "grid", "forget", _path);
    }

    // --- Geometry: place ---

    void place(PlaceOptions options)
    {
        if (_isDestroyed)
            throw new TclException("Cannot place a destroyed widget: " ~ _path);

        string[] cmd = ["place", _path];
        cmd ~= options.toArgs();
        evalCmd(_interp, cmd);
    }

    void place(int x, int y, int width = int.min, int height = int.min)
    {
        auto opts = PlaceOptions.init.setX(x).setY(y);
        if (width != int.min) opts.setWidth(width);
        if (height != int.min) opts.setHeight(height);
        place(opts);
    }

    void placeForget()
    {
        if (_isDestroyed)
            return;
        evalCmd(_interp, "place", "forget", _path);
    }
}
