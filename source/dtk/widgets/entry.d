module dtk.widgets.entry;

import tcl;
import dtk.core;
import dtk.widget;
import std.conv : to;

/// A single-line text entry widget.
class Entry : Widget
{
public:
    this(Widget parent, string initialText = "")
    {
        string childPath = parent.generateChildPath("entry");
        super(parent.interp, childPath, parent);
        evalCmd(_interp, "ttk::entry", _path);

        if (initialText.length > 0)
            text = initialText;
    }

    /// The current text value inside the entry.
    @property string text()
    {
        return evalCmd(_interp, _path, "get");
    }

    /// Sets the text content in the entry.
    @property void text(string val)
    {
        // Must temporarily make editable if readonly
        bool wasReadOnly = readOnly;
        if (wasReadOnly)
            readOnly = false;

        evalCmd(_interp, _path, "delete", "0", "end");
        if (val.length > 0)
            evalCmd(_interp, _path, "insert", "0", val);

        if (wasReadOnly)
            readOnly = true;
    }

    /// Clears all text inside the entry.
    void clear()
    {
        text = "";
    }

    /// Inserts text at the specified character index.
    void insert(int index, string str)
    {
        evalCmd(_interp, _path, "insert", index.to!string, str);
    }

    /// Deletes text between character index `first` and `last`.
    void deleteRange(int first, int last)
    {
        evalCmd(_interp, _path, "delete", first.to!string, last.to!string);
    }

    /// Whether the entry is in read-only mode.
    @property bool readOnly()
    {
        return cget("state") == "readonly";
    }

    /// Sets read-only mode.
    @property void readOnly(bool val)
    {
        configure("state", val ? "readonly" : "normal");
    }

    /// Whether the entry is interactable.
    @property bool enabled()
    {
        return cget("state") != "disabled";
    }

    /// Enables or disables the entry.
    @property void enabled(bool val)
    {
        configure("state", val ? "normal" : "disabled");
    }

    /// Convenience helper to bind Enter/Return key press in this entry.
    void onReturn(void delegate() dg)
    {
        bind("<Return>", dg);
    }
}
