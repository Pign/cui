# Form

Demonstrates Input fields, Checkboxes, Buttons, focus navigation, and mouse support.

## Source

```haxe
class FormApp extends App {
    @:state var name:String = "";
    @:state var email:String = "";
    @:state var newsletter:Bool = true;
    @:state var terms:Bool = false;
    @:state var submitted:Bool = false;

    override public function body():View {
        if (submitted.get()) {
            return new VStack([
                new Text("Form Submitted!").bold().foregroundColor(Color.Named(NamedColor.Green)),
                new Spacer(),
                new Text('Name:       ${name.get()}'),
                new Text('Email:      ${email.get()}'),
                new Text('Newsletter: ${newsletter.get() ? "Yes" : "No"}'),
                new Text('Terms:      ${terms.get() ? "Accepted" : "Not accepted"}'),
                new Spacer(),
                new Button("Back", () -> submitted.set(false)),
            ], 1).padding(1).border(Rounded);
        }

        return new VStack([
            new Text("CUI Form Demo").bold().foregroundColor(Color.Named(NamedColor.Cyan)),
            new Text("Tab: navigate | Enter/Space: toggle | Click: focus").dim(),
            new Spacer(),
            new HStack([
                new Text("Name:  ").foregroundColor(Color.Named(NamedColor.Yellow)),
                new Input(Binding.from(name), "Enter your name").border(Single),
            ], 0),
            new HStack([
                new Text("Email: ").foregroundColor(Color.Named(NamedColor.Yellow)),
                new Input(Binding.from(email), "Enter your email").border(Single),
            ], 0),
            new Spacer(),
            new Checkbox("Subscribe to newsletter", CheckboxBinding.fromState(newsletter)),
            new Checkbox("I accept the terms", CheckboxBinding.fromState(terms)),
            new Spacer(),
            new HStack([
                new Spacer(),
                new Button("Submit", () -> submitted.set(true)),
                new Spacer(),
                new Button("Clear", () -> { name.set(""); email.set(""); }),
                new Spacer(),
            ], 1),
        ], 1).padding(1).border(Rounded);
    }
}
```

## Walkthrough

### Conditional Rendering

The `if (submitted.get())` branch shows a different view after submission. Since `body()` is called on every render, this is just a normal Haxe `if` statement.

### Input + Binding

```haxe
new Input(Binding.from(name), "Enter your name")
```

`Binding.from()` creates a two-way binding — the Input reads and writes to `name`. See [Binding](../state/binding.md).

### Checkbox + CheckboxBinding

```haxe
new Checkbox("Subscribe to newsletter", CheckboxBinding.fromState(newsletter))
```

### Focus Navigation

The form has 6 focusable views: 2 Inputs + 2 Checkboxes + 2 Buttons. Tab cycles through them in tree order. Click focuses any of them directly.

## Run It

```bash
haxe build-form.hxml
./bin-form/FormApp
```
