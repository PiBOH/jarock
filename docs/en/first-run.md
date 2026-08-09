> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

# Jarock first run

This guide explains exactly what happens the first time you use a freshly downloaded Jarock repository. Follow the steps in order. You do not need to download the Minecraft loader or the pinned server mods manually.

## Before you begin

1. Use a 64-bit Windows installation.
2. Install a 64-bit Java 25 or newer JDK. With the Eclipse Temurin installer, enable **Set JAVA_HOME variable** during setup. Close and reopen Command Prompt after installation.
3. Download or clone the complete Jarock repository into any writable folder. Paths with spaces are supported.
4. Do not open `server/server.jar` directly. Always use the root `start-server.bat` launcher.

## Step 1: start the launcher

Double-click `start-server.bat`.

The launcher checks the repository path, Windows long-path support, Java, and the local settings in `scripts/server-launch-settings.ini`. On an older installation it automatically migrates the old root settings file to the new `scripts/` location. It does not open router ports, change firewall rules, or configure port forwarding.

If Java 25 cannot be found and the bundled installers are available, Jarock asks Windows to run `prerequisites/jre-8-windows-x64.exe` first and the Temurin JDK 25 MSI second. Accept the UAC prompts and let each installer finish. Java 25 is the runtime required by Minecraft 26.2; Java 8 is only a legacy prerequisite and is not used to run the server.

## Step 2: choose a loader

If no loader is configured, Jarock displays this choice:

1. **Fabric** — recommended first choice for the supplied optimization, redstone, Geyser and technical mods.
2. **NeoForge** — fallback when a required mod is not available for Fabric.
3. **Forge** — currently unavailable for the verified official Minecraft 26.2 server build; it is not installed silently.

Jarock saves the selected loader in `scripts/server-launch-settings.ini`. Do not mix Fabric and NeoForge runtimes or mods. If you change loader later, make a world backup and use `clean-server-runtime.bat` first.

## Step 3: configure optional settings

The first-run prompt can open `parameter-manager.bat` in a separate window. The menu shows the current values on the right and the editable actions on the left. Important choices include:

- initial and maximum RAM;
- GUI or console mode;
- garbage-collector profile;
- automatic user-scoped Java environment configuration;
- `online-mode`;
- the ready banner;
- the optional interactive startup update check.

Use **Save and exit** or **Save and start** to keep changes. Use **Exit without saving** to cancel without changing the previous settings. The default is `online-mode=true`.

> **Important:** Do not set `online-mode=false` before the first successful server startup. The first run creates and completes the initial Minecraft files. Complete the first startup with `online-mode=true`; only change it later for a documented, private, trusted setup.

## Step 4: automatic installation

Jarock now downloads and verifies the selected loader and its pinned server-side mods.

For Fabric, the Fabric launcher is installed as `server/server.jar` and the vanilla Minecraft engine is retained as `server/vanilla-server.jar`. For NeoForge, the official generated `server/run.bat`, libraries and JVM arguments are used. Fabric also installs the configured Geyser/Floodgate bridge and the supported optimization/technical mods.

The first installation needs Internet access and enough free disk space. If a download fails, read the specific error and its **Suggested fix**, check the network or proxy, and run `start-server.bat` again. No router or firewall changes are made by Jarock.

## Step 5: accept the Minecraft EULA

The first bootstrap creates `server/eula.txt` and normally stops. Read the [Minecraft EULA](https://www.minecraft.net/eula). If you agree to it, open `server/eula.txt`, change:

```text
eula=false
```

to:

```text
eula=true
```

Save the file and run `start-server.bat` again. Do not accept the EULA unless you agree to its terms.

## Step 6: first real server startup

Run `start-server.bat` again. Jarock verifies the loader, Java, templates, mods and Geyser configuration, then starts Minecraft.

The server may create the world during this startup. Let it finish completely. When Geyser is installed, Jarock waits for the final Geyser startup message before showing the optional ready banner. Immediately after the ready message, it prints the LAN address for Java players (`server-port`, TCP) and the LAN address for Bedrock players (Geyser's `bedrock.port`, UDP). If Geyser is not installed, the Bedrock address is reported as unavailable. If `Show ready banner` is disabled, the ASCII art is hidden but these connection addresses are still printed.

If the server reports a world-generation or world-integrity error, do not repeatedly restart it. Jarock never moves, renames, deletes or replaces an existing world automatically. Stop safely, inspect `server/logs/latest.log` and `server/crash-reports/`, and restore the world from a known-good backup. A new world is generated only when the configured `level-name` folder from `server.properties` is absent and no other possible old world folder remains. Java stores the Nether and End inside that world folder (`DIM-1` and `DIM1`). Jarock checks for possible old world folders even when the configured world exists; after a `level-name` change, it refuses to start instead of silently mixing or replacing worlds.

## Step 7: stop safely

To stop the server, type this in the server console:

```text
stop
```

Do **not** close the window immediately after entering `stop`. Jarock prints a notice that the world is being saved, and then — once Minecraft finishes saving — the final `SAFE TO CLOSE` confirmation directly in the server console (in both `gui` and `nogui` modes):

```text
CLEAN SHUTDOWN COMPLETE
SAFE TO CLOSE
```

Only then close the window. Force-closing the console while the world is saving can leave `level.dat` or world-generation data incomplete and may cause apparent world corruption.

## After the first run

- Keep `online-mode=true` unless you have a specific private testing reason and understand the authentication risks.
- Configure router, firewall and port forwarding manually only after completing the security checklist in `TODO.md` and `docs/<locale>/network-and-ports.md`.
- Back up the world before changing loaders, mods or server settings.
- Run `parameter-manager.bat` when you need to change launch settings.
- Choose `U. Check for Jarock updates` in `parameter-manager.bat` to check GitHub without starting the server. If a verified compatible Lite package is available, the updater asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.
Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.
- Keep the generated `server/` runtime private and do not commit worlds, logs, libraries, downloaded jars, keys or local settings.

## Common first-run problems

| Message or symptom | What to do |
|---|---|
| No compatible Java 25+ runtime | Install 64-bit Java 25+, enable `JAVA_HOME`, reopen the terminal, and run `start-server.bat` again. |
| The loader download times out | Check Internet, DNS, proxy and antivirus access; retry the launcher. |
| EULA error | Read the EULA and set `eula=true` only if you agree. |
| `online-mode=false` was set too early | Restore `online-mode=true`, let the first startup finish, then change it only for a private trusted setup. |
| Fabric or NeoForge files are mixed | Back up the world, run `clean-server-runtime.bat`, select one loader, and start again. |
| The window was closed after `stop` | Restore the latest backup and inspect logs before restarting. Always wait for `SAFE TO CLOSE`. |
| `parameter-manager.bat` was cancelled | Run `start-server.bat` again and choose Save and exit or Save and start. |

For a complete explanation of the architecture, read [How does Jarock work?](how-does-jarock-work.md).

<!-- jarock-console-close-protection -->

> **Windows console close protection:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Type stop and wait for SAFE TO CLOSE. Never force-close while the world is saving. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
