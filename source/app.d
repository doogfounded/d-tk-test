module app;

import std.stdio;
import std.conv : to;
import dtk;

void main(string[] args)
{
    writeln("--- Phase 4: Callbacks & D Delegate Bridge Test ---");

    auto app = new TkApp();
    scope(exit) app.dispose();

    auto root = app.root();
    root.title = "D + Tk Phase 4 - Callbacks Test";

    auto frame = root.frame(20);
    auto label = frame.label("Clicks: 0");
    auto button = frame.button("Click Me");
    auto entry = frame.entry("Type something...");

    // 1. Test D delegate callback registration
    int clickCount = 0;
    button.onClick = () {
        clickCount++;
        label.text = "Clicks: " ~ clickCount.to!string;
        entry.text = "Clicked " ~ clickCount.to!string ~ " times!";
    };

    assert(app.registry.isRegistered(1));
    writeln("[PASS] Button onClick registered with callback ID 1 in registry.");

    // 2. Programmatically invoke the button via Tk's invoke command
    app.eval(button.path ~ " invoke");
    assert(clickCount == 1, "Click count expected 1 but got " ~ clickCount.to!string);
    assert(label.text == "Clicks: 1");
    assert(entry.text == "Clicked 1 times!");
    writeln("[PASS] Button invoke successfully dispatched to D delegate: clickCount = ", clickCount);

    app.eval(button.path ~ " invoke");
    assert(clickCount == 2);
    writeln("[PASS] Second invoke verified: clickCount = ", clickCount);

    // 3. Test replacing the callback delegate
    int alternateCount = 0;
    button.onClick = () {
        alternateCount += 10;
    };
    assert(!app.registry.isRegistered(1), "Old callback ID 1 was not unregistered!");
    assert(app.registry.isRegistered(2), "New callback ID 2 is not registered!");
    writeln("[PASS] Replacing onClick properly unregistered old ID and registered new ID.");

    app.eval(button.path ~ " invoke");
    assert(clickCount == 2, "Old delegate should not have fired");
    assert(alternateCount == 10, "New delegate did not fire");
    writeln("[PASS] New delegate executed cleanly: alternateCount = ", alternateCount);

    // 4. Test setting callback to null
    button.onClick = null;
    assert(!app.registry.isRegistered(2));
    app.eval(button.path ~ " invoke");
    assert(alternateCount == 10);
    writeln("[PASS] Setting onClick to null removed callback cleanly.");

    // 5. Test widget destruction cleanup
    auto tempBtn = frame.button("Temp Button");
    bool tempFired = false;
    tempBtn.onClick = () {
        tempFired = true;
    };
    size_t tempId = 3;
    assert(app.registry.isRegistered(tempId));
    tempBtn.destroy();
    assert(!app.registry.isRegistered(tempId), "Destroyed widget callback was not cleaned up!");
    writeln("[PASS] Widget destruction properly unregistered callback from registry.");

    // Re-assign interactive callback for GUI
    button.onClick = () {
        clickCount++;
        label.text = "Clicks: " ~ clickCount.to!string;
        entry.text = "Clicked " ~ clickCount.to!string ~ " times!";
    };

    // Layout
    frame.pack(PackOptions.init.setPadx(20).setPady(20).setFill("both").setExpand(true));
    label.pack(PackOptions.init.setPady(5));
    entry.pack(PackOptions.init.setPady(5).setFill("x"));
    button.pack(PackOptions.init.setPady(10));
    writeln("[PASS] UI assembled with interactive callbacks.");

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
    writeln("--- Phase 4 All Tests Passed Successfully ---");
}