package cui.focus;

import cui.View;
import cui.event.Event;
import cui.event.KeyEvent;

class FocusManager {
    public var focusIndex:Int;
    var focusableViews:Array<View>;

    public function new() {
        focusIndex = 0;
        focusableViews = [];
    }

    public function buildFocusRing(root:View):Void {
        focusableViews = [];
        collectFocusable(root);
        // Clamp focusIndex if views changed
        if (focusableViews.length > 0) {
            focusIndex = focusIndex % focusableViews.length;
        } else {
            focusIndex = 0;
        }
    }

    function collectFocusable(view:View):Void {
        if (view.focusable) {
            focusableViews.push(view);
        }
        for (child in view.children) {
            collectFocusable(child);
        }
    }

    public function focusNext():Void {
        if (focusableViews.length == 0) return;
        focusIndex = (focusIndex + 1) % focusableViews.length;
    }

    public function focusPrevious():Void {
        if (focusableViews.length == 0) return;
        focusIndex = (focusIndex - 1 + focusableViews.length) % focusableViews.length;
    }

    public function currentFocus():Null<View> {
        if (focusableViews.length == 0) return null;
        if (focusIndex < 0 || focusIndex >= focusableViews.length) return null;
        return focusableViews[focusIndex];
    }

    public function isFocused(view:View):Bool {
        return currentFocus() == view;
    }

    public function count():Int {
        return focusableViews.length;
    }

    public function handleNavigation(event:Event):Bool {
        switch (event) {
            case Key(key):
                switch (key.code) {
                    case Tab:
                        focusNext();
                        return true;
                    case BackTab:
                        focusPrevious();
                        return true;
                    default:
                }
            default:
        }
        return false;
    }

    public function dispatchToFocused(event:Event):Bool {
        var focused = currentFocus();
        if (focused == null) return false;
        return focused.handleEvent(event);
    }
}
