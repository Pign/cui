package cui.layout;

import cui.View;
import cui.render.BorderStyle;
import cui.render.Buffer;
import cui.render.Style;

class LayoutEngine {
    public static function layout(view:View, area:Rect):Void {
        view.frame = area;
        view.render(new Buffer(0, 0), area); // trigger layout logic inside render
    }

    public static function renderView(view:View, buffer:Buffer, area:Rect):Void {
        if (view.isHidden()) return;

        var insets = view.getInsets();
        var borderStyle = view.getBorderStyle();

        // Draw border if present
        if (borderStyle != BorderStyle.None) {
            drawBorder(buffer, area, borderStyle, view.getEffectiveStyle());
        }

        // Fill background if set
        var style = view.getEffectiveStyle();
        switch (style.bg) {
            case Default:
            default:
                var inner = area.inner(insets);
                buffer.fill(inner, " ", style);
        }
    }

    public static function drawBorder(buffer:Buffer, area:Rect, borderStyle:BorderStyle, style:Style):Void {
        var chars = BorderChars.fromStyle(borderStyle);
        if (area.width < 2 || area.height < 2) return;

        var x1 = area.x;
        var y1 = area.y;
        var x2 = area.x + area.width - 1;
        var y2 = area.y + area.height - 1;

        // Corners
        buffer.set(x1, y1, chars.topLeft, style);
        buffer.set(x2, y1, chars.topRight, style);
        buffer.set(x1, y2, chars.bottomLeft, style);
        buffer.set(x2, y2, chars.bottomRight, style);

        // Horizontal edges
        for (x in (x1 + 1)...x2) {
            buffer.set(x, y1, chars.horizontal, style);
            buffer.set(x, y2, chars.horizontal, style);
        }

        // Vertical edges
        for (y in (y1 + 1)...y2) {
            buffer.set(x1, y, chars.vertical, style);
            buffer.set(x2, y, chars.vertical, style);
        }
    }
}
