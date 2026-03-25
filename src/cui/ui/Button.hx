package cui.ui;

import cui.View;
import cui.event.Event;
import cui.event.KeyEvent;
import cui.layout.Constraint;
import cui.layout.Rect;
import cui.layout.Size;
import cui.render.Buffer;
import cui.render.Style;

class Button extends View {
    var label:String;
    var action:Void->Void;

    public function new(label:String, action:Void->Void) {
        super();
        this.label = label;
        this.action = action;
        this.focusable = true;
    }

    override public function measure(constraint:Constraint):Size {
        var insets = getInsets();
        // Button renders as: [ label ] with 1 cell padding on each side
        var contentW = label.length + 4; // "[ " + label + " ]"
        var fw = getFixedWidth();
        var fh = getFixedHeight();
        return new Size(
            fw > 0 ? fw : contentW + insets.horizontalTotal(),
            fh > 0 ? fh : 1 + insets.verticalTotal()
        );
    }

    override public function render(buffer:Buffer, area:Rect):Void {
        frame = area;
        if (isHidden()) return;

        var style = getEffectiveStyle();
        var borderStyle = getBorderStyle();
        var insets = getInsets();

        if (borderStyle != cui.render.BorderStyle.None) {
            cui.layout.LayoutEngine.drawBorder(buffer, area, borderStyle, style);
        }

        var inner = area.inner(insets);

        // Apply focus styling
        var renderStyle = style.clone();
        if (isFocused()) {
            renderStyle.inverse = true;
        }

        var display = "[ " + label + " ]";
        var align = getAlignment();
        var xOffset = switch (align) {
            case Left: 0;
            case Center: Std.int((inner.width - display.length) / 2);
            case Right: inner.width - display.length;
        };
        if (xOffset < 0) xOffset = 0;

        buffer.writeString(inner.x + xOffset, inner.y, display, renderStyle);
    }

    override public function handleEvent(event:Event):Bool {
        switch (event) {
            case Key(key):
                switch (key.code) {
                    case Enter:
                        action();
                        return true;
                    case Char(c):
                        if (c == " ") {
                            action();
                            return true;
                        }
                    default:
                }
            default:
        }
        return false;
    }
}
