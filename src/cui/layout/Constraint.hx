package cui.layout;

enum Constraint {
    Exact(width:Int, height:Int);
    AtMost(maxWidth:Int, maxHeight:Int);
    Unbounded;
}
