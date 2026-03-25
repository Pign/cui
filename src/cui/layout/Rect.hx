package cui.layout;

class Rect {
    public var x:Int;
    public var y:Int;
    public var width:Int;
    public var height:Int;

    public function new(x:Int, y:Int, width:Int, height:Int) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    public function inner(edges:Edge):Rect {
        return new Rect(
            x + edges.left,
            y + edges.top,
            Std.int(Math.max(0, width - edges.left - edges.right)),
            Std.int(Math.max(0, height - edges.top - edges.bottom))
        );
    }

    public function contains(px:Int, py:Int):Bool {
        return px >= x && px < x + width && py >= y && py < y + height;
    }

    public function toSize():Size {
        return new Size(width, height);
    }

    public function toString():String {
        return '($x, $y, ${width}x${height})';
    }
}
