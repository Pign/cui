package cui.ui;

import cui.View;
import cui.event.Event;
import cui.event.KeyEvent;
import cui.event.MouseEvent;
import cui.layout.Constraint;
import cui.layout.Rect;
import cui.layout.Size;
import cui.render.Buffer;
import cui.render.Style;
import cui.state.State;

class ScrollOffset {
    var _get:Void->Int;
    var _set:Int->Void;

    public function new(getFn:Void->Int, setFn:Int->Void) {
        _get = getFn;
        _set = setFn;
    }

    public function get():Int {
        return _get();
    }

    public function set(v:Int):Void {
        _set(v);
    }

    public static function fromState(state:IntState):ScrollOffset {
        return new ScrollOffset(
            () -> state.get(),
            (v) -> state.set(v)
        );
    }
}

class ScrollView extends View {
    var child:View;
    var offsetBinding:ScrollOffset;
    var contentHeight:Int;
    var visibleHeight:Int;

    public function new(child:View, offset:ScrollOffset) {
        super();
        this.child = child;
        this.children = [child];
        this.offsetBinding = offset;
        this.contentHeight = 0;
        this.visibleHeight = 0;
        this.focusable = true;
    }

    function getOffset():Int {
        return offsetBinding.get();
    }

    function setOffset(v:Int):Void {
        var maxScroll = contentHeight - visibleHeight;
        if (maxScroll < 0) maxScroll = 0;
        if (v > maxScroll) v = maxScroll;
        if (v < 0) v = 0;
        offsetBinding.set(v);
    }

    override public function measure(constraint:Constraint):Size {
        var insets = getInsets();
        var maxW = switch (constraint) {
            case Exact(w, _): w;
            case AtMost(w, _): w;
            case Unbounded: 60;
        };
        var maxH = switch (constraint) {
            case Exact(_, h): h;
            case AtMost(_, h): h;
            case Unbounded: 20;
        };
        var fw = getFixedWidth();
        var fh = getFixedHeight();
        return new Size(
            fw > 0 ? fw : maxW,
            fh > 0 ? fh : maxH
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
        visibleHeight = inner.height;

        // Measure child at full height to know content size
        var childSize = child.measure(Constraint.AtMost(inner.width - 1, 10000));
        contentHeight = childSize.height;

        // Clamp scroll offset
        var scrollOffset = getOffset();
        var maxScroll = contentHeight - inner.height;
        if (maxScroll < 0) maxScroll = 0;
        if (scrollOffset > maxScroll) scrollOffset = maxScroll;
        if (scrollOffset < 0) scrollOffset = 0;

        // Render child into a temporary buffer, then copy the visible portion
        var childBuffer = new Buffer(inner.width - 1, contentHeight);
        child.render(childBuffer, new Rect(0, 0, inner.width - 1, contentHeight));

        // Copy visible region
        for (y in 0...inner.height) {
            var srcY = y + scrollOffset;
            if (srcY >= contentHeight) break;
            for (x in 0...(inner.width - 1)) {
                var cell = childBuffer.get(x, srcY);
                buffer.set(inner.x + x, inner.y + y, cell.char, cell.style);
            }
        }

        // Draw scrollbar
        if (contentHeight > inner.height) {
            var barHeight = Std.int(Math.max(1, inner.height * inner.height / contentHeight));
            var barPos = Std.int(scrollOffset * (inner.height - barHeight) / Math.max(1, maxScroll));
            var scrollStyle = style.clone();
            scrollStyle.dim = true;
            var scrollX = inner.x + inner.width - 1;
            for (y in 0...inner.height) {
                var ch = (y >= barPos && y < barPos + barHeight) ? "\u2588" : "\u2591";
                buffer.set(scrollX, inner.y + y, ch, scrollStyle);
            }
        }
    }

    override public function handleEvent(event:Event):Bool {
        var prev = getOffset();

        switch (event) {
            case Key(key):
                switch (key.code) {
                    case Up:    setOffset(prev - 1);
                    case Down:  setOffset(prev + 1);
                    case PageUp:  setOffset(prev - visibleHeight);
                    case PageDown: setOffset(prev + visibleHeight);
                    default: return false;
                }
                return getOffset() != prev;
            case Mouse(mouse):
                if (mouse.button == ScrollUp) {
                    setOffset(prev - 3);
                    return getOffset() != prev;
                } else if (mouse.button == ScrollDown) {
                    setOffset(prev + 3);
                    return getOffset() != prev;
                }
            default:
        }
        return false;
    }
}
