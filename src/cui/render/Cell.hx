package cui.render;

class Cell {
    public var char:String;
    public var style:Style;

    public function new(?char:String, ?style:Style) {
        this.char = char != null ? char : " ";
        this.style = style != null ? style : new Style();
    }

    public function equals(other:Cell):Bool {
        if (other == null) return false;
        return char == other.char && style.equals(other.style);
    }

    public function copyFrom(other:Cell):Void {
        char = other.char;
        style = other.style;
    }
}
