package cui.backend;

class CrossTerminal {
    public static function create():Backend {
        // For now, only POSIX (macOS/Linux) is supported.
        // Windows support will be added in Phase 7.
        return new AnsiBackend();
    }
}
