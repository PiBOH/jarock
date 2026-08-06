# Manual server cleanup

Run `clean-server-runtime.bat` from the repository root whenever you want to remove generated Minecraft runtime data before a commit or push.

## Before running it

1. Stop the server with the console command:

```text
stop
```

2. Make a backup if the server has been used. The cleanup permanently removes the world, player data, logs and generated configuration.
3. Close any other Java process that is using this repository's `server` directory.

The script refuses to clean while any `java.exe` or `javaw.exe` process is running. This conservative rule prevents a missed server process from causing data loss; close unrelated Java applications too.

## What it removes

The script uses an explicit preservation whitelist and removes every other file and directory below `server/`, including the generated loader marker and both local jar entry points. This also catches newly generated runtime files that are not listed here, including:

- worlds and player data such as `world/`, `world_nether/`, `world_the_end/`, `ops.json` and `whitelist.json`
- `logs/` and `crash-reports/`
- generated `server.properties` and `eula.txt`
- generated Geyser/Floodgate configuration and private keys
- downloaded `mods/` and `libraries/`
- Fabric/NeoForge caches and generated version files
- launchers, installers and local Java path files

## What it preserves

- `server/mods-manifest-neoforge.ps1`
- `server/jarock-loader.txt.template`
- `server/server.jar` — generated locally for the selected loader and not tracked
- `server/vanilla-server.jar` — local Fabric vanilla engine and not tracked
- `server/jarock-loader.txt` — local selected-loader marker and not tracked
- downloaded mod `.jar` files are not tracked
- `server/.gitkeep`
- `server/README.md`
- `server/mods-manifest.ps1`
- `server/eula.txt.template`
- `server/server.properties.template`
- `server/config/Geyser-Fabric/config.yml.template`
- `server/config/Geyser-NeoForge/config.yml.template` when present

After cleanup, a new `start-server.bat` run asks for a loader if needed, downloads/regenerates the selected runtime and verifies the matching pinned mod manifest. Fabric and NeoForge include I’m Fast 1.0.3 builds for Minecraft 26.2; Forge is currently unavailable from the official 26.2 source.

The cleanup script never changes router settings, firewall rules, port forwarding or public-network configuration. It does not commit or push anything automatically.
