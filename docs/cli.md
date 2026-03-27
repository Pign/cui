# CLI

cui includes a CLI tool for project scaffolding.

## Commands

| Command | Description |
|---------|-------------|
| `haxelib run cui init [AppName]` | Create a new cui project |
| `haxelib run cui help` | Show usage information |

## init

Creates a new project with a counter template app.

```bash
haxelib run cui init MyApp
```

### Generated Files

| File | Description |
|------|-------------|
| `src/MyApp.hx` | Main app with counter template |
| `build.hxml` | Build configuration targeting cpp |
| `.gitignore` | Ignores `bin/` and `.haxelib/` |

### Template App

The generated app includes:
- A title with cyan color
- A reactive counter with `@:state var count:Int`
- Keyboard controls (+/-/q)
- Rounded border with padding

### Build and Run

```bash
haxe build.hxml
./bin/MyApp
```

## Build Configuration

A typical `build.hxml` for a cui project:

```
-cp src
-lib cui
-main MyApp
-cpp bin
```

### Options

| Flag | Purpose |
|------|---------|
| `-cp src` | Source code path |
| `-lib cui` | Include cui library |
| `-main MyApp` | Entry point class |
| `-cpp bin` | Output directory (C++ target) |
