# ScrollView Example

Demonstrates ScrollView with long content that exceeds terminal height.

## Source

```haxe
class ScrollApp extends App {
    override public function body():View {
        var lines = new Array<View>();

        // Build long content with multiple sections
        var topics = [
            { title: "Getting Started", color: NamedColor.Cyan, lines: [...] },
            { title: "Views",           color: NamedColor.Green, lines: [...] },
            { title: "Modifiers",       color: NamedColor.Yellow, lines: [...] },
            { title: "State",           color: NamedColor.Magenta, lines: [...] },
        ];

        for (topic in topics) {
            lines.push(new Text(topic.title).bold().foregroundColor(Color.Named(topic.color)));
            lines.push(new Text(""));
            for (line in topic.lines)
                lines.push(new Text("  " + line));
            lines.push(new Text(""));
        }

        return new VStack([
            new HStack([
                new Text(" CUI Documentation ").bold().foregroundColor(Color.Named(NamedColor.Cyan)),
                new Spacer(),
                new Text("Up/Down/scroll: navigate | Ctrl+C: quit ").dim(),
            ], 0),
            cast(new ScrollView(new VStack(lines, 0)), View).border(Single),
        ], 0).padding(1).border(Rounded);
    }
}
```

## Walkthrough

### ScrollView

Wraps a VStack of content that's taller than the terminal. The ScrollView:
- Renders content into an internal buffer at full height
- Copies only the visible portion to the screen buffer
- Draws a scrollbar on the right edge

### Navigation

- **Up/Down arrows**: scroll one line at a time
- **PageUp/PageDown**: scroll 10 lines
- **Mouse scroll wheel**: scroll 3 lines

### Scrollbar

The right edge shows scroll position:
- `█` (full block) marks the visible window
- `░` (light shade) marks content above/below

## Run It

```bash
haxe build-scroll.hxml
./bin-scroll/ScrollApp
```
