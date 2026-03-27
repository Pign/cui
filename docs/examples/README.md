# Examples

cui includes 7 example apps, ordered by complexity.

| Example | Level | Features demonstrated |
|---------|-------|---------------------|
| [Hello World](hello-world.md) | Beginner | Layout, text styling, borders |
| [Counter](counter.md) | Beginner | `@:state`, reactive re-rendering |
| [Form](form.md) | Intermediate | Input, Checkbox, focus, mouse |
| [Todo App](todo-app.md) | Intermediate | ListView, Binding, add/delete |
| [Dashboard](dashboard.md) | Advanced | Tabs, Table, ProgressBar |
| [ScrollView](scroll.md) | Intermediate | ScrollView, long content |
| [Shared State](shared-state.md) | Advanced | Observable, ViewComponent |

## Running Examples

Each example has its own build file:

```bash
haxe build.hxml              && ./bin/HelloApp
haxe build-counter.hxml      && ./bin-counter/CounterApp
haxe build-form.hxml         && ./bin-form/FormApp
haxe build-todo.hxml         && ./bin-todo/TodoApp
haxe build-dashboard.hxml    && ./bin-dashboard/DashboardApp
haxe build-scroll.hxml       && ./bin-scroll/ScrollApp
haxe build-shared-state.hxml && ./bin-shared-state/SharedStateApp
```
