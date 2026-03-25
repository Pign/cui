package cui.layout;

class Edge {
    public var top:Int;
    public var right:Int;
    public var bottom:Int;
    public var left:Int;

    public function new(top:Int, right:Int, bottom:Int, left:Int) {
        this.top = top;
        this.right = right;
        this.bottom = bottom;
        this.left = left;
    }

    public static function all(value:Int):Edge {
        return new Edge(value, value, value, value);
    }

    public static function symmetric(vertical:Int, horizontal:Int):Edge {
        return new Edge(vertical, horizontal, vertical, horizontal);
    }

    public static function none():Edge {
        return new Edge(0, 0, 0, 0);
    }

    public function horizontalTotal():Int {
        return left + right;
    }

    public function verticalTotal():Int {
        return top + bottom;
    }

    public function toString():String {
        return 'Edge($top, $right, $bottom, $left)';
    }
}
