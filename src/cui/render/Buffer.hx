package cui.render;

import cui.layout.Rect;

class Buffer {
    public var width:Int;
    public var height:Int;
    var cells:Array<Cell>;

    public function new(width:Int, height:Int) {
        this.width = width;
        this.height = height;
        cells = new Array<Cell>();
        for (i in 0...width * height) {
            cells.push(new Cell());
        }
    }

    public function get(x:Int, y:Int):Cell {
        if (x < 0 || x >= width || y < 0 || y >= height) return new Cell();
        return cells[y * width + x];
    }

    public function set(x:Int, y:Int, char:String, style:Style):Void {
        if (x < 0 || x >= width || y < 0 || y >= height) return;
        var cell = cells[y * width + x];
        cell.char = char;
        cell.style = style;
    }

    public function fill(rect:Rect, char:String, style:Style):Void {
        for (dy in 0...rect.height) {
            for (dx in 0...rect.width) {
                set(rect.x + dx, rect.y + dy, char, style);
            }
        }
    }

    public function writeString(x:Int, y:Int, text:String, style:Style):Int {
        var written = 0;
        for (i in 0...text.length) {
            var px = x + i;
            if (px >= width) break;
            if (px >= 0 && y >= 0 && y < height) {
                set(px, y, text.charAt(i), style);
                written++;
            }
        }
        return written;
    }

    public function clear():Void {
        var empty = new Style();
        for (cell in cells) {
            cell.char = " ";
            cell.style = empty;
        }
    }

    public function resize(newWidth:Int, newHeight:Int):Void {
        var newCells = new Array<Cell>();
        for (i in 0...newWidth * newHeight) {
            newCells.push(new Cell());
        }
        var copyW = Std.int(Math.min(width, newWidth));
        var copyH = Std.int(Math.min(height, newHeight));
        for (y in 0...copyH) {
            for (x in 0...copyW) {
                newCells[y * newWidth + x].copyFrom(cells[y * width + x]);
            }
        }
        width = newWidth;
        height = newHeight;
        cells = newCells;
    }
}
