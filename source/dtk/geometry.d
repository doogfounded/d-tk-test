module dtk.geometry;

import std.conv : to;

/// Options for the Tk pack geometry manager.
struct PackOptions
{
    string side;     // "top", "bottom", "left", "right"
    string fill;     // "none", "x", "y", "both"
    int expand = -1; // -1: default, 0: false, 1: true
    int padx = -1;
    int pady = -1;
    int ipadx = -1;
    int ipady = -1;
    string anchor;

    PackOptions setSide(string s) { side = s; return this; }
    PackOptions setFill(string f) { fill = f; return this; }
    PackOptions setExpand(bool e) { expand = e ? 1 : 0; return this; }
    PackOptions setPadx(int p) { padx = p; return this; }
    PackOptions setPady(int p) { pady = p; return this; }
    PackOptions setIpadx(int p) { ipadx = p; return this; }
    PackOptions setIpady(int p) { ipady = p; return this; }
    PackOptions setAnchor(string a) { anchor = a; return this; }

    string[] toArgs() const
    {
        string[] args;
        if (side.length > 0) args ~= ["-side", side];
        if (fill.length > 0) args ~= ["-fill", fill];
        if (expand >= 0) args ~= ["-expand", expand ? "1" : "0"];
        if (padx >= 0) args ~= ["-padx", padx.to!string];
        if (pady >= 0) args ~= ["-pady", pady.to!string];
        if (ipadx >= 0) args ~= ["-ipadx", ipadx.to!string];
        if (ipady >= 0) args ~= ["-ipady", ipady.to!string];
        if (anchor.length > 0) args ~= ["-anchor", anchor];
        return args;
    }
}

/// Options for the Tk grid geometry manager.
struct GridOptions
{
    int row = -1;
    int column = -1;
    int rowspan = -1;
    int columnspan = -1;
    int padx = -1;
    int pady = -1;
    int ipadx = -1;
    int ipady = -1;
    string sticky;

    GridOptions setRow(int r) { row = r; return this; }
    GridOptions setColumn(int c) { column = c; return this; }
    GridOptions setRowspan(int rs) { rowspan = rs; return this; }
    GridOptions setColumnspan(int cs) { columnspan = cs; return this; }
    GridOptions setPadx(int p) { padx = p; return this; }
    GridOptions setPady(int p) { pady = p; return this; }
    GridOptions setIpadx(int p) { ipadx = p; return this; }
    GridOptions setIpady(int p) { ipady = p; return this; }
    GridOptions setSticky(string s) { sticky = s; return this; }

    string[] toArgs() const
    {
        string[] args;
        if (row >= 0) args ~= ["-row", row.to!string];
        if (column >= 0) args ~= ["-column", column.to!string];
        if (rowspan >= 0) args ~= ["-rowspan", rowspan.to!string];
        if (columnspan >= 0) args ~= ["-columnspan", columnspan.to!string];
        if (padx >= 0) args ~= ["-padx", padx.to!string];
        if (pady >= 0) args ~= ["-pady", pady.to!string];
        if (ipadx >= 0) args ~= ["-ipadx", ipadx.to!string];
        if (ipady >= 0) args ~= ["-ipady", ipady.to!string];
        if (sticky.length > 0) args ~= ["-sticky", sticky];
        return args;
    }
}

/// Options for the Tk place geometry manager.
struct PlaceOptions
{
    int x = int.min;
    int y = int.min;
    int width = int.min;
    int height = int.min;
    string anchor;

    PlaceOptions setX(int val) { x = val; return this; }
    PlaceOptions setY(int val) { y = val; return this; }
    PlaceOptions setWidth(int val) { width = val; return this; }
    PlaceOptions setHeight(int val) { height = val; return this; }
    PlaceOptions setAnchor(string a) { anchor = a; return this; }

    string[] toArgs() const
    {
        string[] args;
        if (x != int.min) args ~= ["-x", x.to!string];
        if (y != int.min) args ~= ["-y", y.to!string];
        if (width != int.min) args ~= ["-width", width.to!string];
        if (height != int.min) args ~= ["-height", height.to!string];
        if (anchor.length > 0) args ~= ["-anchor", anchor];
        return args;
    }
}
