package cui.event;

enum MouseButton {
    Left;
    Middle;
    Right;
    ScrollUp;
    ScrollDown;
    None;
}

enum MouseAction {
    Press;
    Release;
    Move;
}

class MouseEvent {
    public var x:Int; // 0-based column
    public var y:Int; // 0-based row
    public var button:MouseButton;
    public var action:MouseAction;

    public function new(x:Int, y:Int, button:MouseButton, action:MouseAction) {
        this.x = x;
        this.y = y;
        this.button = button;
        this.action = action;
    }

    public function toString():String {
        return 'Mouse($action $button at $x,$y)';
    }
}
