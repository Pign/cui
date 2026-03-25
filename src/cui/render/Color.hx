package cui.render;

enum NamedColor {
    Black;
    Red;
    Green;
    Yellow;
    Blue;
    Magenta;
    Cyan;
    White;
    BrightBlack;
    BrightRed;
    BrightGreen;
    BrightYellow;
    BrightBlue;
    BrightMagenta;
    BrightCyan;
    BrightWhite;
}

enum Color {
    Default;
    Named(c:NamedColor);
    Indexed(index:Int);
    Rgb(r:Int, g:Int, b:Int);
}
