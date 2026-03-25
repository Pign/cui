package cui.ui;

import cui.View;
import cui.layout.Constraint;
import cui.layout.Rect;
import cui.layout.Size;
import cui.render.Buffer;

class VStack extends View {
    var spacing:Int;

    public function new(children:Array<View>, spacing:Int = 0) {
        super();
        this.children = children;
        this.spacing = spacing;
    }

    override public function measure(constraint:Constraint):Size {
        var insets = getInsets();
        var maxW = switch (constraint) {
            case Exact(w, _): w - insets.horizontalTotal();
            case AtMost(w, _): w - insets.horizontalTotal();
            case Unbounded: 1000;
        };
        var maxH = switch (constraint) {
            case Exact(_, h): h - insets.verticalTotal();
            case AtMost(_, h): h - insets.verticalTotal();
            case Unbounded: 1000;
        };

        var fw = getFixedWidth();
        if (fw > 0) maxW = fw - insets.horizontalTotal();
        var fh = getFixedHeight();
        if (fh > 0) maxH = fh - insets.verticalTotal();

        var totalH = 0;
        var widest = 0;
        var spacerCount = 0;
        var childSizes = new Array<Size>();

        // First pass: measure non-spacer children
        for (child in children) {
            if (Std.isOfType(child, Spacer)) {
                spacerCount++;
                childSizes.push(new Size(0, 0));
            } else {
                var cs = child.measure(Constraint.AtMost(maxW, maxH));
                childSizes.push(cs);
                totalH += cs.height;
                if (cs.width > widest) widest = cs.width;
            }
        }

        // Add spacing
        if (children.length > 1) totalH += spacing * (children.length - 1);

        // Distribute remaining space to spacers
        var remaining = maxH - totalH;
        if (remaining > 0 && spacerCount > 0) {
            totalH = maxH;
        } else if (remaining < 0) {
            totalH = maxH;
        }

        var w = fw > 0 ? fw : widest + insets.horizontalTotal();
        var h = fh > 0 ? fh : totalH + insets.verticalTotal();

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
        var innerConstraint = Constraint.AtMost(inner.width, inner.height);

        // Measure all children
        var childSizes = new Array<Size>();
        var totalFixed = 0;
        var spacerCount = 0;

        for (child in children) {
            if (Std.isOfType(child, Spacer)) {
                spacerCount++;
                childSizes.push(new Size(0, 0));
            } else {
                var cs = child.measure(innerConstraint);
                childSizes.push(cs);
                totalFixed += cs.height;
            }
        }

        if (children.length > 1) totalFixed += spacing * (children.length - 1);

        // Compute spacer height
        var spacerH = 0;
        var remaining = inner.height - totalFixed;
        if (remaining > 0 && spacerCount > 0) {
            spacerH = Std.int(remaining / spacerCount);
        }

        // Render children
        var yOffset = inner.y;
        for (i in 0...children.length) {
            if (yOffset >= inner.y + inner.height) break;

            var child = children[i];
            var cs = childSizes[i];
            var h = Std.isOfType(child, Spacer) ? spacerH : cs.height;

            if (yOffset + h > inner.y + inner.height) {
                h = inner.y + inner.height - yOffset;
            }
            if (h <= 0) { yOffset += spacing; continue; }

            var childArea = new Rect(inner.x, yOffset, inner.width, h);
            child.render(buffer, childArea);

            yOffset += h + spacing;
        }
    }
}
