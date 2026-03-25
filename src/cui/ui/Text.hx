package cui.ui;

import cui.View;
import cui.layout.Constraint;
import cui.layout.Rect;
import cui.layout.Size;
import cui.modifiers.ViewModifier;
import cui.render.Buffer;
import cui.render.Style;

class Text extends View {
    public var content:String;

    public function new(content:String) {
        super();
        this.content = content;
    }

    override public function measure(constraint:Constraint):Size {
        var insets = getInsets();
        var maxW = switch (constraint) {
            case Exact(w, _): w - insets.horizontalTotal();
            case AtMost(w, _): w - insets.horizontalTotal();
            case Unbounded: content.length;
        };

        var fw = getFixedWidth();
        if (fw > 0) maxW = fw - insets.horizontalTotal();

        if (maxW <= 0) maxW = content.length;

        var lines = wrapText(content, maxW);
        var textW = 0;
        for (line in lines) {
            if (line.length > textW) textW = line.length;
        }

        var fh = getFixedHeight();
        var h = fh > 0 ? fh : lines.length + insets.verticalTotal();
        var w = fw > 0 ? fw : textW + insets.horizontalTotal();

        return new Size(w, h);
    }

    override public function render(buffer:Buffer, area:Rect):Void {
        if (isHidden()) return;

        var style = getEffectiveStyle();
        var borderStyle = getBorderStyle();
        var insets = getInsets();

        // Draw border
        if (borderStyle != cui.render.BorderStyle.None) {
            cui.layout.LayoutEngine.drawBorder(buffer, area, borderStyle, style);
        }

        var inner = area.inner(insets);
        var lines = wrapText(content, inner.width);
        var align = getAlignment();

        for (i in 0...lines.length) {
            if (i >= inner.height) break;
            var line = lines[i];
            var xOffset = switch (align) {
                case Left: 0;
                case Center: Std.int((inner.width - line.length) / 2);
                case Right: inner.width - line.length;
            };
            if (xOffset < 0) xOffset = 0;
            buffer.writeString(inner.x + xOffset, inner.y + i, line, style);
        }
    }

    static function wrapText(text:String, maxWidth:Int):Array<String> {
        if (maxWidth <= 0) return [text];

        var lines = new Array<String>();
        var remaining = text;

        while (remaining.length > 0) {
            if (remaining.length <= maxWidth) {
                lines.push(remaining);
                break;
            }

            // Find last space within maxWidth
            var breakAt = maxWidth;
            var lastSpace = -1;
            for (j in 0...maxWidth) {
                if (remaining.charAt(j) == " ") lastSpace = j;
            }
            if (lastSpace > 0) breakAt = lastSpace;

            lines.push(remaining.substr(0, breakAt));
            remaining = remaining.substr(breakAt);
            // Skip leading space after break
            if (remaining.length > 0 && remaining.charAt(0) == " ") {
                remaining = remaining.substr(1);
            }
        }

        if (lines.length == 0) lines.push("");
        return lines;
    }
}
