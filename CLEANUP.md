# Manual server cleanup

Run `clean-server-runtime.bat` from the repository root whenever you want to remove generated Minecraft runtime data before a commit or push. The script asks whether it should also reset the selected loader.

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
- generated loader files are **not** preserved: `server/server.jar`, `server/vanilla-server.jar` and `server/jarock-loader.txt` are removed
- downloaded mod `.jar` files are not tracked and are removed
- `server/.gitkeep`
- `server/README.md`
- `server/mods-manifest.ps1`
- `server/eula.txt.template`
- `server/server.properties.template`
- `server/config/Geyser-Fabric/config.yml.template`
- `server/config/Geyser-NeoForge/config.yml.template` when present

After cleanup, the default `N` choice keeps the current `LOADER_TYPE` setting, so a new `start-server.bat` run downloads/regenerates the same selected runtime and verifies its matching pinned mod manifest. Choose `Y` when you also want to clear the active loader selection: after the cleanup succeeds, the script changes `LOADER_TYPE` to `none`; the local loader marker was already removed by the cleanup, and the next start asks you to choose Fabric or NeoForge again. This reset does not restore the deleted world, mods, libraries or generated configuration. Fabric and NeoForge include I’m Fast 1.0.3 builds for Minecraft 26.2; Forge is currently unavailable from the official 26.2 source.

The cleanup script never changes router settings, firewall rules, port forwarding or public-network configuration. It does not commit or push anything automatically.
