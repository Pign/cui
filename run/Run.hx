import sys.FileSystem;
import sys.io.File;

class Run {
    static function main() {
        var args = Sys.args();
        // haxelib passes the CWD as the last argument
        var cwd = args.length > 0 ? args[args.length - 1] : Sys.getCwd();

        // Remove CWD from args
        if (args.length > 0) args.pop();

        if (args.length == 0) {
            printUsage();
            return;
        }

        switch (args[0]) {
            case "init":
                var appName = args.length > 1 ? args[1] : "MyApp";
                initProject(cwd, appName);
            case "help":
                printUsage();
            default:
                Sys.println('Unknown command: ${args[0]}');
                printUsage();
        }
    }

    static function printUsage():Void {
        Sys.println("cui - Declarative TUI Framework for Haxe");
        Sys.println("");
        Sys.println("Usage:");
        Sys.println("  haxelib run cui init [AppName]  Create a new cui project");
        Sys.println("  haxelib run cui help             Show this help");
    }

    static function initProject(cwd:String, appName:String):Void {
        Sys.println('Creating cui project: $appName');

        // Create directories
        var srcDir = cwd + "src/";
        if (!FileSystem.exists(srcDir)) FileSystem.createDirectory(srcDir);

        // Write build.hxml
        var buildContent = '-cp src\n-lib cui\n-main $appName\n-cpp bin\n';
        File.saveContent(cwd + "build.hxml", buildContent);
        Sys.println("  Created build.hxml");

        // Write main app file
        var appContent = 'import cui.App;
import cui.View;
import cui.event.Event;
import cui.event.KeyEvent;
import cui.render.Color;
import cui.render.BorderStyle;
import cui.ui.Text;
import cui.ui.VStack;
import cui.ui.Spacer;

class $appName extends App {
    @:state var count:Int = 0;

    override public function body():View {
        return new VStack([
            new Text("$appName")
                .bold()
                .foregroundColor(Color.Named(NamedColor.Cyan)),
            new Spacer(),
            new Text(\'Count: $${count.get()}\')
                .bold(),
            new Spacer(),
            new Text("+/-: change count | q: quit")
                .dim(),
        ], 0).padding(1).border(Rounded);
    }

    override public function handleEvent(event:Event):Bool {
        switch (event) {
            case Key(key):
                switch (key.code) {
                    case Char(c):
                        if (c == "+" || c == "=") { count.inc(); return true; }
                        if (c == "-") { count.dec(); return true; }
                        if (c == "q") { quit(); return true; }
                    default:
                }
            default:
        }
        return false;
    }

    static function main() {
        var app = new $appName();
        app.run();
    }
}
';
        File.saveContent(srcDir + appName + ".hx", appContent);
        Sys.println('  Created src/$appName.hx');

        // Write .gitignore
        File.saveContent(cwd + ".gitignore", "bin/\n.haxelib/\n");
        Sys.println("  Created .gitignore");

        Sys.println("");
        Sys.println("Done! To build and run:");
        Sys.println("  haxe build.hxml");
        Sys.println('  ./bin/$appName');
    }
}
