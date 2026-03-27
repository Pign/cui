# Hello World

The simplest cui app — demonstrates layout, text styling, and borders.

## Source

```haxe
import cui.App;
import cui.View;
import cui.event.Event;
import cui.event.KeyEvent;
import cui.render.Color;
import cui.render.BorderStyle;
import cui.ui.Text;
import cui.ui.VStack;
import cui.ui.HStack;
import cui.ui.Spacer;
import cui.ui.Divider;

class HelloApp extends App {
    override public function body():View {
        return new VStack([
            new Text("Welcome to CUI!")
                .bold()
                .foregroundColor(Color.Named(NamedColor.Cyan)),
            new Spacer(),
            new HStack([
                new Spacer(),
                new Text("Left panel")
                    .foregroundColor(Color.Named(NamedColor.Green)),
                new Spacer(),
                new Divider(false),
                new Spacer(),
                new Text("Right panel")
                    .foregroundColor(Color.Named(NamedColor.Yellow)),
                new Spacer(),
            ], 0),
            new Spacer(),
            new Text("Press 'q' to quit")
                .dim(),
        ], 0).padding(1).border(Rounded);
    }

    override public function handleEvent(event:Event):Bool {
        switch (event) {
            case Key(key):
                switch (key.code) {
                    case Char(c):
                        if (c == "q") { quit(); return true; }
                    default:
                }
            default:
        }
        return false;
    }

    static function main() {
        var app = new HelloApp();
        app.run();
    }
}
```

## Walkthrough

### App Structure

The app extends `App` and overrides two methods:
- `body()` — returns the view tree
- `handleEvent()` — handles the 'q' key to quit

### Layout

- `VStack` arranges children vertically
- `HStack` with `Spacer`s centers the two text panels horizontally
- `Divider(false)` draws a vertical separator between panels
- `.padding(1).border(Rounded)` wraps everything in a rounded box with padding

### Styling

- `.bold()` — bold text
- `.foregroundColor(Color.Named(...))` — colored text
- `.dim()` — subtle hint text

## Run It

```bash
haxe build.hxml
./bin/HelloApp
```
