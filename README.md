# cui

Declarative Terminal User Interface framework for Haxe, inspired by [sui](https://github.com/pign/sui).

Write TUI apps with the same declarative pattern as SwiftUI — composable views, chainable modifiers, and reactive state — but rendering to a terminal instead of native UI.

```haxe
class MyApp extends App {
    @:state var count:Int = 0;

    override public function body():View {
        return new VStack([
            new Text('Count: ${count.get()}').bold(),
            new HStack([
                new Button("+", () -> count.inc()),
                new Button("-", () -> count.dec()),
            ], 1),
        ]).padding(1).border(Rounded);
    }

    static function main() {
        new MyApp().run();
    }
}
```

## Features

- **Declarative API** — `App` → `body()` → composable `View` tree, just like sui
- **17 built-in views** — Text, VStack, HStack, Box, Spacer, Divider, Button, Input, Checkbox, ListView, Table, ProgressBar, Tabs, ForEach, ScrollView, View, ViewComponent
- **Chainable modifiers** — `.bold()`, `.foregroundColor()`, `.padding()`, `.border()`, `.width()`, `.alignment()`, etc.
- **Reactive state** — `@:state` macro transforms fields into reactive `State<T>` wrappers; UI re-renders automatically on mutation
- **Focus management** — Tab/Shift-Tab navigation with visual focus indicators
- **Mouse support** — Click to focus, SGR mouse event parsing
- **Diff-based rendering** — Virtual buffer with cell-level diffing; only changed cells hit the terminal
- **Two-pass flex layout** — Compact children keep natural size, greedy children share remaining space equally
- **Cross-platform** — POSIX backend (macOS/Linux) via termios C FFI; Windows planned
- **Native binaries** — Compiles to C++ via hxcpp

## Quick Start

```bash
# Install
haxelib git cui https://github.com/pign/cui

# Create a project
haxelib run cui init MyApp
cd myapp

# Build and run
haxe build.hxml
./bin/MyApp
```

## Views

| View | Description |
|------|-------------|
| `Text` | Styled text with word wrapping |
| `VStack` | Vertical layout with spacing |
| `HStack` | Horizontal layout with spacing |
| `Box` | Container with optional border |
| `Spacer` | Flexible space filler |
| `Divider` | Horizontal or vertical line |
| `Button` | Activatable element (Enter/Space/click) |
| `Input` | Text input field with cursor and Binding |
| `Checkbox` | Toggle with `[✓]`/`[ ]` and label |
| `ListView` | Scrollable list with selection and scroll indicator |
| `Table` | Tabular data with auto-sized columns |
| `ProgressBar` | Progress indicator with sub-cell block characters |
| `Tabs` | Tab navigation with Left/Right arrows |
| `ForEach` | Data-driven view repetition |
| `ScrollView` | Scrollable content wrapper |
| `ViewComponent` | Base class for custom reusable components |

## Modifiers

```haxe
new Text("Hello")
    .bold()
    .italic()
    .underline()
    .foregroundColor(Color.Named(NamedColor.Cyan))
    .backgroundColor(Color.Rgb(30, 30, 30))
    .padding(1)
    .border(Rounded)
    .width(40)
    .alignment(Center)
```

## State Management

Fields marked `@:state` are automatically wrapped in reactive state objects:

```haxe
class MyApp extends App {
    @:state var count:Int = 0;       // becomes IntState (has .inc(), .dec())
    @:state var name:String = "";    // becomes StringState (has .append(), .clear())
    @:state var active:Bool = false; // becomes BoolState (has .toggle())
    @:state var ratio:Float = 0.5;   // becomes FloatState (has .inc(), .dec())
}
```

Read with `.get()`, write with `.set()` or type-specific methods. The UI automatically re-renders when state changes.

For shared state across components, extend `Observable`:

```haxe
class AppState extends Observable {
    @:state var theme:String = "dark";
}
```

## Two-way Binding

Pass state to child views with `Binding`:

```haxe
@:state var searchText:String = "";

new Input(Binding.from(searchText), "Search...")
```

ListView uses `ListSelection`, Tabs uses `TabSelection`, Checkbox uses `CheckboxBinding`.

## Focus & Input

- **Tab / Shift-Tab** — cycle focus between interactive views
- **Arrow keys** — navigate within ListView, Tabs
- **Enter / Space** — activate Button, toggle Checkbox
- **Mouse click** — focus the clicked view
- **Ctrl+C** — quit

## Architecture

```
body() → View tree → measure(constraint) → render(buffer) → diff → ANSI output
                                                                ↑
                                    @:state mutation → dirty flag → re-render
```

Full re-render on every state change (immediate-mode). Buffer diffing ensures only changed cells are written to the terminal.

## Examples

```bash
haxe build.hxml           && ./bin/HelloApp          # Layout demo
haxe build-counter.hxml   && ./bin-counter/CounterApp # Reactive state
haxe build-form.hxml      && ./bin-form/FormApp       # Form with inputs, checkboxes
haxe build-todo.hxml      && ./bin-todo/TodoApp       # Todo list
haxe build-dashboard.hxml && ./bin-dashboard/DashboardApp # Tabs, tables, progress bars
```

## Requirements

- Haxe 4.3+
- hxcpp

## License

MIT
