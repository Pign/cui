package cui.event;

import cui.layout.Size;

enum Event {
    Key(key:KeyEvent);
    Mouse(mouse:MouseEvent);
    Resize(size:Size);
    Tick;
}
