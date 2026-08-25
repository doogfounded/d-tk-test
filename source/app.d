module app;

import std.stdio;
import dtk;

void main(string[] args)
{
    writeln("--- Phase 2: Generic Widget Abstraction Test ---");

    auto app = new TkApp();
    scope(exit) app.dispose();

    auto root = app.root();
    root.title = "D + Tk Phase 2 - Widget Test";

    // 1. Test TkRoot as a Widget
    assert(root.path == ".");
    assert(root.parent is null);
    assert(!root.isDestroyed);
    writeln("[PASS] Root window is a valid Widget: path = ", root.path);

    // 2. Test Widget path generation & creation
    // A subclass of Widget or direct Widget instance
    class CustomWidget : Widget
    {
        this(Widget parent, string cmdType, string text)
        {
            string childPath = parent.generateChildPath("w");
            super(parent.interp, childPath, parent);
            evalCmd(_interp, cmdType, _path, "-text", text);
        }
    }

    auto btn1 = new CustomWidget(root, "button", "Button 1 (Normal)");
    assert(btn1.path == ".w1");
    assert(btn1.parent is root);
    assert(!btn1.isDestroyed);
    writeln("[PASS] Child widget created with hierarchical path: ", btn1.path);

    // 3. Test configure and cget with safe string handling (special characters that would break raw eval)
    string specialText = "Text with special chars: { [ $var \" ' ] } \\";
    btn1.configure("text", specialText);
    string retrievedText = btn1.cget("text");
    assert(retrievedText == specialText, "Config text mismatch: " ~ retrievedText);
    writeln("[PASS] configure and cget round-trip with special characters: ", retrievedText);

    // 4. Test Pack geometry manager
    btn1.pack(PackOptions.init.setPadx(15).setPady(10).setFill("x").setExpand(true));
    writeln("[PASS] Widget packed with PackOptions.");
    btn1.packForget();
    writeln("[PASS] Widget unpacked with packForget.");

    // 5. Test Grid geometry manager
    auto btn2 = new CustomWidget(root, "button", "Button 2 (Grid)");
    btn2.grid(0, 0);
    writeln("[PASS] Widget placed in grid(0, 0).");
    btn2.gridForget();
    writeln("[PASS] Widget removed from grid with gridForget.");

    // 6. Test Place geometry manager
    auto btn3 = new CustomWidget(root, "button", "Button 3 (Place)");
    btn3.place(20, 20, 200, 35);
    writeln("[PASS] Widget positioned with place(20, 20, 200, 35).");

    // 7. Test nested child hierarchy
    class FrameWidget : Widget
    {
        this(Widget parent)
        {
            string childPath = parent.generateChildPath("frm");
            super(parent.interp, childPath, parent);
            evalCmd(_interp, "frame", _path);
        }
    }

    auto frame = new FrameWidget(root);
    auto nestedBtn = new CustomWidget(frame, "button", "Nested Button");
    assert(frame.path == ".frm4");
    assert(nestedBtn.path == ".frm4.w5");
    assert(nestedBtn.parent is frame);
    writeln("[PASS] Nested widget path hierarchy verified: ", nestedBtn.path);

    // 8. Test Widget destruction
    btn2.destroy();
    assert(btn2.isDestroyed);
    bool caughtDestroyError = false;
    try
    {
        btn2.configure("text", "Should fail");
    }
    catch (TclException ex)
    {
        caughtDestroyError = true;
        writeln("[PASS] Caught expected exception on destroyed widget: ", ex.msg);
    }
    assert(caughtDestroyError);

    // Clean up temporary place button and pack the nested hierarchy for visual display
    btn3.destroy();
    frame.pack(PackOptions.init.setPadx(20).setPady(20));
    nestedBtn.pack(PackOptions.init.setPadx(10).setPady(10));

    bool interactive = (args.length > 1 && args[1] == "--interactive");
    if (!interactive)
    {
        app.eval("after 500 {destroy .}");
        writeln("Running Tk event loop for 500ms (automated test)...");
    }
    else
    {
        writeln("Running Tk event loop. Close the window to exit.");
    }

    app.run();
    writeln("[PASS] Tk event loop exited cleanly.");
    writeln("--- Phase 2 All Tests Passed Successfully ---");
}