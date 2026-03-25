package cui;

import cui.event.Event;
import cui.event.EventLoop;
import cui.event.KeyEvent;

@:autoBuild(cui.macros.StateMacro.build())
class App {
    var eventLoop:EventLoop;

    public function new() {
        eventLoop = new EventLoop();
    }

    public function body():View {
        return new View();
    }

    public function handleEvent(event:Event):Bool {
        return false;
    }

    public function run():Void {
        eventLoop.run(
            () -> body(),
            (event) -> handleEvent(event)
        );
    }

    public function quit():Void {
        eventLoop.quit();
    }
}
