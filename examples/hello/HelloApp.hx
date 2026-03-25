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
                        if (c == "q") {
                            quit();
                            return true;
                        }
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
