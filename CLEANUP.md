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

The script uses an explicit preservation whitelist and removes every other file and directory below `server/`. This also catches newly generated runtime files that are not listed here, including:

- worlds and player data such as `world/`, `world_nether/`, `world_the_end/`, `ops.json` and `whitelist.json`
- `logs/` and `crash-reports/`
- generated `server.properties` and `eula.txt`
- generated Geyser/Floodgate configuration and private keys
- downloaded `mods/` and `libraries/`
- Fabric caches and generated version files
- launchers, installers and local Java path files

## What it preserves

- `server/server.jar` — the official vanilla Minecraft 26.2 bundler jar, intentionally tracked through Git LFS; SHA-256: `cdacdfb25898de5e4b4b0e5ddcc2722f77067e46605709c2d886c000ebb63ec5`; downloaded mod `.jar` files are not tracked
- `server/.gitkeep`
- `server/README.md`
- `server/mods-manifest.ps1`
- `server/eula.txt.template`
- `server/server.properties.template`
- `server/config/Geyser-Fabric/config.yml.template`

After cleanup, a new `start-server.bat` run downloads/regenerates the missing runtime files. The pinned mod manifest verifies every mod, including I’m Fast 1.0.3 for Fabric/Minecraft 26.2.

The cleanup script never changes router settings, firewall rules, port forwarding or public-network configuration. It does not commit or push anything automatically.
