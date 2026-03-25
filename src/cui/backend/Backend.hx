package cui.backend;

import cui.layout.Size;
import cui.event.Event;

interface Backend {
    function enterRawMode():Void;
    function leaveRawMode():Void;
    function enterAlternateScreen():Void;
    function leaveAlternateScreen():Void;
    function hideCursor():Void;
    function showCursor():Void;
    function moveCursor(x:Int, y:Int):Void;
    function write(data:String):Void;
    function flush():Void;
    function getSize():Size;
    function pollEvent(timeoutMs:Int):Null<Event>;
    function enableMouseCapture():Void;
    function disableMouseCapture():Void;
}
