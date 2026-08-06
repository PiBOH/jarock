# Generated server directory

This folder is the local Minecraft runtime created by `start-server.bat`.

The repository intentionally tracks the official vanilla Minecraft 26.2 `server.jar` through Git LFS, plus templates and the pinned mod manifest. The bundled jar SHA-256 is `cdacdfb25898de5e4b4b0e5ddcc2722f77067e46605709c2d886c000ebb63ec5`. Other runtime files remain local and ignored. Git LFS must be installed so a clone receives the binary instead of only its pointer.

## First run

Always use the repository-root `start-server.bat` entry point. Do **not** double-click `server.jar` or run it with the bare `java` command: Windows may associate `.jar` files with an older Java 8/21 installation, causing `UnsupportedClassVersionError`. Jarock validates and selects the compatible absolute Java 25+ executable for you. For a custom JDK folder, put its folder path or `bin\java.exe` path in the ignored root file `java-home.txt`. Relative paths are resolved from the repository root.

1. Run `start-server.bat` once.
2. The bootstrap downloads Fabric 26.2 and the pinned server mods, including the server-side I'm Fast mod for Minecraft 26.2.
3. Read `eula.txt` and set `eula=true` only if you accept the Minecraft EULA.
4. Run `start-server.bat` again.
5. Geyser generates its complete configuration on the first server start.
6. After shutdown, the start script applies `auth-type: floodgate` to the generated Geyser config.

## Plugins

This is a pure Fabric server. Fabric loads Fabric mods from `server/mods/`; it does not load arbitrary Bukkit, Spigot or Paper plugins from a `plugins/` directory.

Use Fabric-native server mods. If a Bukkit plugin is absolutely required, stop and redesign the stack before adding it; do not copy a random plugin into this directory.
