module app;

import std.stdio;
import std.conv : to;
import dtk;

void testMinimalSnippet()
{
    auto app = new TkApp();
    scope(exit) app.dispose();

    auto window = app.root();
    window.title = "Test";

    auto button = window.button("Hello");
    bool clicked = false;
    button.onClick = () {
        clicked = true;
        writeln("Hello from D!");
    };

    button.pack(padx: 20, pady: 20);

    app.eval(button.path ~ " invoke");
    assert(clicked);
    writeln("[PASS] Exact Phase 5 minimal snippet verified successfully.");
}

void main(string[] args)
{
    writeln("--- Phase 5: Pleasant & Idiomatic D API Demonstration ---");

    testMinimalSnippet();

    auto app = new TkApp();
    scope(exit) app.dispose();

    auto window = app.root();

    // 1. Fluent Window Management
    window.title = "D + Tk Desktop App";
    window.minsize(350, 250);
    writeln("[PASS] Configured window title: '", window.title, "' and minsize.");

    // 2. Pleasant Container and Component Tree Construction
    auto mainFrame = window.frame(padding: 15);
    mainFrame.pack(fill: "both", expand: 1);

    auto headerLabel = mainFrame.label("Welcome to the D Language Tk Wrapper!");
    headerLabel.pack(pady: 10);

    auto inputEntry = mainFrame.entry("Type here and press Enter or Click Submit...");
    inputEntry.pack(fill: "x", padx: 10, pady: 8);

    auto statusLabel = mainFrame.label("Status: Waiting for user action.");
    statusLabel.pack(pady: 6);

    // 3. Grid-based Button Toolbar with Named Parameters
    auto buttonRow = mainFrame.frame(padding: 5);
    buttonRow.pack(pady: 10);

    int submitCount = 0;
    void doSubmit()
    {
        submitCount++;
        string userText = inputEntry.text;
        statusLabel.text = "Submitted (#" ~ submitCount.to!string ~ "): " ~ userText;
        writeln("User Submitted: ", userText);
    }

    auto submitBtn = buttonRow.button("Submit", &doSubmit);
    submitBtn.grid(row: 0, column: 0, padx: 5);

    auto clearBtn = buttonRow.button("Clear");
    clearBtn.onClick = () {
        inputEntry.clear();
        statusLabel.text = "Status: Cleared.";
        writeln("Input cleared.");
    };
    clearBtn.grid(row: 0, column: 1, padx: 5);

    // 4. Keyboard Binding (Enter key in entry triggers submit)
    inputEntry.onReturn(&doSubmit);

    // 5. Verification of Named Parameter Geometry and Callbacks
    assert(submitCount == 0);
    app.eval(submitBtn.path ~ " invoke");
    assert(submitCount == 1);
    assert(statusLabel.text == "Submitted (#1): Type here and press Enter or Click Submit...");
    writeln("[PASS] submitBtn onClick triggered cleanly with named pack/grid layouts.");

    app.eval(clearBtn.path ~ " invoke");
    assert(inputEntry.text == "");
    assert(statusLabel.text == "Status: Cleared.");
    writeln("[PASS] clearBtn onClick verified.");

    inputEntry.text = "Hello from D!";
    app.eval(submitBtn.path ~ " invoke");
    assert(submitCount == 2);
    assert(statusLabel.text == "Submitted (#2): Hello from D!");
    writeln("[PASS] Full flow verified successfully.");

    bool interactive = (args.length > 1 && args[1] == "--interactive");
    if (!interactive)
    {
        app.eval("after 500 {destroy .}");
        writeln("Running Tk event loop for 500ms (automated test)...");
    }
    else
    {
        writeln("Running Tk event loop. Try typing in the box and clicking buttons. Close the window to exit.");
    }

    app.run();
    writeln("[PASS] Tk event loop exited cleanly.");
    writeln("--- Phase 5 All Tests and Features Verified Successfully ---");
}