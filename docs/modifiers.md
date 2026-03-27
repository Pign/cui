# Modifiers

Modifiers are chainable methods on any `View` that adjust styling, layout, or behavior. They return the same view instance, so you can chain as many as needed.

```haxe
new Text("Hello")
    .bold()
    .foregroundColor(Color.Named(NamedColor.Cyan))
    .padding(1)
    .border(Rounded)
```

## Text Styling

| Modifier | Description |
|----------|-------------|
| `.bold()` | Bold text |
| `.dim()` | Dimmed/faded text |
| `.italic()` | Italic text |
| `.underline()` | Underlined text |
| `.strikethrough()` | Strikethrough text |
| `.inverse()` | Swap foreground/background colors |

## Color

| Modifier | Parameters | Description |
|----------|-----------|-------------|
| `.foregroundColor(color)` | `Color` | Text color |
| `.backgroundColor(color)` | `Color` | Background color |

### Color Types

```haxe
Color.Default                           // terminal default
Color.Named(NamedColor.Red)             // 16 named colors
Color.Indexed(208)                      // 256-color palette
Color.Rgb(255, 128, 0)                  // 24-bit truecolor
```

### Named Colors

| Color | Bright variant |
|-------|---------------|
| `Black` | `BrightBlack` |
| `Red` | `BrightRed` |
| `Green` | `BrightGreen` |
| `Yellow` | `BrightYellow` |
| `Blue` | `BrightBlue` |
| `Magenta` | `BrightMagenta` |
| `Cyan` | `BrightCyan` |
| `White` | `BrightWhite` |

## Layout

| Modifier | Parameters | Description |
|----------|-----------|-------------|
| `.padding(all)` | `Int` | Equal padding on all sides |
| `.padding(null, top, right, bottom, left)` | `Int, Int, Int, Int` | Per-side padding |
| `.width(w)` | `Int` | Fixed width in columns |
| `.height(h)` | `Int` | Fixed height in rows |
| `.alignment(a)` | `Alignment` | Content alignment: `Left`, `Center`, `Right` |

### Padding Examples

```haxe
new Text("Hello").padding(1)                    // 1 cell on all sides
new Text("Hello").padding(null, 0, 2, 0, 2)    // 2 cells left and right
```

## Border

| Modifier | Parameters | Description |
|----------|-----------|-------------|
| `.border(style)` | `BorderStyle` | Draw a border around the view |

### Border Styles

| Style | Characters | Example |
|-------|-----------|---------|
| `Single` | `┌─┐│└─┘` | Standard box |
| `Double` | `╔═╗║╚═╝` | Double-line box |
| `Rounded` | `╭─╮│╰─╯` | Rounded corners |
| `Heavy` | `┏━┓┃┗━┛` | Thick lines |
| `Ascii` | `+-+\|+-+` | ASCII fallback |
| `None` | (nothing) | No border (default) |

```haxe
new Text("Rounded").border(Rounded)
new Text("Heavy").border(Heavy)
new Text("ASCII").border(Ascii)
```

## Visibility

| Modifier | Description |
|----------|-------------|
| `.hidden()` | Hide the view (takes no space) |

## Modifier Order

Modifiers are applied in order. Layout modifiers (padding, border) wrap from inside out:

```haxe
new Text("Hello")
    .padding(1)         // inner padding
    .border(Single)     // border around padded content
    .padding(1)         // outer padding around border
```

Produces:
```

   ┌─────────┐
   │         │
   │  Hello  │
   │         │
   └─────────┘

```
