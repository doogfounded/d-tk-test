module dtk.widgets.button;

import tcl;
import dtk.core;
import dtk.widget;
import std.conv : to;

/// A clickable push-button widget.
class Button : Widget
{
private:
    void delegate() _onClickDg;
    size_t _onClickId = 0;

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

    /// Sets the click callback delegate.
    @property void onClick(void delegate() dg)
    {
        _onClickDg = dg;
        if (_onClickId != 0)
        {
            unregisterCallback(_onClickId);
            _onClickId = 0;
        }

        if (dg !is null)
        {
            _onClickId = registerCallback(dg);
            configure("command", "d_callback " ~ _onClickId.to!string);
        }
        else
        {
            configure("command", "");
        }
    }

    /// Gets the currently registered click callback delegate.
    @property void delegate() onClick() pure nothrow @nogc @safe
    {
        return _onClickDg;
    }
}
