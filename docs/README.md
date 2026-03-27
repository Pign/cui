# cui

**Declarative Terminal User Interface framework for Haxe**, inspired by [sui](https://github.com/pign/sui).

Write TUI apps with the same declarative pattern as SwiftUI — composable views, chainable modifiers, and reactive state — but rendering to a terminal instead of native UI.

## At a Glance

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

## Key Features

| Feature | Description |
|---------|-------------|
| **Declarative API** | `App` -> `body()` -> composable `View` tree |
| **17 Built-in Views** | Text, VStack, HStack, Button, Input, ListView, Table, Tabs, and more |
| **Chainable Modifiers** | `.bold()`, `.foregroundColor()`, `.padding()`, `.border()`, etc. |
| **Reactive State** | `@:state` macro with automatic re-render on mutation |
| **Focus Management** | Tab/Shift-Tab navigation with visual indicators |
| **Mouse Support** | Click to focus, scroll wheel |
| **Diff Rendering** | Only changed cells are written to the terminal |
| **Native Binaries** | Compiles to C++ via hxcpp |

## How It Compares to sui

| | sui | cui |
|---|-----|-----|
| **Target** | Native Apple apps (SwiftUI) | Terminal UI |
| **Output** | macOS, iOS, iPadOS, visionOS | Linux, macOS, Windows |
| **Rendering** | SwiftUI via Swift code generation | ANSI escape codes via virtual buffer |
| **API** | `App` -> `body()` -> Views + Modifiers | Same pattern |
| **State** | `@:state` -> Swift @State | `@:state` -> runtime State\<T> |
| **Bridge** | Haxe <-> C++ <-> Swift | Not needed (runs directly) |

## Next Steps

- [Getting Started](getting-started.md) — Install and create your first app
- [Views](views/README.md) — Explore the 17 built-in views
- [State](state/README.md) — Learn reactive state management
- [Examples](examples/README.md) — Browse the 7 example apps
