# Views

Views are the building blocks of every cui app. You compose them into a tree by returning them from `body()`.

## All Views

| View | Category | Description |
|------|----------|-------------|
| [Text](text-and-labels.md#text) | Text | Styled text with word wrapping |
| [VStack](layout.md#vstack) | Layout | Vertical layout with spacing |
| [HStack](layout.md#hstack) | Layout | Horizontal layout with spacing |
| [Box](layout.md#box) | Layout | Container with optional border |
| [Spacer](layout.md#spacer) | Layout | Flexible space filler |
| [Divider](layout.md#divider) | Layout | Horizontal or vertical line |
| [ScrollView](layout.md#scrollview) | Layout | Scrollable content wrapper |
| [Button](controls.md#button) | Controls | Activatable element (Enter/Space/click) |
| [Input](controls.md#input) | Controls | Text input field with cursor |
| [Checkbox](controls.md#checkbox) | Controls | Toggle with label |
| [ListView](lists-and-data.md#listview) | Lists & Data | Scrollable list with selection |
| [Table](lists-and-data.md#table) | Lists & Data | Tabular data with auto-sized columns |
| [ProgressBar](lists-and-data.md#progressbar) | Lists & Data | Progress indicator with block characters |
| [ForEach](lists-and-data.md#foreach) | Lists & Data | Data-driven view repetition |
| [Tabs](navigation.md#tabs) | Navigation | Tab navigation with content switching |
| [ViewComponent](../components.md) | Custom | Base class for reusable components |

## Composing Views

Views are composed by nesting them:

```haxe
new VStack([
    new Text("Title").bold(),
    new HStack([
        new Button("OK", onOk),
        new Button("Cancel", onCancel),
    ], 1),
]).padding(1).border(Rounded)
```

Every view supports [modifiers](../modifiers.md) via method chaining. Modifiers return the same view instance, so you can chain as many as needed.

## Focusable Views

Some views are focusable — they can receive keyboard input when focused:

| View | Focus behavior |
|------|---------------|
| Button | Inverse highlight; Enter/Space activates |
| Input | Shows cursor; receives character input |
| Checkbox | Inverse highlight; Enter/Space toggles |
| ListView | Inverse highlight on selected item; Up/Down navigates |
| Tabs | Inverse highlight on active tab; Left/Right switches |
| ScrollView | Up/Down/PageUp/PageDown scrolls; mouse wheel |

Use **Tab** and **Shift-Tab** to cycle focus. **Click** any focusable view to focus it.
