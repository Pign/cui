package cui.state;

/**
    Base class for shared state models.

    Extend this class and declare @:state fields to create a reactive
    model that can be shared across multiple ViewComponents.

    Example:
    ```haxe
    class AppState extends Observable {
        @:state var count:Int = 0;
        @:state var username:String = "Guest";
    }
    ```

    Then use from any component:
    ```haxe
    var state = AppState.instance;
    new Text('Hello ${state.username.get()}');
    ```
**/
@:autoBuild(cui.macros.StateMacro.build())
class Observable {
    public function new() {}
}
