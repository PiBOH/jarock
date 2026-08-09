# Generated server directory

This folder is the local Minecraft runtime created by `start-server.bat`.

The repository stores templates, the loader marker reference, loader-specific pinned manifests and the tracked Jarock server icon at `server/server-icon.png`. Minecraft uses that file for the icon shown in the multiplayer server list. `server/server.jar` is generated locally for the selected loader and remains ignored by Git. Fabric also retains the local vanilla engine as `server/vanilla-server.jar`; NeoForge uses its official generated `run.bat` and libraries.

The tracked root `icon.png` is the default Jarock world icon. During bootstrap it is copied to `server/<level-name>/icon.png` only when that world does not already have an icon, so an imported or customized world icon is never overwritten.

## First run

Always use the repository-root `start-server.bat` entry point. Do **not** double-click `server.jar` or run it with the bare `java` command: Windows may associate `.jar` files with an older Java 8/21 installation, causing `UnsupportedClassVersionError`. Jarock validates and selects the compatible absolute Java 25+ executable for you. For a custom JDK folder, put its folder path or `bin\java.exe` path in the ignored root file `java-home.txt`. Relative paths are resolved from the repository root.

1. Run `start-server.bat` once.
2. If no loader is configured, choose Fabric, Forge or NeoForge. You may open `parameter-manager.bat` during this first-run flow.
3. The bootstrap installs the selected loader and downloads only its matching pinned server mods. Both Fabric and NeoForge include the verified server-side No Chat Reports build for Minecraft 26.2. Fabric also installs Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component, InvView 1.4.21 for server-side inventory and ender-chest administration, OfflineCommands 1.0.3 for running commands on offline players (the reviewed artifact filename includes `26.1-rc-3` but its Modrinth metadata explicitly includes 26.2), Links In Chat for clickable chat URLs and the `/link`/`/linkwhisper` commands, plus Welcome Message and its required Collective library for configurable join messages; clients do not need to install these mods. Essential Commands, InvView and OfflineCommands are Fabric-only because no compatible NeoForge 26.2 builds are available; Welcome Message and Collective support Fabric and NeoForge 26.2. It also verifies Better Multiplayer Sleep and places it in the configured world's `datapacks/` folder for both Fabric and NeoForge.
4. Read `eula.txt` and set `eula=true` only if you accept the Minecraft EULA.
5. Run `start-server.bat` again.
6. Before the first Minecraft process starts, Jarock applies `server/config/welcomemessage.json5.template-jarock` as the configured `welcomemessage.json5`. This one-time migration replaces the mod's generic first-run file; later starts preserve operator edits.
7. Geyser generates its complete loader-specific configuration on the first server start.
8. After shutdown, the start script applies `auth-type: floodgate` to the generated Geyser config.

## Loader behavior

- **Fabric:** the loader launcher is copied to `server/server.jar`; the vanilla engine is kept locally as `server/vanilla-server.jar`.
- **NeoForge:** the official installer generates `run.bat`, `libraries/` and `user_jvm_args.txt`; Jarock starts that official launcher instead of inventing an unsafe single-jar wrapper.
- **Forge:** the menu recognizes it, but the official Minecraft 26.2 Forge server build is currently unavailable, so startup stops with a suggested alternative.

## Plugins

This is a loader-based mod server. Fabric loads Fabric mods and NeoForge loads NeoForge mods from `server/mods/`; neither loads arbitrary Bukkit, Spigot or Paper plugins from a `plugins/` directory.

Use mods matching the selected loader. If a Bukkit plugin is absolutely required, stop and redesign the stack before adding it; do not copy a random plugin into this directory.
