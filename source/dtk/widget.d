module dtk.widget;

import tcl;
import dtk.core;
import dtk.geometry;
import std.conv : to;

/// Base class representing a Tk widget.
class Widget
{
private:
    static size_t _nextId = 0;

protected:
    Tcl_Interp* _interp;
    string _path;
    Widget _parent;
    bool _isDestroyed = false;

    /// Generates a unique child Tcl widget path under this widget.
    string generateChildPath(string prefix = "w")
    {
        size_t id = ++_nextId;
        if (_path == ".")
            return "." ~ prefix ~ id.to!string;
        else
            return _path ~ "." ~ prefix ~ id.to!string;
    }

public:
    /// Constructor for root or wrapping an existing widget.
    this(Tcl_Interp* interp, string path, Widget parent = null)
    {
        this._interp = interp;
        this._path = path;
        this._parent = parent;
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

    /// Whether this widget has been destroyed.
    @property bool isDestroyed() const pure nothrow @nogc @safe
    {
        return _isDestroyed;
    }

    /// Destroys this widget in Tk.
    void destroy()
    {
        if (!_isDestroyed && _interp !is null)
        {
            evalCmd(_interp, "destroy", _path);
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
