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
import cui.ui.ListView;

class TodoApp extends App {
    @:state var inputText:String = "";
    @:state var selectedIdx:Int = 0;
    var todos:Array<String>;

    public function new() {
        super();
        todos = ["Buy groceries", "Write documentation", "Review pull request"];
    }

    override public function body():View {
        var selection = ListSelection.fromState(selectedIdx);

        return new VStack([
            new Text("CUI Todo App")
                .bold()
                .foregroundColor(Color.Named(NamedColor.Cyan)),
            new Text('${todos.length} items').dim(),
            new Spacer(),
            cast(new ListView(todos, selection, null, (idx) -> {
                if (idx >= 0 && idx < todos.length) {
                    todos.splice(idx, 1);
                    if (selectedIdx.get() >= todos.length && todos.length > 0) {
                        selectedIdx.set(todos.length - 1);
                    }
                    StateBase.markDirty();
                }
            }), View)
                .border(Single)
                .foregroundColor(Color.Named(NamedColor.White)),
            new Spacer(),
            new HStack([
                new Text("New: ").foregroundColor(Color.Named(NamedColor.Yellow)),
                new Input(Binding.from(inputText), "Enter a todo...")
                    .border(Single),
            ], 0),
            new HStack([
                new Spacer(),
                new Button("Add", () -> {
                    var text = inputText.get();
                    if (text.length > 0) {
                        todos.push(text);
                        inputText.set("");
                    }
                }),
                new Spacer(),
                new Button("Clear All", () -> {
                    todos.splice(0, todos.length);
                    selectedIdx.set(0);
                    StateBase.markDirty();
                }),
                new Spacer(),
            ], 1),
            new Text("Tab: navigate | \u2191\u2193: select | d: delete | Ctrl+C: quit")
                .dim(),
        ], 1).padding(1).border(Rounded);
    }

    static function main() {
        var app = new TodoApp();
        app.run();
    }
}
