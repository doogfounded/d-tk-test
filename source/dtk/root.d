module dtk.root;

import tcl;
import dtk.core;
import dtk.widget;
import dtk.callback;
import std.conv : to;

/// Represents the Tk root main window ('.').
class TkRoot : Widget
{
public:
    this(Tcl_Interp* interp, CallbackRegistry registry = null)
    {
        super(interp, ".", null, registry);
    }

    /// Gets the window title via 'wm title .'.
    @property string title()
    {
        return evalCmd(_interp, "wm", "title", _path);
    }

    /// Sets the window title via 'wm title . <newTitle>'.
    @property void title(string newTitle)
    {
        evalCmd(_interp, "wm", "title", _path, newTitle);
    }

    /// Gets the window geometry string (e.g. "400x300+100+100").
    @property string geometry()
    {
        return evalCmd(_interp, "wm", "geometry", _path);
    }

    /// Sets the window geometry via a spec string (e.g. "400x300").
    @property void geometry(string spec)
    {
        evalCmd(_interp, "wm", "geometry", _path, spec);
    }

    /// Sets the window size and optional screen position.
    void setGeometry(int width, int height, int x = int.min, int y = int.min)
    {
        string spec = width.to!string ~ "x" ~ height.to!string;
        if (x != int.min && y != int.min)
        {
            spec ~= (x >= 0 ? "+" : "") ~ x.to!string;
            spec ~= (y >= 0 ? "+" : "") ~ y.to!string;
        }
        geometry = spec;
    }

    /// Sets whether the window is resizable in width and height.
    void resizable(bool widthResizable, bool heightResizable)
    {
        evalCmd(_interp, "wm", "resizable", _path, widthResizable ? "1" : "0", heightResizable ? "1" : "0");
    }

    /// Sets minimum window dimensions.
    void minsize(int width, int height)
    {
        evalCmd(_interp, "wm", "minsize", _path, width.to!string, height.to!string);
    }

    /// Sets maximum window dimensions.
    void maxsize(int width, int height)
    {
        evalCmd(_interp, "wm", "maxsize", _path, width.to!string, height.to!string);
    }
}
