package cui.event;

import cui.layout.Size;

enum Event {
    Key(key:KeyEvent);
    Resize(size:Size);
    Tick;
}
