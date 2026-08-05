# Generated server directory

This folder is the local Minecraft runtime created by `start-server.bat`.

Do not commit the generated runtime to Git. The repository tracks only templates and the pinned mod manifest.

## First run

1. Run `start-server.bat` once.
2. The bootstrap downloads Fabric 26.2 and the pinned server mods.
3. Read `eula.txt` and set `eula=true` only if you accept the Minecraft EULA.
4. Run `start-server.bat` again.
5. Geyser generates its complete configuration on the first server start.
6. After shutdown, the start script applies `auth-type: floodgate` to the generated Geyser config.

## Plugins

This is a pure Fabric server. Fabric loads Fabric mods from `server/mods/`; it does not load arbitrary Bukkit, Spigot or Paper plugins from a `plugins/` directory.

Use Fabric-native server mods. If a Bukkit plugin is absolutely required, stop and redesign the stack before adding it; do not copy a random plugin into this directory.
