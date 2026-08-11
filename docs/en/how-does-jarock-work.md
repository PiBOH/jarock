# How does Jarock work?

## A plain-English explanation of the server

**Minecraft target:** Java Edition `26.2`
**Default loader:** Fabric (NeoForge is the fallback; Forge is currently unavailable for the official 26.2 build)
**Main platform:** Windows 10/11
** language:** English

This document explains what happens after someone downloads the Jarock repository. It describes the real files and scripts in this repository, not an imaginary installer. The current Jarock project version is stored only in the `scripts/version.txt` file.

---

## 1. The short version

The user does not manually assemble a Minecraft server from many websites. They do this:

1. Install a supported 64-bit Java 25 runtime. **If you use the Eclipse Temurin installer:** during setup, make sure the "Set JAVA_HOME variable" option is enabled (click the red X icon and select "Will be installed on local hard drive"). Without `JAVA_HOME`, Jarock and the server may not find Java.
2. Download or clone this repository.
3. Optionally run `parameter-manager.bat` to choose the loader, RAM, GUI/console mode, a GC profile, the ready banner, the optional startup update check and user-scoped Java environment setup.
4. Run `start-server.bat`; if no loader is configured, Jarock asks whether to use Fabric, Forge or NeoForge and can open the parameter manager.
5. The repository finds its own location.
6. PowerShell checks Java, the Windows path and the repository files.
7. If necessary, Windows long-path support is requested.
8. The bootstrap installs the selected loader and downloads its pinned mod files.
9. Every pinned downloaded file is checked with SHA-512. DedicatedPower is the exception: it is a Fabric-only mod, updated automatically from the latest GitHub release, and its size and checksum are verified after download. Essential Commands 0.41.0 and its required `ec-core` 1.3.0 component are pinned to the reviewed Fabric 26.2 Modrinth version and checksums; InvView 1.4.21 is also pinned to its reviewed Fabric 26.2 Modrinth artifact and checksum, as is OfflineCommands 1.0.3 for running supported commands on offline players. Its reviewed artifact filename includes `26.1-rc-3`, but the Modrinth metadata explicitly includes Minecraft 26.2. Restrict it to trusted operators because it can affect offline-player data. No compatible NeoForge 26.2 builds are available for these three mods. Links In Chat, Welcome Message, Collective and No Chat Reports are pinned to their reviewed Modrinth versions and checksums. Jarock also verifies Better Multiplayer Sleep 1.1.0 and installs it as a datapack in the configured world's `datapacks/` folder for Fabric and NeoForge without replacing existing worlds or datapacks.
10. Fabric creates its runtime and renames its launcher to local `server.jar`; NeoForge creates its official `run.bat` runtime in `server/`.
11. The first bootstrap creates `server/eula.txt`; the launcher stops so the user can read the EULA.
12. After the user sets `eula=true`, the first real server run starts the selected loader and lets Geyser generate its complete configuration.
13. When that run is stopped, `configure-geyser.ps1` sets `auth-type: floodgate`.
14. The next run starts the server with Floodgate fully configured.

The router, firewall and port forwarding are **not** configured by Jarock. Always launch this repository with `start-server.bat`; it repairs Fabric's launcher metadata before starting. Do not double-click `server/server.jar`, because that bypasses the repair and Windows can associate `.jar` files with Java 8 or Java 21 or leave Fabric looking for the game inside the launcher itself.

---

## 2. The parameter manager

`parameter-manager.bat` is a safe beginner-friendly menu. It edits a temporary copy of the settings first and stores changes in `scripts/server-launch-settings.ini`, which is ignored by Git, only when the user chooses Save and exit or Save and start. The menu also provides Exit without saving; this deletes the temporary copy and leaves the existing settings unchanged.

It can configure:

- `RAM_INITIAL`, for example `4G`;
- `RAM_MAX`, for example `6G`;
- `GUI_MODE=gui` or `GUI_MODE=nogui`;
- `GC_PROFILE=default` or the tested `low-pause` profile;
- `LOADER_TYPE=none`, `fabric`, `neoforge` or the unavailable `forge` option;
- `AUTO_CONFIGURE_JAVA=true` or `false`;
Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

RAM values are validated, must be at least `1G`, and initial RAM cannot exceed maximum RAM. Jarock does not silently give all physical memory to Java. The user should still leave enough memory for Windows, backups and other programs.

The `ONLINE_MODE` setting must not be set to `false` before the server has started at least once. The first run creates `server.properties`; forcing offline mode before that file exists can interfere with the initial loader installation. Always complete the first startup with `online-mode=true`. Settings are written through typed PowerShell helpers against the temporary copy, then validated and committed only on an explicit save. `run-server.ps1` validates them again before launch. When the manager was opened by first-run bootstrap, Exit without saving returns the dedicated cancellation status `2`; the bootstrap restores the original loader settings, stops without installing or starting the server, and displays a normal cancellation message rather than an error.

---

## 3. Java environment automation

The bootstrap finds Java 25+ itself and stores the selected absolute executable in the ignored local file `server/java-path.txt`. A custom or unregistered JDK can be selected through the optional ignored root file `java-home.txt` or the advanced `JAROCK_JAVA_HOME` environment variable. Each accepts either the JDK folder or its `bin\java.exe` path; relative paths are resolved from the repository root. If it finds no compatible 64-bit Java 25+ runtime and the bundled installers are present in `prerequisites/`, it launches them automatically — the legacy Java 8 installer (`jre-8-windows-x64.exe`) first, then the Eclipse Temurin JDK 25 MSI (`OpenJDK25U-jdk_x64_windows_hotspot.msi`) — waiting for each to finish before starting the next one, and re-checks afterwards. If still no compatible runtime is found, it stops and reports the detected candidates with a direct Java 25 installation link. This is the authoritative executable used by the server, so Java 8 can remain installed even if it appears first on `PATH`.

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
scripts/console-close-protection.ps1
scripts/configure-java-environment.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
scripts/update-jarock.bat
scripts/validate-eula.ps1
scripts/server-launch-settings.ini.template
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
scripts/version.txt
CHANGELOG.md
TODO.md
```

The generated runtime is placed below `server/`. Generated files such as the world, logs, downloaded `.jar` files, libraries, private keys, local player lists and `scripts/server-launch-settings.ini` are ignored by Git.

---

## 5. What `start-server.bat` does

`start-server.bat` is the single Windows entry point. It stores the directory in which the batch file lives, creates local launch settings, runs `bootstrap-server.ps1`, asks for Fabric/Forge/NeoForge when no loader is configured, verifies the selected runtime and mods, runs `configure-geyser.ps1`, and starts `run-server.ps1`.

The launcher uses the settings selected by `parameter-manager.bat`. It validates the selected Java executable again, quotes paths safely, applies the requested RAM and starts either with or without `nogui`.

If bootstrap or launch fails, the batch file stops and tells the user to read the detailed error and its suggested fix. It does not continue into a broken server.

---

## 6. What the bootstrap does

The bootstrap calculates the repository root from `$PSScriptRoot`, discovers a compatible 64-bit Java 25+ runtime, installs the selected loader, loads the matching loader-specific manifest, downloads and verifies its pinned server mods (DedicatedPower, which is Fabric-only, is the one exception and is always taken from the latest GitHub release), and creates local EULA/properties templates without overwriting existing local configuration. Fabric renames its launcher to the local runtime `server.jar`, keeps the vanilla engine as `vanilla-server.jar`, and maintains `fabric-server-launcher.properties` with `serverJar=vanilla-server.jar`; this prevents the launcher from trying to load itself as the game. NeoForge uses its official generated `run.bat` and libraries. Forge is currently rejected with an actionable message because no official 26.2 build is available.

The default Fabric stack contains Fabric API, Geyser-Fabric, Floodgate-Fabric, Lithium, FerriteCore, Krypton, ServerCore, Fabric Carpet, Essential Commands with `ec-core`, InvView, OfflineCommands, Links In Chat, Welcome Message with Collective, No Chat Reports and DedicatedPower. Essential Commands adds useful server commands, while InvView lets authorized operators inspect and manage online or offline player inventories and ender chests. Essential Commands, InvView and OfflineCommands are Fabric-only for Minecraft 26.2 because no compatible NeoForge builds are available. The loader-neutral Better Multiplayer Sleep datapack is installed separately in the configured world's `datapacks/` folder; use `/reload` after manual datapack changes. Links In Chat is server-side and adds clickable URLs plus `/link` and `/linkwhisper` commands. Welcome Message is server-side and sends configurable join messages; Collective supplies shared configuration support. Players do not need to install these server mods on their clients. It does not install arbitrary Bukkit, Spigot or Paper plugins and it does not add client-only content such as Sodium to the server.

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

## 10. Updating Jarock itself

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

After confirmation, it downloads the matching `jarock-lite` package (`jarock-lite.zip` for stable releases or `jarock-lite-<version>.zip` for beta releases) and its published SHA-512 checksum, verifies the archive before extraction, checks the package version and excludes `.github/` and `.website/`. The Lite package is used intentionally because an existing installation already has its Java prerequisites; the updater does not download or reinstall them. It updates only the project files from the package. It preserves the generated `server/` directory, world data, mods, libraries, server properties, EULA, Geyser/Floodgate keys, local launch settings, Java selection, logs and the updater cache. A rollback copy of overwritten project files is stored under `.cache/update-backups/`.

The updater does not silently reinstall dependencies. The next `start-server.bat` run verifies the selected loader and existing mod files; it downloads only what is missing or invalid. Never run the updater while Minecraft is running, and never close the window during the update.

That is Jarock: a reproducible, verified, local loader-aware server bootstrap with Fabric as the first choice, NeoForge as fallback, configurable safe launch parameters, visible Java/Bedrock LAN addresses after startup and clear safety boundaries. The address message is still printed when `SHOW_READY_BANNER=false`; that setting hides only the ASCII art.

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

<!-- jarock-safe-shutdown -->

## Safe shutdown

Type `stop` in the server console and leave the window open. Jarock prints a world-saving notice when `stop` is detected, then the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Wait for `CLEAN SHUTDOWN COMPLETE` and then `SAFE TO CLOSE`; only then close the window. If the second message does not appear, do not force the process to end: inspect `server\\logs\\latest.log` and the newest crash report, and restore a backup if necessary.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Optional startup update check

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows console close protection:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Type stop and wait for SAFE TO CLOSE. Never force-close while the world is saving. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
