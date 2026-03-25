package cui.event;

enum KeyCode {
    Char(c:String);
    Enter;
    Escape;
    Backspace;
    Tab;
    BackTab;
    Up;
    Down;
    Left;
    Right;
    Home;
    End;
    PageUp;
    PageDown;
    Insert;
    Delete;
    F(n:Int);
}

class KeyEvent {
    public var code:KeyCode;
    public var ctrl:Bool;
    public var alt:Bool;
    public var shift:Bool;

    public function new(code:KeyCode, ctrl:Bool = false, alt:Bool = false, shift:Bool = false) {
        this.code = code;
        this.ctrl = ctrl;
        this.alt = alt;
        this.shift = shift;
    }

    public function toString():String {
        var mods = "";
        if (ctrl) mods += "Ctrl+";
        if (alt) mods += "Alt+";
        if (shift) mods += "Shift+";
        return mods + Std.string(code);
    }
}
