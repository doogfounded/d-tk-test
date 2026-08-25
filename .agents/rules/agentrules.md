---
trigger: always_on
---

I want you to help me build a D language wrapper around Tcl/Tk 8.6 on 64-bit Windows.

Environment:
- Windows 11 x64
- DMD x86_64
- modern DUB
- ImportC
- MSVC Build Tools / cl.exe
- Magicsplat Tcl/Tk 8.6
- Tcl/Tk currently works from a minimal D program
- Tcl/Tk import libraries:
  C:\Users\Doug\AppData\Local\Apps\Tcl86\lib\tcl86t.lib
  C:\Users\Doug\AppData\Local\Apps\Tcl86\lib\tk86t.lib
- Tcl/Tk headers:
  C:\Users\Doug\AppData\Local\Apps\Tcl86\include
- Runtime DLLs are already present beside the executable.

The goal is NOT to create a giant GUI framework immediately.

I want a small, idiomatic D wrapper that lets application code look approximately like:

    auto app = new TkApp();

    auto root = app.root();

    auto button = root.button("Click me");

    button.onClick = () {
        writeln("clicked");
    };

    button.pack();

    app.run();

Internally, the wrapper should use Tcl/Tk's C API and Tcl commands.

Build this incrementally.

PHASE 1:
Create the lowest-level Tcl/Tk wrapper:
- TkApp
- interpreter creation/destruction
- Tcl_Init
- Tk_Init
- Tcl_Eval
- error handling
- application/event loop
- root widget representation

PHASE 2:
Create a generic Widget abstraction:
- Tcl/Tk widget path
- parent relationship
- widget creation
- destroy
- pack/grid/place helpers
- configure helper
- safe handling of Tcl strings

PHASE 3:
Implement a few widgets:
- Frame
- Label
- Button
- Entry

Example API:

    auto frame = root.frame();
    auto label = frame.label("Hello");
    auto button = frame.button("Click me");

Prefer strongly typed D methods/properties over raw Tcl strings.

PHASE 4:
Implement callbacks.

I want:

    button.onClick = () {
        writeln("clicked");
    };

Tk cannot directly call a D delegate, so create a bridge from Tcl commands to D delegates.

Design a callback registry with unique IDs. Tcl should invoke something conceptually like:

    d_callback 42

and the D side should dispatch callback 42 to the stored delegate.

Handle:
- callback registration
- callback invocation
- callback removal
- widget destruction
- preventing calls into destroyed D delegates
- cleanup when TkApp is destroyed

Use @safe/@nogc only where practical; do not sacrifice correctness merely to force those attributes.

PHASE 5:
Make the API pleasant.

I want code like:

    auto app = new TkApp();
    auto window = app.root();

    window.title = "Test";

    auto button = window.button("Hello");

    button.onClick = () {
        writeln("Hello from D!");
    };

    button.pack(padx: 20, pady: 20);

    app.run();

Avoid making application code manually construct Tcl command strings.

IMPORTANT DESIGN REQUIREMENTS:
- Do not hide Tcl/Tk behind an unnecessarily complicated architecture.
- Keep the underlying Tcl widget path available for debugging.
- Separate the low-level Tcl/Tk binding from the higher-level D widget API.
- Avoid unsafe string concatenation where Tcl quoting/injection could become a problem.
- Prefer Tcl objects / Tcl API functions over Tcl_Eval string construction when practical.
- Use RAII/destructors carefully so Tcl objects and callbacks do not outlive the interpreter.
- Don't invent APIs without checking the actual Tcl/Tk 8.6 headers available in the environment.
- Keep the first implementation small and buildable.

WORKFLOW:
1. Inspect the current project structure.
2. Propose a small architecture.
3. Implement only Phase 1.
4. Build it with DUB.
5. Run a minimal test.
6. Show me the files changed and explain why.
7. Only after Phase 1 works, proceed to Phase 2.
8. Repeat this incremental process for every phase.

For each phase:
- give me the exact files to create/change
- give me complete source code
- give me the exact `dub` command to run
- identify likely Windows/MSVC/Tcl pitfalls
- do not proceed to the next phase until the current phase has a working test

The end result should feel like a small native D binding to Tk rather than a Tcl scripting project written in D.