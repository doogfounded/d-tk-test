module app;

import std.stdio;
import dtk;

void main(string[] args)
{
    writeln("--- Phase 3: Concrete Widgets (Frame, Label, Button, Entry) Test ---");

    auto app = new TkApp();
    scope(exit) app.dispose();

    auto root = app.root();
    root.title = "D + Tk Phase 3 - Widgets Test";

    // 1. Create a Frame inside root
    auto frame = root.frame(15);
    assert(frame.path == ".frame1");
    assert(frame.parent is root);
    writeln("[PASS] Frame created with path: ", frame.path);

    // 2. Create a Label inside the Frame
    auto label = frame.label("Initial Label Text");
    assert(label.path == ".frame1.lbl2");
    assert(label.parent is frame);
    assert(label.text == "Initial Label Text");
    
    label.text = "Updated Label: Welcome to DTk!";
    assert(label.text == "Updated Label: Welcome to DTk!");
    writeln("[PASS] Label created and text property verified: '", label.text, "'");

    // 3. Create a Button inside the Frame
    auto button = frame.button("Click Me!");
    assert(button.path == ".frame1.btn3");
    assert(button.parent is frame);
    assert(button.text == "Click Me!");
    assert(button.enabled == true);

    button.text = "Save Changes";
    assert(button.text == "Save Changes");
    button.enabled = false;
    assert(button.enabled == false);
    button.enabled = true;
    assert(button.enabled == true);
    writeln("[PASS] Button created, text and enabled properties verified: '", button.text, "'");

    // 4. Create an Entry inside the Frame
    auto entry = frame.entry("Hello Tk Entry");
    assert(entry.path == ".frame1.entry4");
    assert(entry.parent is frame);
    assert(entry.text == "Hello Tk Entry");

    entry.text = "New Entry Content";
    assert(entry.text == "New Entry Content");

    entry.insert(4, "D ");
    assert(entry.text == "New D Entry Content");

    entry.clear();
    assert(entry.text == "");
    entry.text = "Final Text";

    entry.readOnly = true;
    assert(entry.readOnly == true);
    entry.readOnly = false;
    assert(entry.readOnly == false);
    writeln("[PASS] Entry created, text/insert/clear/readOnly verified: '", entry.text, "'");

    // 5. Layout with Pack
    frame.pack(PackOptions.init.setPadx(20).setPady(20).setFill("both").setExpand(true));
    label.pack(PackOptions.init.setPady(5));
    entry.pack(PackOptions.init.setPady(5).setFill("x"));
    button.pack(PackOptions.init.setPady(10));
    writeln("[PASS] All widgets laid out cleanly with Pack.");

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
    writeln("--- Phase 3 All Tests Passed Successfully ---");
}