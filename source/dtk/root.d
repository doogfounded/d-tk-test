module dtk.root;

import tcl;
import dtk.core;
import dtk.widget;

/// Represents the Tk root window ('.').
class TkRoot : Widget
{
public:
    this(Tcl_Interp* interp)
    {
        super(interp, ".", null);
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
}
