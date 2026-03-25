package cui.ui;

import cui.View;
import cui.event.Event;
import cui.event.KeyEvent;
import cui.layout.Constraint;
import cui.layout.Rect;
import cui.layout.Size;
import cui.render.Buffer;
import cui.render.Style;
import cui.state.Binding;

class Input extends View {
    var binding:Binding<String>;
    var placeholder:String;
    var cursorPos:Int;

    public function new(binding:Binding<String>, placeholder:String = "") {
        super();
        this.binding = binding;
        this.placeholder = placeholder;
        this.cursorPos = binding.get().length;
        this.focusable = true;
    }

    override public function measure(constraint:Constraint):Size {
        var insets = getInsets();
        var fw = getFixedWidth();
        var maxW = switch (constraint) {
            case Exact(w, _): w;
            case AtMost(w, _): w;
            case Unbounded: 30;
        };
        var fh = getFixedHeight();
        return new Size(
            fw > 0 ? fw : maxW,
            fh > 0 ? fh : 1 + insets.verticalTotal()
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
        var text = binding.get();
        var focused = isFocused();

        if (text.length == 0 && !focused) {
            // Show placeholder
            var phStyle = style.clone();
            phStyle.dim = true;
            buffer.writeString(inner.x, inner.y, placeholder.substr(0, inner.width), phStyle);
        } else {
            // Show text content
            var displayText = text;
            // Scroll if text is longer than field width
            var scrollOffset = 0;
            if (cursorPos >= inner.width) {
                scrollOffset = cursorPos - inner.width + 1;
            }
            displayText = displayText.substr(scrollOffset, inner.width);
            buffer.writeString(inner.x, inner.y, displayText, style);

            // Fill remaining with spaces
            var remaining = inner.width - displayText.length;
            for (i in 0...remaining) {
                buffer.set(inner.x + displayText.length + i, inner.y, " ", style);
            }

            // Draw cursor
            if (focused) {
                var cursorX = inner.x + cursorPos - scrollOffset;
                if (cursorX >= inner.x && cursorX < inner.x + inner.width) {
                    var cursorStyle = style.clone();
                    cursorStyle.inverse = true;
                    var charAtCursor = cursorPos < text.length ? text.charAt(cursorPos) : " ";
                    buffer.set(cursorX, inner.y, charAtCursor, cursorStyle);
                }
            }
        }

        // Underline the whole field when focused
        if (focused) {
            var ulStyle = style.clone();
            ulStyle.underline = true;
            // Just mark the borders of the field area
        }
    }

    override public function handleEvent(event:Event):Bool {
        switch (event) {
            case Key(key):
                var text = binding.get();
                switch (key.code) {
                    case Char(c):
                        if (!key.ctrl && !key.alt) {
                            // Insert character at cursor position
                            var newText = text.substr(0, cursorPos) + c + text.substr(cursorPos);
                            binding.set(newText);
                            cursorPos++;
                            return true;
                        }
                    case Backspace:
                        if (cursorPos > 0) {
                            var newText = text.substr(0, cursorPos - 1) + text.substr(cursorPos);
                            binding.set(newText);
                            cursorPos--;
                            return true;
                        }
                    case Delete:
                        if (cursorPos < text.length) {
                            var newText = text.substr(0, cursorPos) + text.substr(cursorPos + 1);
                            binding.set(newText);
                            return true;
                        }
                    case Left:
                        if (cursorPos > 0) {
                            cursorPos--;
                            cui.state.State.StateBase.markDirty();
                            return true;
                        }
                    case Right:
                        if (cursorPos < text.length) {
                            cursorPos++;
                            cui.state.State.StateBase.markDirty();
                            return true;
                        }
                    case Home:
                        cursorPos = 0;
                        cui.state.State.StateBase.markDirty();
                        return true;
                    case End:
                        cursorPos = text.length;
                        cui.state.State.StateBase.markDirty();
                        return true;
                    default:
                }
            default:
        }
        return false;
    }
}
