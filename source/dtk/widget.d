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

    /// The full Tcl/Tk widget path (e.g., '.', '.frame1', '.frame1.btn2').
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

    /// Binds an arbitrary Tk event sequence (e.g., "<Return>", "<Button-1>", "<FocusIn>") to a D delegate.
    void bind(string eventSeq, void delegate() dg)
    {
        if (_isDestroyed)
            throw new TclException("Cannot bind event on destroyed widget: " ~ _path);

        size_t id = registerCallback(dg);
        evalCmd(_interp, "bind", _path, eventSeq, "d_callback " ~ id.to!string);
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

    Button button(string text = "", void delegate() onClickHandler = null)
    {
        auto btn = new Button(this, text);
        if (onClickHandler !is null)
            btn.onClick = onClickHandler;
        return btn;
    }

    Entry entry(string initialText = "")
    {
        return new Entry(this, initialText);
    }

    // --- Geometry: pack with named / default parameters ---

    void pack(
        int padx = -1,
        int pady = -1,
        string side = null,
        string fill = null,
        int expand = -1,
        int ipadx = -1,
        int ipady = -1,
        string anchor = null
    )
    {
        PackOptions opts;
        opts.padx = padx;
        opts.pady = pady;
        opts.side = side;
        opts.fill = fill;
        opts.expand = expand;
        opts.ipadx = ipadx;
        opts.ipady = ipady;
        opts.anchor = anchor;
        pack(opts);
    }

    void pack(PackOptions options)
    {
        if (_isDestroyed)
            throw new TclException("Cannot pack a destroyed widget: " ~ _path);

        string[] cmd = ["pack", _path];
        cmd ~= options.toArgs();
        evalCmd(_interp, cmd);
    }

    void packForget()
    {
        if (_isDestroyed)
            return;
        evalCmd(_interp, "pack", "forget", _path);
    }

    // --- Geometry: grid with named / default parameters ---

    void grid(
        int row = -1,
        int column = -1,
        int rowspan = -1,
        int columnspan = -1,
        int padx = -1,
        int pady = -1,
        int ipadx = -1,
        int ipady = -1,
        string sticky = null
    )
    {
        GridOptions opts;
        opts.row = row;
        opts.column = column;
        opts.rowspan = rowspan;
        opts.columnspan = columnspan;
        opts.padx = padx;
        opts.pady = pady;
        opts.ipadx = ipadx;
        opts.ipady = ipady;
        opts.sticky = sticky;
        grid(opts);
    }

    void grid(GridOptions options)
    {
        if (_isDestroyed)
            throw new TclException("Cannot grid a destroyed widget: " ~ _path);

        string[] cmd = ["grid", _path];
        cmd ~= options.toArgs();
        evalCmd(_interp, cmd);
    }

    void gridForget()
    {
        if (_isDestroyed)
            return;
        evalCmd(_interp, "grid", "forget", _path);
    }

    // --- Geometry: place with named / default parameters ---

    void place(
        int x = int.min,
        int y = int.min,
        int width = int.min,
        int height = int.min,
        string anchor = null
    )
    {
        PlaceOptions opts;
        opts.x = x;
        opts.y = y;
        opts.width = width;
        opts.height = height;
        opts.anchor = anchor;
        place(opts);
    }

    void place(PlaceOptions options)
    {
        if (_isDestroyed)
            throw new TclException("Cannot place a destroyed widget: " ~ _path);

        string[] cmd = ["place", _path];
        cmd ~= options.toArgs();
        evalCmd(_interp, cmd);
    }

    void placeForget()
    {
        if (_isDestroyed)
            return;
        evalCmd(_interp, "place", "forget", _path);
    }
}
