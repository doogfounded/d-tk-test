module dtk.widgets.label;

import tcl;
import dtk.core;
import dtk.widget;

/// A widget that displays text or an image.
class Label : Widget
{
public:
    this(Widget parent, string initialText = "")
    {
        string childPath = parent.generateChildPath("lbl");
        super(parent.interp, childPath, parent);
        evalCmd(_interp, "ttk::label", _path, "-text", initialText);
    }

    /// The text displayed by the label.
    @property string text()
    {
        return cget("text");
    }

    /// Sets the text displayed by the label.
    @property void text(string val)
    {
        configure("text", val);
    }

    /// Text alignment anchor (e.g. "w", "center", "e", "n", "s").
    @property string anchor()
    {
        return cget("anchor");
    }

    /// Sets text alignment anchor.
    @property void anchor(string val)
    {
        configure("anchor", val);
    }
}
