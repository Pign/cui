package cui.ui;

import cui.View;
import cui.layout.Constraint;
import cui.layout.Rect;
import cui.layout.Size;
import cui.render.Buffer;
import cui.render.Style;

class Table extends View {
    var headers:Array<String>;
    var rows:Array<Array<String>>;

    public function new(headers:Array<String>, rows:Array<Array<String>>) {
        super();
        this.headers = headers;
        this.rows = rows;
    }

    override public function measure(constraint:Constraint):Size {
        var insets = getInsets();
        var colWidths = computeColumnWidths();
        var totalW = 1; // left border
        for (w in colWidths) {
            totalW += w + 3; // " content " + separator
        }

        var totalH = 3 + rows.length; // top border + header + separator + rows + bottom border
        var fw = getFixedWidth();
        var fh = getFixedHeight();
        return new Size(
            fw > 0 ? fw : totalW + insets.horizontalTotal(),
            fh > 0 ? fh : totalH + insets.verticalTotal()
        );
    }

    override public function render(buffer:Buffer, area:Rect):Void {
        if (isHidden()) return;

        var style = getEffectiveStyle();
        var insets = getInsets();
        var borderStyle = getBorderStyle();

        if (borderStyle != cui.render.BorderStyle.None) {
            cui.layout.LayoutEngine.drawBorder(buffer, area, borderStyle, style);
        }

        var inner = area.inner(insets);
        var colWidths = computeColumnWidths();
        var y = inner.y;

        // Header row
        if (y < inner.y + inner.height) {
            renderRow(buffer, inner.x, y, inner.width, headers, colWidths, style, true);
            y++;
        }

        // Separator line
        if (y < inner.y + inner.height) {
            var sep = "";
            for (i in 0...colWidths.length) {
                if (i > 0) sep += "\u253C";
                var w = colWidths[i] + 2;
                for (j in 0...w) sep += "\u2500";
            }
            buffer.writeString(inner.x, y, sep.substr(0, inner.width), style);
            y++;
        }

        // Data rows
        for (row in rows) {
            if (y >= inner.y + inner.height) break;
            renderRow(buffer, inner.x, y, inner.width, row, colWidths, style, false);
            y++;
        }
    }

    function renderRow(buffer:Buffer, x:Int, y:Int, maxW:Int, cells:Array<String>,
            colWidths:Array<Int>, style:Style, isHeader:Bool):Void {
        var renderStyle = isHeader ? headerStyle(style) : style;
        var cx = x;

        for (i in 0...colWidths.length) {
            if (cx >= x + maxW) break;

            if (i > 0) {
                buffer.set(cx, y, "\u2502", style);
                cx++;
            }

            var cell = i < cells.length ? cells[i] : "";
            var w = colWidths[i];

            buffer.set(cx, y, " ", renderStyle);
            cx++;

            var display = cell.length > w ? cell.substr(0, w) : cell;
            buffer.writeString(cx, y, display, renderStyle);
            cx += display.length;

            // Pad remaining
            var pad = w - display.length + 1;
            for (j in 0...pad) {
                if (cx < x + maxW) {
                    buffer.set(cx, y, " ", renderStyle);
                    cx++;
                }
            }
        }
    }

    function headerStyle(base:Style):Style {
        var s = base.clone();
        s.bold = true;
        return s;
    }

    function computeColumnWidths():Array<Int> {
        var widths = new Array<Int>();
        for (i in 0...headers.length) {
            widths.push(headers[i].length);
        }
        for (row in rows) {
            for (i in 0...row.length) {
                if (i < widths.length) {
                    if (row[i].length > widths[i]) {
                        widths[i] = row[i].length;
                    }
                }
            }
        }
        return widths;
    }
}
