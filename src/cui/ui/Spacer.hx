package cui.ui;

import cui.View;
import cui.layout.Constraint;
import cui.layout.Rect;
import cui.layout.Size;
import cui.render.Buffer;

class Spacer extends View {
    public function new() {
        super();
    }

    override public function measure(constraint:Constraint):Size {
        // Spacer wants to fill all available space
        return switch (constraint) {
            case Exact(w, h): new Size(w, h);
            case AtMost(w, h): new Size(w, h);
            case Unbounded: new Size(0, 0);
        };
    }

    override public function render(buffer:Buffer, area:Rect):Void {
        // Spacer renders nothing — it just takes up space
    }
}
