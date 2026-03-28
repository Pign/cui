package cui.render;

import cui.backend.Backend;

class Renderer {
    public static function render(prev:Buffer, curr:Buffer, backend:Backend):Void {
        var output = new StringBuf();
        var lastStyle:Style = null;

        for (y in 0...curr.height) {
            for (x in 0...curr.width) {
                var prevCell = prev.get(x, y);
                var currCell = curr.get(x, y);

                if (!currCell.equals(prevCell)) {
                    // Move cursor
                    output.add("\x1b[");
                    output.add(Std.string(y + 1));
                    output.add(";");
                    output.add(Std.string(x + 1));
                    output.add("H");

                    // Emit style if changed
                    if (lastStyle == null || !currCell.style.equals(lastStyle)) {
                        output.add(currCell.style.toAnsi());
                        lastStyle = currCell.style;
                    }

                    output.add(currCell.char);
                }
            }
        }

        // Reset style at end
        output.add("\x1b[0m");

        var str = output.toString();
        if (str.length > 4) { // more than just the reset
            backend.write(str);
            backend.flush();
        }
    }

    public static function renderFull(buffer:Buffer, backend:Backend):Void {
        var output = new StringBuf();
        var lastStyle:Style = null;

        for (y in 0...buffer.height) {
            // Position cursor at start of each row to avoid wrapping issues
            output.add("\x1b[");
            output.add(Std.string(y + 1));
            output.add(";1H");

            for (x in 0...buffer.width) {
                var cell = buffer.get(x, y);
                if (lastStyle == null || !cell.style.equals(lastStyle)) {
                    output.add(cell.style.toAnsi());
                    lastStyle = cell.style;
                }
                output.add(cell.char);
            }
        }

        output.add("\x1b[0m");
        backend.write(output.toString());
        backend.flush();
    }
}
