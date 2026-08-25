module dtk.widgets.frame;

import tcl;
import dtk.core;
import dtk.widget;
import std.conv : to;

/// A container widget used to group and layout other widgets.
class Frame : Widget
{
public:
    this(Widget parent, int padding = -1)
    {
        string childPath = parent.generateChildPath("frame");
        super(parent.interp, childPath, parent);

        string[] cmd = ["ttk::frame", _path];
        if (padding >= 0)
            cmd ~= ["-padding", padding.to!string];

        evalCmd(_interp, cmd);
    }
}
