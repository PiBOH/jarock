# Generated server directory

This folder is the local Minecraft runtime created by `start-server.bat`.

The repository stores templates, the loader marker reference and loader-specific pinned manifests. `server/server.jar` is generated locally for the selected loader and remains ignored by Git. Fabric also retains the local vanilla engine as `server/vanilla-server.jar`; NeoForge uses its official generated `run.bat` and libraries.

## First run

Always use the repository-root `start-server.bat` entry point. Do **not** double-click `server.jar` or run it with the bare `java` command: Windows may associate `.jar` files with an older Java 8/21 installation, causing `UnsupportedClassVersionError`. Jarock validates and selects the compatible absolute Java 25+ executable for you. For a custom JDK folder, put its folder path or `bin\java.exe` path in the ignored root file `java-home.txt`. Relative paths are resolved from the repository root.

1. Run `start-server.bat` once.
2. If no loader is configured, choose Fabric, Forge or NeoForge. You may open `parameter-manager.bat` during this first-run flow.
3. The bootstrap installs the selected loader and downloads only its matching pinned server mods. Fabric also installs the server-side Links In Chat mod for clickable chat URLs and the `/link`/`/linkwhisper` commands; clients do not need to install it.
4. Read `eula.txt` and set `eula=true` only if you accept the Minecraft EULA.
5. Run `start-server.bat` again.
6. Geyser generates its complete loader-specific configuration on the first server start.
7. After shutdown, the start script applies `auth-type: floodgate` to the generated Geyser config.

## Loader behavior

- **Fabric:** the loader launcher is copied to `server/server.jar`; the vanilla engine is kept locally as `server/vanilla-server.jar`.
- **NeoForge:** the official installer generates `run.bat`, `libraries/` and `user_jvm_args.txt`; Jarock starts that official launcher instead of inventing an unsafe single-jar wrapper.
- **Forge:** the menu recognizes it, but the official Minecraft 26.2 Forge server build is currently unavailable, so startup stops with a suggested alternative.

## Plugins

This is a loader-based mod server. Fabric loads Fabric mods and NeoForge loads NeoForge mods from `server/mods/`; neither loads arbitrary Bukkit, Spigot or Paper plugins from a `plugins/` directory.

Use mods matching the selected loader. If a Bukkit plugin is absolutely required, stop and redesign the stack before adding it; do not copy a random plugin into this directory.
