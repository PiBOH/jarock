# How does Jarock work?

## A plain-English explanation of the server

**Minecraft target:** Java Edition `26.2`
**Default loader:** Fabric (NeoForge is the fallback; Forge is currently unavailable for the official 26.2 build)
**Main platform:** Windows 10/11
**Canonical language:** English

This document explains what happens after someone downloads the Jarock repository. It describes the real files and scripts in this repository, not an imaginary installer. The current Jarock project version is stored only in the root `version.txt` file.

---

## 1. The short version

The user does not manually assemble a Minecraft server from many websites. They do this:

1. Install a supported 64-bit Java 25 runtime.
2. Download or clone this repository.
3. Optionally run `parameter-manager.bat` to choose the loader, RAM, GUI/console mode, a GC profile and user-scoped Java environment setup.
4. Run `start-server.bat`; if no loader is configured, Jarock asks whether to use Fabric, Forge or NeoForge and can open the parameter manager.
5. The repository finds its own location.
6. PowerShell checks Java, the Windows path and the repository files.
7. If necessary, Windows long-path support is requested.
8. The bootstrap installs the selected loader and downloads its pinned mod files.
9. Every downloaded file is checked with SHA-512.
10. Fabric creates its runtime and renames its launcher to local `server.jar`; NeoForge creates its official `run.bat` runtime in `server/`.
11. The first bootstrap creates `server/eula.txt`; the launcher stops so the user can read the EULA.
12. After the user sets `eula=true`, the first real server run starts the selected loader and lets Geyser generate its complete configuration.
13. When that run is stopped, `configure-geyser.ps1` sets `auth-type: floodgate`.
14. The next run starts the server with Floodgate fully configured.

The router, firewall and port forwarding are **not** configured by Jarock. Always launch this repository with `start-server.bat`; do not double-click `server/server.jar`, because Windows can associate `.jar` files with Java 8 or Java 21 and produce `UnsupportedClassVersionError`.

---

## 2. The parameter manager

`parameter-manager.bat` is a safe beginner-friendly menu. It edits a temporary copy of the settings first and stores changes in `server-launch-settings.ini`, which is ignored by Git, only when the user chooses Save and exit or Save and start. The menu also provides Exit without saving; this deletes the temporary copy and leaves the existing settings unchanged.

It can configure:

- `RAM_INITIAL`, for example `4G`;
- `RAM_MAX`, for example `6G`;
- `GUI_MODE=gui` or `GUI_MODE=nogui`;
- `GC_PROFILE=default` or the tested `low-pause` profile;
- `LOADER_TYPE=none`, `fabric`, `neoforge` or the unavailable `forge` option;
- `AUTO_CONFIGURE_JAVA=true` or `false`.

RAM values are validated, must be at least `512M`, and initial RAM cannot exceed maximum RAM. Jarock does not silently give all physical memory to Java. The user should still leave enough memory for Windows, backups and other programs.

The manager never inserts arbitrary text directly into a shell command. Settings are written through typed PowerShell helpers against the temporary copy, then validated and committed only on an explicit save. `run-server.ps1` validates them again before launch. When the manager was opened by first-run bootstrap, Exit without saving returns the dedicated cancellation status `2`; the bootstrap restores the original loader settings, stops without installing or starting the server, and displays a normal cancellation message rather than an error.

---

## 3. Java environment automation

The bootstrap finds Java 25+ itself and stores the selected absolute executable in the ignored local file `server/java-path.txt`. A custom or unregistered JDK can be selected through the optional ignored root file `java-home.txt` or the advanced `JAROCK_JAVA_HOME` environment variable. Each accepts either the JDK folder or its `bin\java.exe` path; relative paths are resolved from the repository root. If it finds only Java 8 or Java 21, it stops and reports those detected candidates with a direct Java 25 installation link. This is the authoritative executable used by the server, so Java 8 can remain installed even if it appears first on `PATH`.

When `AUTO_CONFIGURE_JAVA=true`, Jarock additionally updates only the current user's environment:

- `JAVA_HOME` points to the selected JDK folder;
- the selected Java `bin` directory is placed first in the user's `PATH`;
- unrelated user `PATH` entries are preserved;
- Windows is notified about the environment change.

Jarock does **not** modify machine-wide environment variables, does not require administrator rights for this user-level operation, and does not delete unrelated Java or developer tools. Existing terminals may need to be closed and reopened.

---

## 4. The repository is the launcher, not the generated server

The Git repository contains instructions, scripts, templates and a pinned manifest. It does not commit the generated world or downloaded `.jar` files.

Important tracked files include:

```text
start-server.bat
parameter-manager.bat
scripts/bootstrap-server.ps1
scripts/java-runtime.ps1
scripts/run-server.ps1
scripts/configure-java-environment.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server-launch-settings.ini.template
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
version.txt
CHANGELOG.md
TODO.md
```

The generated runtime is placed below `server/`. Generated files such as the world, logs, downloaded `.jar` files, libraries, private keys, local player lists and `server-launch-settings.ini` are ignored by Git.

---

## 5. What `start-server.bat` does

`start-server.bat` is the single Windows entry point. It stores the directory in which the batch file lives, creates local launch settings, runs `bootstrap-server.ps1`, asks for Fabric/Forge/NeoForge when no loader is configured, verifies the selected runtime and mods, runs `configure-geyser.ps1`, and starts `run-server.ps1`.

The launcher uses the settings selected by `parameter-manager.bat`. It validates the selected Java executable again, quotes paths safely, applies the requested RAM and starts either with or without `nogui`.

If bootstrap or launch fails, the batch file stops and tells the user to read the detailed error and its suggested fix. It does not continue into a broken server.

---

## 6. What the bootstrap does

The bootstrap calculates the repository root from `$PSScriptRoot`, discovers a compatible 64-bit Java 25+ runtime, installs the selected loader, loads the matching loader-specific manifest, downloads and verifies its pinned server mods, and creates local EULA/properties templates without overwriting existing local configuration. Fabric renames its launcher to the local runtime `server.jar` and keeps the vanilla engine as `vanilla-server.jar`; NeoForge uses its official generated `run.bat` and libraries. Forge is currently rejected with an actionable message because no official 26.2 build is available.

The default Fabric stack contains Fabric API, Geyser-Fabric, Floodgate-Fabric, Lithium, FerriteCore, Krypton, ServerCore and Fabric Carpet. It does not install arbitrary Bukkit, Spigot or Paper plugins and it does not add client-only content such as Sodium to the server.

If a required Fabric mod is unavailable, the documented final loader fallback is NeoForge. Forge and NeoForge are separate loaders and their mods are not interchangeable.

---

## 7. First start and Geyser/Floodgate

The first run creates `server/eula.txt` with `eula=false` and stops. The user reads <https://www.minecraft.net/eula> and changes it to `eula=true` only if they agree.

The next real run lets Geyser create its complete configuration. After a safe shutdown, `configure-geyser.ps1` changes the generated setting to:

```yaml
auth-type: floodgate
```

Run the launcher once more so Floodgate loads the new setting. The Floodgate private key must never be uploaded or shared.

---

## 8. Paths and safety boundaries

Jarock supports repository paths with spaces, Unicode, `!` and ordinary deep nesting when Windows can access and write the folder. It may request `LongPathsEnabled=1` for deep paths and reports the result.

It cannot bypass unavailable drives, denied permissions, unsupported network shares or legacy applications that do not support long paths.

Jarock does not open router ports, modify firewall rules, configure port forwarding, publish an IP, accept the EULA, grant operator permissions, upload worlds or install arbitrary plugins.

---

## 9. After an error

1. Read the `ERROR:` or `WARNING:` line.
2. Follow the `Suggested fix:` text.
3. Run `start-server.bat` again.
4. If Java starts and then stops, inspect `server/logs/latest.log` and `server/crash-reports/`.
5. Look for the first `Caused by:` entry.
6. Check that the relevant mod matches Fabric and the target Minecraft release.
7. Never delete the world before making a backup.

That is Jarock: a reproducible, verified, local loader-aware server bootstrap with Fabric as the first choice, NeoForge as fallback, configurable safe launch parameters and clear safety boundaries.
