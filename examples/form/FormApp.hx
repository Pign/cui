import cui.App;
import cui.View;
import cui.event.Event;
import cui.event.KeyEvent;
import cui.render.Color;
import cui.render.BorderStyle;
import cui.state.Binding;
import cui.state.State;
import cui.ui.Text;
import cui.ui.VStack;
import cui.ui.HStack;
import cui.ui.Spacer;
import cui.ui.Button;
import cui.ui.Input;

class FormApp extends App {
    @:state var name:String = "";
    @:state var email:String = "";
    @:state var submitted:Bool = false;

    override public function body():View {
        if (submitted.get()) {
            return new VStack([
                new Text("Form Submitted!")
                    .bold()
                    .foregroundColor(Color.Named(NamedColor.Green)),
                new Spacer(),
                new Text('Name:  ${name.get()}'),
                new Text('Email: ${email.get()}'),
                new Spacer(),
                new Button("Back", () -> submitted.set(false)),
            ], 1).padding(1).border(Rounded);
        }

        return new VStack([
            new Text("CUI Form Demo")
                .bold()
                .foregroundColor(Color.Named(NamedColor.Cyan)),
            new Text("Tab/Shift-Tab to navigate, Enter to submit")
                .dim(),
            new Spacer(),
            new HStack([
                new Text("Name:  ").foregroundColor(Color.Named(NamedColor.Yellow)),
                new Input(Binding.from(name), "Enter your name")
                    .border(Single),
            ], 0),
            new HStack([
                new Text("Email: ").foregroundColor(Color.Named(NamedColor.Yellow)),
                new Input(Binding.from(email), "Enter your email")
                    .border(Single),
            ], 0),
            new Spacer(),
            new HStack([
                new Spacer(),
                new Button("Submit", () -> submitted.set(true)),
                new Spacer(),
                new Button("Clear", () -> {
                    name.set("");
                    email.set("");
                }),
                new Spacer(),
            ], 1),
            new Text("Ctrl+C to quit").dim(),
        ], 1).padding(1).border(Rounded);
    }

    static function main() {
        var app = new FormApp();
        app.run();
    }
}
