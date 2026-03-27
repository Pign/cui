# State & Actions

## Declaring State

Add `@:state` before a field declaration in `App` or `ViewComponent`:

```haxe
class MyApp extends App {
    @:state var count:Int = 0;
    @:state var name:String = "World";
    @:state var active:Bool = false;
    @:state var progress:Float = 0.0;
}
```

The `StateMacro` transforms these at compile time:
- `@:state var count:Int = 0` becomes a field of type `IntState`
- The constructor is injected with `count = new IntState(0, "count")`

## Reading State

Use `.get()` to read the current value:

```haxe
new Text('Count: ${count.get()}')
```

In string interpolation, `.toString()` is called automatically:

```haxe
new Text('Count: $count')  // also works
```

## Mutating State

### Common Methods (all types)

```haxe
count.set(42);       // set to a specific value
count.setTo(42);     // same, but returns the State for chaining
```

### IntState

```haxe
count.inc();         // increment by 1
count.inc(5);        // increment by 5
count.dec();         // decrement by 1
count.dec(3);        // decrement by 3
```

### FloatState

```haxe
progress.inc(0.1);   // increment by 0.1
progress.dec(0.05);  // decrement by 0.05
```

### BoolState

```haxe
active.toggle();     // flip true/false
```

### StringState

```haxe
name.append(" Jr."); // append text
name.clear();        // set to ""
```

## State in Event Handlers

Mutate state in `handleEvent()` or in callbacks:

```haxe
override public function handleEvent(event:Event):Bool {
    switch (event) {
        case Key(key):
            switch (key.code) {
                case Char(c):
                    if (c == "+") { count.inc(); return true; }
                default:
            }
        default:
    }
    return false;
}
```

Or in button/checkbox callbacks:

```haxe
new Button("Reset", () -> count.set(0))
```

After any `.set()`, `.inc()`, `.toggle()`, etc., the UI automatically re-renders.

## Non-State Data

You can also use regular (non-`@:state`) fields. These won't trigger re-renders automatically — you need to call `StateBase.markDirty()` manually:

```haxe
class MyApp extends App {
    var items:Array<String> = [];  // not @:state

    // After modifying items, manually trigger re-render:
    // StateBase.markDirty();
}
```
