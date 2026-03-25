package cui.layout;

class Size {
    public var width:Int;
    public var height:Int;

    public function new(width:Int, height:Int) {
        this.width = width;
        this.height = height;
    }

    public function equals(other:Size):Bool {
        return width == other.width && height == other.height;
    }

    public function toString():String {
        return '${width}x${height}';
    }
}
