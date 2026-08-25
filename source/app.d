module app;

import std.stdio;
import dtk;

void main(string[] args)
{
    writeln("--- Phase 1: TkApp & Low-Level Tcl/Tk Binding Test ---");

    auto app = new TkApp();
    scope(exit) app.dispose();

    auto root = app.root();

    // 1. Check root path and interp handle
    assert(root.path == ".");
    assert(root.interp !is null);
    writeln("[PASS] Root representation and interpreter handle initialized.");

    // 2. Test title getter & setter
    root.title = "D + Tk Phase 1 Test";
    string currentTitle = root.title;
    assert(currentTitle == "D + Tk Phase 1 Test", "Title mismatch: " ~ currentTitle);
    writeln("[PASS] Root window title set and retrieved: '", currentTitle, "'");

    // 3. Test Tcl_Eval math expression
    string mathResult = app.eval("expr 21 * 2");
    assert(mathResult == "42", "Eval result mismatch: " ~ mathResult);
    writeln("[PASS] Tcl_Eval expression evaluated: 21 * 2 = ", mathResult);

    // 4. Test error handling (TclException on syntax or runtime error)
    bool caughtException = false;
    try
    {
        app.eval("nonexistent_command_12345");
    }
    catch (TclException ex)
    {
        caughtException = true;
        writeln("[PASS] Caught expected TclException: ", ex.msg);
    }
    assert(caughtException, "Expected TclException was not thrown!");

    // 5. Create a button using Tcl script
    app.eval("button .b -text {Hello from D TkApp!} -command {puts {Phase 1 Button Clicked!}}");
    app.eval("pack .b -padx 40 -pady 40");
    writeln("[PASS] Widget created and packed via Tcl commands.");

    bool interactive = (args.length > 1 && args[1] == "--interactive");
    if (!interactive)
    {
        // Auto-close after 500ms for automated runs
        app.eval("after 500 {destroy .}");
        writeln("Running Tk event loop for 500ms (automated test)...");
    }
    else
    {
        writeln("Running Tk event loop. Close the window to exit.");
    }

    app.run();
    writeln("[PASS] Tk event loop exited cleanly.");
    writeln("--- Phase 1 All Tests Passed Successfully ---");
}