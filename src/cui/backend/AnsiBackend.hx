package cui.backend;

import cui.layout.Size;
import cui.event.Event;
import cui.event.KeyEvent;
import cui.backend.native.PosixTerminal;

class AnsiBackend implements Backend {
    var outputBuf:StringBuf;

    public function new() {
        outputBuf = new StringBuf();
    }

    public function enterRawMode():Void {
        PosixTerminal.enableRawMode();
    }

    public function leaveRawMode():Void {
        PosixTerminal.disableRawMode();
    }

    public function enterAlternateScreen():Void {
        PosixTerminal.writeStdout("\x1b[?1049h");
    }

    public function leaveAlternateScreen():Void {
        PosixTerminal.writeStdout("\x1b[?1049l");
    }

    public function hideCursor():Void {
        PosixTerminal.writeStdout("\x1b[?25l");
    }

    public function showCursor():Void {
        PosixTerminal.writeStdout("\x1b[?25h");
    }

    public function moveCursor(x:Int, y:Int):Void {
        PosixTerminal.writeStdout("\x1b[" + (y + 1) + ";" + (x + 1) + "H");
    }

    public function write(data:String):Void {
        PosixTerminal.writeStdout(data);
    }

    public function flush():Void {
        PosixTerminal.flushStdout();
    }

    public function getSize():Size {
        return PosixTerminal.getTermSize();
    }

    public function pollEvent(timeoutMs:Int):Null<Event> {
        var byte = PosixTerminal.readByte(timeoutMs);
        if (byte < 0) return null;
        return parseInput(byte);
    }

    function parseInput(byte:Int):Null<Event> {
        if (byte == 27) {
            return parseEscape();
        }

        // Ctrl+letter (1-26)
        if (byte >= 1 && byte <= 26) {
            var ch = String.fromCharCode(byte + 96); // a=1, b=2, etc.
            return Event.Key(new KeyEvent(KeyCode.Char(ch), true));
        }

        // Enter
        if (byte == 13 || byte == 10) {
            return Event.Key(new KeyEvent(KeyCode.Enter));
        }

        // Tab
        if (byte == 9) {
            return Event.Key(new KeyEvent(KeyCode.Tab));
        }

        // Backspace
        if (byte == 127) {
            return Event.Key(new KeyEvent(KeyCode.Backspace));
        }

        // Regular character
        if (byte >= 32 && byte < 127) {
            return Event.Key(new KeyEvent(KeyCode.Char(String.fromCharCode(byte))));
        }

        // UTF-8 multi-byte
        if (byte >= 128) {
            return parseUtf8(byte);
        }

        return null;
    }

    function parseEscape():Null<Event> {
        var b2 = PosixTerminal.readByteImmediate();
        if (b2 < 0) {
            return Event.Key(new KeyEvent(KeyCode.Escape));
        }

        if (b2 == 91) { // [
            return parseCsi();
        }

        if (b2 == 79) { // O — SS3 sequences (F1-F4)
            var b3 = PosixTerminal.readByteImmediate();
            return switch (b3) {
                case 80: Event.Key(new KeyEvent(KeyCode.F(1)));
                case 81: Event.Key(new KeyEvent(KeyCode.F(2)));
                case 82: Event.Key(new KeyEvent(KeyCode.F(3)));
                case 83: Event.Key(new KeyEvent(KeyCode.F(4)));
                default: Event.Key(new KeyEvent(KeyCode.Escape));
            };
        }

        // Alt+key
        if (b2 >= 32 && b2 < 127) {
            return Event.Key(new KeyEvent(KeyCode.Char(String.fromCharCode(b2)), false, true));
        }

        return Event.Key(new KeyEvent(KeyCode.Escape));
    }

    function parseCsi():Null<Event> {
        var b3 = PosixTerminal.readByteImmediate();
        if (b3 < 0) return Event.Key(new KeyEvent(KeyCode.Escape));

        // Arrow keys and simple sequences
        return switch (b3) {
            case 65: Event.Key(new KeyEvent(KeyCode.Up));
            case 66: Event.Key(new KeyEvent(KeyCode.Down));
            case 67: Event.Key(new KeyEvent(KeyCode.Right));
            case 68: Event.Key(new KeyEvent(KeyCode.Left));
            case 72: Event.Key(new KeyEvent(KeyCode.Home));
            case 70: Event.Key(new KeyEvent(KeyCode.End));
            case 90: Event.Key(new KeyEvent(KeyCode.BackTab, false, false, true)); // Shift+Tab
            default:
                // Extended sequences like \x1b[1~ (Home), \x1b[3~ (Delete), etc.
                if (b3 >= 48 && b3 <= 57) {
                    parseExtendedCsi(b3);
                } else {
                    Event.Key(new KeyEvent(KeyCode.Escape));
                }
        };
    }

    function parseExtendedCsi(firstDigit:Int):Null<Event> {
        var num = firstDigit - 48;
        while (true) {
            var b = PosixTerminal.readByteImmediate();
            if (b < 0) break;
            if (b >= 48 && b <= 57) {
                num = num * 10 + (b - 48);
            } else if (b == 126) { // ~
                return switch (num) {
                    case 1: Event.Key(new KeyEvent(KeyCode.Home));
                    case 2: Event.Key(new KeyEvent(KeyCode.Insert));
                    case 3: Event.Key(new KeyEvent(KeyCode.Delete));
                    case 4: Event.Key(new KeyEvent(KeyCode.End));
                    case 5: Event.Key(new KeyEvent(KeyCode.PageUp));
                    case 6: Event.Key(new KeyEvent(KeyCode.PageDown));
                    case 15: Event.Key(new KeyEvent(KeyCode.F(5)));
                    case 17: Event.Key(new KeyEvent(KeyCode.F(6)));
                    case 18: Event.Key(new KeyEvent(KeyCode.F(7)));
                    case 19: Event.Key(new KeyEvent(KeyCode.F(8)));
                    case 20: Event.Key(new KeyEvent(KeyCode.F(9)));
                    case 21: Event.Key(new KeyEvent(KeyCode.F(10)));
                    case 23: Event.Key(new KeyEvent(KeyCode.F(11)));
                    case 24: Event.Key(new KeyEvent(KeyCode.F(12)));
                    default: null;
                };
            } else {
                break;
            }
        }
        return null;
    }

    function parseUtf8(firstByte:Int):Null<Event> {
        var bytes = [firstByte];
        var remaining = 0;
        if ((firstByte & 0xE0) == 0xC0) remaining = 1;
        else if ((firstByte & 0xF0) == 0xE0) remaining = 2;
        else if ((firstByte & 0xF8) == 0xF0) remaining = 3;

        for (i in 0...remaining) {
            var b = PosixTerminal.readByteImmediate();
            if (b < 0) return null;
            bytes.push(b);
        }

        // Decode UTF-8 to codepoint
        var cp = 0;
        if (remaining == 1) {
            cp = ((bytes[0] & 0x1F) << 6) | (bytes[1] & 0x3F);
        } else if (remaining == 2) {
            cp = ((bytes[0] & 0x0F) << 12) | ((bytes[1] & 0x3F) << 6) | (bytes[2] & 0x3F);
        } else if (remaining == 3) {
            cp = ((bytes[0] & 0x07) << 18) | ((bytes[1] & 0x3F) << 12) | ((bytes[2] & 0x3F) << 6) | (bytes[3] & 0x3F);
        }

        var char = String.fromCharCode(cp);
        return Event.Key(new KeyEvent(KeyCode.Char(char)));
    }
}
