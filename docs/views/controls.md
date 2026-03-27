# Controls

Interactive views that respond to keyboard and mouse input when focused.

## Button

A focusable element with a label and action callback.

```haxe
new Button("Save", () -> {
    // action when pressed
    saveData();
})
```

**Constructor**: `new Button(label:String, action:Void->Void)`

### Rendering

Buttons render as `[ label ]`. When focused, they display with inverse colors.

### Interaction

| Input | Action |
|-------|--------|
| Enter | Activate |
| Space | Activate |
| Mouse click | Focus + activate on next Enter/Space |

## Input

A focusable text input field with cursor, bound to a string state via `Binding`.

```haxe
@:state var name:String = "";

new Input(Binding.from(name), "Enter your name")
    .border(Single)
```

**Constructor**: `new Input(binding:Binding<String>, placeholder:String = "")`

### Rendering

- Shows placeholder text (dimmed) when empty and not focused
- Shows text content with a blinking cursor (inverse cell) when focused
- Scrolls horizontally when text exceeds field width

### Interaction

| Input | Action |
|-------|--------|
| Characters | Insert at cursor |
| Backspace | Delete before cursor |
| Delete | Delete after cursor |
| Left/Right | Move cursor |
| Home | Move to start |
| End | Move to end |

### Binding

Input requires a `Binding<String>` to write back to the parent's state:

```haxe
@:state var email:String = "";

// Binding.from() creates a two-way binding from a State<String>
new Input(Binding.from(email), "user@example.com")
```

See [Binding](../state/binding.md) for details.

## Checkbox

A focusable toggle with a label, bound to a boolean state via `CheckboxBinding`.

```haxe
@:state var agreed:Bool = false;

new Checkbox("I agree to the terms", CheckboxBinding.fromState(agreed))
```

**Constructor**: `new Checkbox(label:String, binding:CheckboxBinding)`

### Rendering

```
[✓] Checked label
[ ] Unchecked label
```

When focused, the checkbox marker displays with inverse colors.

### Interaction

| Input | Action |
|-------|--------|
| Enter | Toggle |
| Space | Toggle |
