package cui.ui;

import cui.View;
import cui.event.Event;
import cui.event.KeyEvent;
import cui.layout.Constraint;
import cui.layout.Rect;
import cui.layout.Size;
import cui.render.Buffer;
import cui.render.Style;
import cui.render.Color;
import cui.state.State;

class ListView extends View {
    var items:Array<String>;
    var selectedBinding:ListSelection;
    var scrollOffset:Int;
    var onSelect:Null<Int->Void>;
    var onDelete:Null<Int->Void>;

    public function new(items:Array<String>, selection:ListSelection, ?onSelect:Int->Void, ?onDelete:Int->Void) {
        super();
        this.items = items;
        this.selectedBinding = selection;
        this.scrollOffset = 0;
        this.onSelect = onSelect;
        this.onDelete = onDelete;
        this.focusable = true;
    }

    function getSelectedIndex():Int {
        return selectedBinding.get();
    }

    function setSelectedIndex(v:Int):Void {
        var clamped = v;
        if (clamped < 0) clamped = 0;
        if (clamped >= items.length) clamped = items.length - 1;
        if (clamped < 0) clamped = 0;
        selectedBinding.set(clamped);
    }

    override public function measure(constraint:Constraint):Size {
        var insets = getInsets();
        var fw = getFixedWidth();
        var fh = getFixedHeight();
        var maxW = switch (constraint) {
            case Exact(w, _): w;
            case AtMost(w, _): w;
            case Unbounded: 40;
        };
        var naturalH = items.length + insets.verticalTotal();
        var maxH = switch (constraint) {
            case Exact(_, h): h;
            case AtMost(_, h): Std.int(Math.min(naturalH, h));
            case Unbounded: naturalH;
        };
        return new Size(
            fw > 0 ? fw : maxW,
            fh > 0 ? fh : maxH
        );
    }

    override public function render(buffer:Buffer, area:Rect):Void {
        if (isHidden()) return;

        var style = getEffectiveStyle();
        var borderStyle = getBorderStyle();
        var insets = getInsets();

        if (borderStyle != cui.render.BorderStyle.None) {
            cui.layout.LayoutEngine.drawBorder(buffer, area, borderStyle, style);
        }

        var inner = area.inner(insets);
        var visibleCount = inner.height;
        var focused = isFocused();
        var selectedIndex = getSelectedIndex();

        // Adjust scroll offset to keep selection visible
        if (selectedIndex < scrollOffset) {
            scrollOffset = selectedIndex;
        }
        if (selectedIndex >= scrollOffset + visibleCount) {
            scrollOffset = selectedIndex - visibleCount + 1;
        }

        for (i in 0...visibleCount) {
            var itemIdx = scrollOffset + i;
            if (itemIdx >= items.length) break;

            var item = items[itemIdx];
            var isSelected = itemIdx == selectedIndex;

            var itemStyle = style.clone();
            if (isSelected && focused) {
                itemStyle.inverse = true;
            } else if (isSelected) {
                itemStyle.bold = true;
            }

            var prefix = isSelected ? "> " : "  ";
            var display = prefix + item;

            // Truncate to fit
            if (display.length > inner.width) {
                display = display.substr(0, inner.width - 1) + "\u2026";
            }

            buffer.writeString(inner.x, inner.y + i, display, itemStyle);

            // Fill rest of line
            var remaining = inner.width - display.length;
            for (j in 0...remaining) {
                buffer.set(inner.x + display.length + j, inner.y + i, " ", itemStyle);
            }
        }

        // Show scroll indicator if list is scrollable
        if (items.length > visibleCount && inner.width > 0) {
            var scrollbarHeight = Std.int(Math.max(1, visibleCount * visibleCount / items.length));
            var scrollbarPos = Std.int(scrollOffset * (visibleCount - scrollbarHeight) / Math.max(1, items.length - visibleCount));
            var scrollStyle = style.clone();
            scrollStyle.dim = true;
            for (y in 0...visibleCount) {
                var ch = (y >= scrollbarPos && y < scrollbarPos + scrollbarHeight) ? "\u2588" : "\u2591";
                buffer.set(inner.x + inner.width - 1, inner.y + y, ch, scrollStyle);
            }
        }
    }

    override public function handleEvent(event:Event):Bool {
        var selectedIndex = getSelectedIndex();
        switch (event) {
            case Key(key):
                switch (key.code) {
                    case Up:
                        if (selectedIndex > 0) {
                            setSelectedIndex(selectedIndex - 1);
                            return true;
                        }
                    case Down:
                        if (selectedIndex < items.length - 1) {
                            setSelectedIndex(selectedIndex + 1);
                            return true;
                        }
                    case Enter:
                        if (onSelect != null && items.length > 0) {
                            onSelect(selectedIndex);
                            return true;
                        }
                    case Delete:
                        if (onDelete != null && items.length > 0) {
                            onDelete(selectedIndex);
                            return true;
                        }
                    case Char(c):
                        if (c == "d" && onDelete != null && items.length > 0) {
                            onDelete(selectedIndex);
                            return true;
                        }
                    default:
                }
            default:
        }
        return false;
    }
}

class ListSelection {
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

    public static function fromState(state:IntState):ListSelection {
        return new ListSelection(
            () -> state.get(),
            (v) -> state.set(v)
        );
    }
}
