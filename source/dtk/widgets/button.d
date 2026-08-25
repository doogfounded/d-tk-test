module dtk.widgets.button;

import tcl;
import dtk.core;
import dtk.widget;

/// A clickable push-button widget.
class Button : Widget
{
public:
    this(Widget parent, string initialText = "")
    {
        string childPath = parent.generateChildPath("btn");
        super(parent.interp, childPath, parent);
        evalCmd(_interp, "ttk::button", _path, "-text", initialText);
    }

    /// The text displayed on the button.
    @property string text()
    {
        return cget("text");
    }

    /// Sets the text displayed on the button.
    @property void text(string val)
    {
        configure("text", val);
    }

    /// Whether the button is interactable.
    @property bool enabled()
    {
        return cget("state") != "disabled";
    }

    /// Enables or disables the button.
    @property void enabled(bool val)
    {
        configure("state", val ? "normal" : "disabled");
    }
}
