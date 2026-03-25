package cui.state;

class Binding<T> {
    var _get:Void->T;
    var _set:T->Void;

    public function new(getFn:Void->T, setFn:T->Void) {
        _get = getFn;
        _set = setFn;
    }

    public function get():T {
        return _get();
    }

    public function set(v:T):Void {
        _set(v);
    }

    public static function from<T>(state:State<T>):Binding<T> {
        return new Binding(
            () -> state.get(),
            (v) -> state.set(v)
        );
    }
}
