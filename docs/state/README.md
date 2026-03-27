# State Management

cui uses a reactive state system inspired by SwiftUI's `@State`. When state changes, the UI automatically re-renders.

## Overview

```haxe
class MyApp extends App {
    @:state var count:Int = 0;

    override public function body():View {
        return new Text('Count: ${count.get()}');
    }
}
```

### How It Works

1. `@:state` fields are transformed at compile time by `StateMacro` into `State<T>` wrappers
2. When you call `.set()`, `.inc()`, or any mutation, a global dirty flag is set
3. The event loop detects the dirty flag and calls `body()` again
4. The new view tree is rendered into a buffer and diffed against the previous frame
5. Only changed cells are written to the terminal

This is an **immediate-mode** approach — `body()` is a pure function of state, called on every change. The diff-based renderer makes this efficient.

## State Types

| Original Type | Transformed To | Extra Methods |
|--------------|---------------|---------------|
| `Int` | `IntState` | `.inc()`, `.dec()` |
| `Float` | `FloatState` | `.inc()`, `.dec()` |
| `Bool` | `BoolState` | `.toggle()` |
| `String` | `StringState` | `.append()`, `.clear()` |
| Other | `State<T>` | (base methods only) |

All state types share: `.get()`, `.set(value)`, `.setTo(value)`, `.toString()`

## Where State Lives

| Scope | Mechanism | Details |
|-------|-----------|---------|
| Single App | `@:state` on `App` | [State & Actions](state-and-actions.md) |
| Single Component | `@:state` on `ViewComponent` | [Components](../components.md) |
| Shared across components | `Observable` subclass | [Observable](observable.md) |
| Passed to child views | `Binding`, `ListSelection`, etc. | [Binding](binding.md) |

## Next Steps

- [State & Actions](state-and-actions.md) — Declaring and mutating state
- [Binding](binding.md) — Two-way state passing
- [Observable](observable.md) — Shared state models
