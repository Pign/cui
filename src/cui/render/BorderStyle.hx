package cui.render;

enum BorderStyle {
    None;
    Single;
    Double;
    Rounded;
    Heavy;
    Ascii;
}

class BorderChars {
    public var topLeft:String;
    public var topRight:String;
    public var bottomLeft:String;
    public var bottomRight:String;
    public var horizontal:String;
    public var vertical:String;

    public function new(tl:String, tr:String, bl:String, br:String, h:String, v:String) {
        topLeft = tl;
        topRight = tr;
        bottomLeft = bl;
        bottomRight = br;
        horizontal = h;
        vertical = v;
    }

    public static function fromStyle(style:BorderStyle):BorderChars {
        return switch (style) {
            case None: new BorderChars(" ", " ", " ", " ", " ", " ");
            case Single: new BorderChars("\u250C", "\u2510", "\u2514", "\u2518", "\u2500", "\u2502");
            case Double: new BorderChars("\u2554", "\u2557", "\u255A", "\u255D", "\u2550", "\u2551");
            case Rounded: new BorderChars("\u256D", "\u256E", "\u2570", "\u256F", "\u2500", "\u2502");
            case Heavy: new BorderChars("\u250F", "\u2513", "\u2517", "\u251B", "\u2501", "\u2503");
            case Ascii: new BorderChars("+", "+", "+", "+", "-", "|");
        };
    }
}
