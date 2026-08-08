# Minecraft Java 26.2 Modded Server — Fabric first, NeoForge fallback

## Beginner-friendly installation guide

**Project language:** English 
**Audience:** people who have never created a Minecraft server before 
**Target platform:** Minecraft Java Edition 26.2 with Fabric first, NeoForge fallback, and Java/Bedrock cross-play
**Primary example:** Windows 10/11

> **Important:** Minecraft, Fabric, Geyser, Floodgate and mods are updated independently. Every download must explicitly support **Minecraft 26.2**. Do not install a file merely because its name looks similar.

---

## 1. What we are building

At the end, the server will look like this:

```text
Java players ───────────────┐
 ├── Fabric Server 26.2 ── world
Bedrock players ─ Geyser ───┘ │
 ├── Fabric API
 ├── performance mods
 └── Carpet technical tools
```

### Recommended final stack

| Component | What it does | Where it goes |
|---|---|---|
| Java 25 runtime | Runs Minecraft 26.2 | Installed on the computer/host |
| Fabric Server | Loads Fabric mods | Server folder |
| Fabric API | Common dependency for many Fabric mods | `mods/` |
| Geyser-Fabric | Translates Bedrock network traffic to Java traffic | `mods/` |
| Floodgate-Fabric | Lets authenticated Bedrock users join without a Java account | `mods/` |
| Lithium | Optimizes game logic while preserving vanilla behavior | `mods/` |
| FerriteCore | Reduces memory usage | `mods/` |
| Krypton | Optimizes networking | `mods/` |
| ServerCore | Server performance controls | `mods/`, only if a 26.2 build exists |
| Fabric Carpet | Technical tools, rules and redstone testing | `mods/` |
| Essential Commands | Useful server commands, with the required `ec-core` component | `mods/`, Fabric 26.2 only |
| InvView | Opens and manages online/offline player inventories and ender chests | `mods/`, Fabric 26.2 only |
| OfflineCommands | Runs supported commands on offline players; restrict access to trusted operators | `mods/`, Fabric 26.2 only |
| Links In Chat | Server-side clickable links and `/link` or `/linkwhisper` chat commands | `mods/` |
| Welcome Message | Configurable server-side welcome messages; requires Collective | `mods/`, Fabric or NeoForge 26.2 |
| No Chat Reports | Disables server-side chat-reporting signatures | `mods/`, Fabric or NeoForge 26.2 |
| Better Multiplayer Sleep | Lets one player sleep through the night | configured world's `datapacks/`, Fabric or NeoForge |
| Carpet Extra / Carpet TIS Addition | Optional Carpet extensions | `mods/`, only if compatible |

This guide intentionally starts with a small stack. Add one mod at a time, start the server, and test it before adding another.

---

## 2. What the pasted proposal gets right and wrong

### Correct ideas

- Fabric is a good choice when the priority is Fabric mods and technical gameplay.
- Geyser is the normal bridge between Bedrock and Java players.
- Floodgate is useful when Bedrock players should not need a paid Java Edition account.
- Java and Bedrock normally use different network protocols and ports.
- The exact Minecraft version must match the exact mod version.

### Corrections that matter

1. **Do not install Sodium on the server.** Sodium is a rendering optimization for the client. It can be useful for a Java player, but it does not optimize a dedicated server. Bedrock players cannot install it.
2. **Do not start with Cardboard.** Cardboard implements Bukkit/Spigot/Paper APIs on top of Fabric. It can load some plugins, but compatibility is partial and it adds a fragile translation layer. A professional Fabric server should use native Fabric mods whenever possible.
3. **Do not set `online-mode=false` to make Floodgate work.** Keep Java authentication online with `online-mode=true`. Floodgate handles Bedrock authentication through Geyser.
4. **Do not use old Starlight, Phosphor or Noisium files without checking their current 26.2 status.** These projects and forks change quickly. If an exact compatible build is not published, leave it out.
5. **Client-only mods are not server mods.** Litematica, MiniHUD, Tweakeroo and Sodium are normally installed by individual Java players, not in the server's `mods/` folder. Never copy a client-only mod to a dedicated server.
6. **Geyser does not make every modded experience cross-platform.** It works best with server-side changes that preserve vanilla blocks, items and entities. A mod that requires a custom Java client, custom rendering or custom dimensions may not work for Bedrock players.

---

## 3. Before downloading anything

### 3.1 Choose where the server will run

You need a computer or hosting service that stays online while people play.

- **Your home PC:** easy to start, but the PC and internet connection must remain on. You may need router port forwarding.
- **A Minecraft host:** usually easier for public access. Use a host that permits Fabric mods, UDP allocations and Java 25. The host may assign different Java and Bedrock ports; use those assigned ports instead of the defaults in this guide.
- **A VPS:** flexible, but not beginner-friendly. This guide does not require one.

For a first server, a reputable Minecraft host is often simpler than changing router settings.

### 3.2 Check the hardware

As a starting point:

- 64-bit operating system
- at least 8 GB of total system memory
- an SSD rather than a mechanical hard disk
- a stable internet connection
- enough free disk space for backups and world growth

Do not give all computer memory to Minecraft. If the computer has 8 GB total, start with 4 GB for the server. If the computer has 16 GB or more, start with 6 GB and measure before increasing it.

### 3.3 Make a clean folder

Create a folder wherever you want to keep the repository. This is only a beginner-friendly example, not a required location:

```text
C:\MinecraftServer
```

The Jarock scripts resolve their root from the location of `start-server.bat` and support accessible paths with spaces, Unicode characters, `!` and ordinary deep nesting. Avoid `Downloads`, cloud-sync folders and protected Windows system folders when possible because they can add unrelated permission or file-locking problems.

---

## 4. Install Java 25

For this Minecraft 26.2 guide, install a current **64-bit Java 25** runtime, such as Eclipse Temurin 25 or the Java runtime provided by your hosting panel. Minecraft and Fabric can change runtime requirements between release lines, so always follow the Java requirement shown by the current official Fabric/Minecraft server tooling if it differs.

Download Java only from a trustworthy distributor.

**If you are using the Eclipse Temurin installer (HotSpot JDK):** during installation, when the "Custom Setup" screen appears, make sure the **"Set JAVA_HOME variable"** option is enabled. It is often a small icon with a red X by default — click it and select **"Will be installed on local hard drive"** so that `JAVA_HOME` is set automatically. Without `JAVA_HOME`, Jarock and the server may not find Java.

After installing it:

1. Open the Windows Start menu.
2. Type `cmd`.
3. Open **Command Prompt**.
4. Type:

```bat
java -version
```

You should see Java 25 and a 64-bit runtime. If Windows says that `java` is not recognized, Java is not installed correctly or is not on the PATH. Reinstall it or ask the host to select Java 25.

> If the official Fabric installer or the Minecraft launcher reports a different Java requirement, follow the requirement shown by that official tool. Never force an older Java runtime.

> If no compatible Java is installed, `start-server.bat` launches the bundled Java installers automatically: first the legacy Java 8 runtime (`prerequisites/jre-8-windows-x64.exe`) and, once it finishes, the Eclipse Temurin JDK 25 MSI (`prerequisites/OpenJDK25U-jdk_x64_windows_hotspot.msi`). Accept each UAC prompt and let the installers finish; Jarock then re-checks Java and continues.

---

## 5. Choose and install a server loader

On the first `start-server.bat` run, Jarock asks which loader to use when `LOADER_TYPE=none`. You can choose Fabric, NeoForge or Forge; Forge is currently shown as unavailable because no official Minecraft 26.2 server build has been verified. The prompt can also open `parameter-manager.bat` so you configure RAM, GUI/console mode, GC profile, online-mode, the ready banner and Java environment setup before installation.

**Fabric (recommended):** Jarock downloads the official Fabric installer, installs Minecraft 26.2, renames the generated `fabric-server-launch.jar` to the local runtime entry point `server/server.jar`, and retains the vanilla engine as the ignored local `server/vanilla-server.jar`.

**NeoForge (fallback):** Jarock downloads the official NeoForge 26.2 beta installer, runs `--installServer`, and starts the generated official `run.bat` with its libraries and `user_jvm_args.txt`. Modern NeoForge does not provide a portable single loader jar that can safely be renamed to `server.jar`, so `run.bat` is used for this loader.

After choosing a loader, do not mix its mods with another loader. To change loader, back up the world, run `clean-server-runtime.bat`, then select the new loader.

> Jarock handles loader installation automatically on the first run. You do not need to visit the Fabric website, download the installer, or run any Java commands. Simply run `start-server.bat`, choose Fabric or NeoForge, and Jarock downloads and installs everything.

---

## 6. Configure and start Jarock

For this repository, use `parameter-manager.bat` instead of creating a separate `start.bat`. It safely configures RAM, GUI/console mode, the GC profile, online-mode, the ready banner and optional user-scoped Java environment setup. The manager works on a temporary copy: choose Save and exit or Save and start to commit changes, or choose Exit without saving to discard every change and keep the previous settings. The settings are stored locally in `scripts/server-launch-settings.ini`.

Essential Commands 0.41.0 and its required `ec-core` 1.3.0 component are installed on Fabric for Minecraft 26.2 and provide useful server commands. InvView 1.4.21 is also installed on Fabric and allows authorized server operators to inspect and manage online or offline player inventories and ender chests. OfflineCommands 1.0.3 is installed on Fabric and runs supported commands on offline players. Its reviewed artifact is named `OfflineCommands-1.0.3+26.1-rc-3.jar`, but the Modrinth metadata explicitly includes Minecraft 26.2. Because it can affect offline players, restrict it to trusted operators and review command permissions before public use. No compatible NeoForge 26.2 builds are available for Essential Commands, InvView or OfflineCommands, so NeoForge does not install them. No Chat Reports is installed server-side for both supported loaders. It prevents the server from forwarding signed chat-reporting data, but vanilla clients may still show an unsigned-chat warning unless they also use a compatible client-side setup. Jarock does not change `enforce-secure-profile` automatically; keep the server policy explicit and test the clients you use.

The online-mode menu controls `server.properties`:

- `true` is recommended and keeps normal Mojang/Microsoft Java account authentication enabled.
- `false` is an advanced offline-mode setting. Do not use it on a public server unless a trusted proxy is correctly handling authentication; otherwise players can impersonate names.

The default is `true`. The setting is applied before each server launch without changing unrelated properties.

> **Do not set `online-mode=false` before the first server creation.** The server.properties file may not exist yet, and forcing offline mode before the loader has completed its first installation can interfere with the initial setup. Always let the server start with `online-mode=true` at least once, then change it later if you have a documented and tested reason.

After saving settings, run `start-server.bat`. It discovers the compatible Java runtime and uses the selected absolute executable.

---

## 7. Accept the Minecraft EULA

The server cannot run until you accept Mojang's EULA.

1. Close the server window.
2. Open `server\eula.txt` inside the repository folder with Notepad.
3. Read the official EULA: <https://www.minecraft.net/eula>.
4. If you agree, change:

```text
eula=false
```

to:

```text
eula=true
```

5. Save the file.
6. Run `start-server.bat` again.

The first complete start creates `world`, `logs`, `config` and `server.properties`. Jarock verifies Better Multiplayer Sleep and installs it in `world/datapacks` (or the folder named by `level-name`) without replacing an existing world or other datapacks. If you change a datapack manually while the server is running, use `/reload`. Wait until the console says that the server is done before trying to connect.

To stop safely, type this in the server console and press Enter:

```text
stop
```

Then **leave the window open**. Minecraft may still be saving chunks and player data. Close the window only after Jarock prints both `CLEAN SHUTDOWN COMPLETE` and `SAFE TO CLOSE`. If `SAFE TO CLOSE` does not appear, do not force-close the window: inspect `server\logs\latest.log` and the newest crash report first. Force-closing the process, a power loss, or a crash during world saving can leave the world incomplete or corrupt.

Never close the window or shut down the computer while the world is saving if you can avoid it.

---

## 8. Configure the basic server settings

Stop the server with `stop` before editing configuration files. Open `server.properties` with Notepad.

A safe starting point includes:

```properties
motd=My Fabric 26.2 Server
online-mode=true
white-list=false
enforce-whitelist=false
max-players=20
view-distance=8
simulation-distance=6
server-port=25565
```

Notes:

- `online-mode=true` protects Java account authentication. Keep it enabled.
- The whitelist is **disabled by default** (`white-list=false`, `enforce-whitelist=false`) so anyone can join for testing. Before opening the server to the public, set both to `true` and add every trusted player; `enforce-whitelist` applies the whitelist consistently even to operators.
- `view-distance` and `simulation-distance` affect performance. Increase them only after testing.
- `server-port=25565` is the normal Java port. A host may assign a different one.
- Do not paste comments or extra spaces into properties values unless you know they are supported.

Start the server once after saving. With the whitelist enabled, add trusted Java players with:

```text
whitelist add JavaPlayerName
```

For Bedrock names, use the exact name shown by the server after Floodgate is installed. Floodgate may use a prefix such as a dot. If unsure, let the player join while the whitelist is temporarily disabled during private testing, copy the exact Floodgate username from the console, then re-enable the whitelist and add that exact name. For a public server, use the current Floodgate whitelist instructions rather than guessing the prefix; command syntax can change between releases.

---

## 9. Install Fabric API and the cross-play mods

### 9.1 Download from official project pages

Use these pages, then select files that explicitly list **Fabric** and **Minecraft 26.2**:

- Fabric API: <https://modrinth.com/mod/fabric-api>
- Geyser downloads: <https://geysermc.org/download>
- Geyser setup documentation: <https://geysermc.org/wiki/geyser/setup/>
- Floodgate setup documentation: <https://geysermc.org/wiki/floodgate/setup/>

Do not use random re-upload sites. A mod file is normally a `.jar` file. Do not unzip it.

### 9.2 Put the files in the correct folder

Stop the server. Create this folder if it does not exist:

```text
the repository's `server\mods` folder
```

Put these files inside it:

```text
fabric-api-<compatible-version>.jar
Geyser-Fabric-<compatible-version>.jar
floodgate-fabric-<compatible-version>.jar
linksinchat-1.3.1+26.2.jar
collective-26.2.0-8.39.jar
welcomemessage-26.2.0-2.8.jar
```

The exact filenames and versions will change. The important checks are:

- the file is for Fabric;
- the file supports Minecraft 26.2;
- dependencies listed on the download page are installed;
- there is only one copy of each mod.

Run `start-server.bat`. Geyser creates its configuration after the first successful start. Stop the server again before editing it.

### 9.3 Configure Floodgate authentication

Open:

```text
the repository's `server\config\Geyser-Fabric\config.yml` file
```

Find `auth-type` and set it to:

```yaml
auth-type: floodgate
```

The exact indentation and surrounding comments may differ. Change only the value, not the YAML structure.

Start the server again. Read the console for errors. Floodgate's private key files are security-sensitive. **Never publish `key.pem`, upload it to GitHub, or send it to strangers.** A standalone/proxy setup has additional key-copy steps; this single-server Fabric guide does not need them.

---

## 10. Configure the network for Java and Bedrock

There are two independent connections:

| Edition | Default port | Protocol |
|---|---:|---|
| Java | `25565` | TCP |
| Bedrock through Geyser | `19132` | UDP |

### 10.1 Playing on the same computer

- Java address: `localhost` or `127.0.0.1`, using the Java port.
- Bedrock on the same computer: local loopback may require an extra Windows fix and is optional for initial testing.

For beginners, test Bedrock from a second device on the same home network using the server computer's LAN address. This avoids most same-device loopback confusion.

### 10.2 Playing from another device on the same home network

Find the server computer's local IPv4 address. In Command Prompt, run:

```bat
ipconfig
```

Look for an address such as `192.168.1.25` or `10.0.0.25`.

- Java players use that address and the Java TCP port.
- Bedrock players add a server using that address and the Geyser UDP port. The default is `19132`, but use the port shown in the Geyser configuration or assigned by your host.

Allow Java and Geyser through Windows Defender Firewall when Windows asks. If no prompt appears, create firewall rules for the Java TCP port and Geyser UDP port, or ask your hosting provider to do this.

### 10.3 Playing from the Internet

You need either:

1. **Router port forwarding:** forward the Java TCP port (normally `25565`) and the Geyser UDP port (normally `19132`) to the server computer's local IP; also allow both ports in the operating-system firewall.
2. **A tunnel:** use a service that supports both TCP and UDP, such as the Geyser-documented `playit.gg` option. A TCP-only tunnel such as basic ngrok is not suitable for Bedrock UDP traffic.

Do not share the Geyser UDP port with voice chat, query, or another UDP service. If your hosting panel assigns different ports, use the assigned Java port in `server.properties`, the assigned Bedrock port in Geyser's config, and those same values in the connection instructions.

After starting Geyser, test the endpoint from the server console when supported:

```text
geyser connectiontest your.public.address 19132
```

Never publish your home IP more widely than necessary. A host or UDP-capable tunnel is often safer and easier for beginners.

---

## 11. Install optimization and technical mods

Only install a mod after checking its current project page for **Minecraft 26.2**, **Fabric**, and **server-side** support. The table below is a role-based recommendation, not a guarantee that every project has a current build. If the official project page does not list a compatible 26.2 file, do not install that mod.

### Good starting choices

| Mod | Side | Recommendation |
|---|---|---|
| Lithium | Server-side or both | Start here; optimizes game logic while aiming to preserve vanilla behavior |
| FerriteCore | Server-side or both | Useful for memory reduction; verify the 26.2 file |
| Krypton | Server-side or both | Networking optimization; test with Geyser |
| ServerCore | Server-side | Optional; enable conservative settings first |
| Fabric Carpet | Server-side or both | Technical rules, diagnostics and redstone testing |
| Links In Chat | Server-side | Makes URLs in server chat clickable; no client installation is required |
| Welcome Message | Server-side | Sends configurable welcome messages; Collective provides shared configuration support |
| Carpet Extra | Server-side | Optional extension; match its Carpet dependency |
| Carpet TIS Addition | Server-side or both | Optional advanced technical tools; verify 26.2 support |

Install one or two at a time:

1. Stop the server.
2. Copy the new `.jar` into `mods/`.
3. Start the server.
4. Check `logs/latest.log` for errors.
5. Join with Java and, if possible, Bedrock.
6. Keep the mod only if the server remains stable.

### Client-only technical tools

These can be useful to Java players but normally do not belong in the dedicated server's `mods/` folder:

- Sodium
- Litematica
- MiniHUD
- Tweakeroo

A Java player may need to install a compatible client-side version separately. Bedrock players cannot install Java client mods, so never make a client-only mod a requirement for joining.

### About Starlight, Phosphor and Noisium

Do not copy an old optimization list blindly. Starlight and Phosphor are not automatically appropriate for modern releases, and Noisium availability can depend on a fork. Use them only when the project page has a current 26.2 Fabric build and the mod author recommends the combination. Otherwise, leave them out.

---

## 12. Redstone and technical gameplay

Fabric Carpet is the main recommendation for a technical server. It provides rules and tools used for redstone testing, tick inspection and technical construction. It does not magically make every redstone design work with every future Minecraft version.

Before opening the server publicly:

1. Test farms in a copy of the world.
2. Test chunk loading, pistons, hoppers and mob farms.
3. Decide which Carpet rules are allowed.
4. Document any non-vanilla rule in the server rules.
5. Make a backup before changing technical rules or adding a major mod.

A Bedrock player joining through Geyser should be able to interact with vanilla-compatible redstone, but Java and Bedrock clients can display or control some mechanics differently. Test the actual farms your community uses.

---

## 13. Why Cardboard is not the default

Cardboard is a Fabric mod that implements Bukkit/Spigot/Paper APIs. It may help when one specific Bukkit plugin has no Fabric alternative, but it is not equivalent to running Paper and it does not guarantee plugin compatibility.

Use Cardboard only after:

- identifying a plugin that is genuinely required;
- confirming that the Cardboard branch supports Minecraft 26.2;
- testing the plugin in a disposable copy of the world;
- checking that the plugin author supports Cardboard;
- creating reliable backups;
- accepting that debugging may involve both Fabric and Bukkit compatibility layers.

Do **not** combine Cardboard with a large modpack just because it is possible. If the server's main requirement is many mature Bukkit plugins, choose a plugin-first platform instead of forcing Fabric to behave like Paper. If the main requirement is Fabric optimization and redstone mods, stay with pure Fabric and find Fabric-native alternatives.

---

## 14. Backups and safe updates

Before changing Minecraft, Fabric, Geyser, Floodgate or any mod:

1. Stop the server with `stop`.
2. Copy the entire server folder, or at minimum `world`, `world_nether`, `world_the_end`, `config`, `mods`, `server.properties` and `whitelist.json`.
3. Give the backup a date, for example `backup-2026-08-05-before-geyser-update`.
4. Update one component at a time.
5. Start the server and read the log.
6. Test Java and Bedrock connections.
7. Keep the backup until the new version has been used successfully.

Never downgrade a world after opening it with a newer Minecraft version unless the official documentation explicitly says it is safe.

Do not upload these files to a public repository:

```text
world/
world_nether/
world_the_end/
config/Geyser-Fabric/key.pem
config/floodgate/key.pem
logs/
```

---

## 15. First-start checklist

Use this list in order:

- [ ] Java 25 64-bit is installed and `java -version` works.
- [ ] The server folder is outside Downloads and cloud sync.
- [ ] Fabric Server explicitly targets Minecraft 26.2.
- [ ] `eula=true` is set only after reading and accepting the EULA.
- [ ] `online-mode=true` remains enabled, or a trusted proxy architecture has been documented and tested before using `false`.
- [ ] The whitelist is enabled (`white-list=true`, `enforce-whitelist=true`) before public testing; it is disabled by default.
- [ ] Fabric API is in `mods/`.
- [ ] Geyser-Fabric explicitly targets 26.2.
- [ ] Floodgate-Fabric explicitly targets 26.2.
- [ ] Geyser `auth-type` is `floodgate`.
- [ ] Java TCP and Bedrock UDP ports are distinct and reachable.
- [ ] No client-only mod is in the server `mods/` folder.
- [ ] Every optimization and utility mod lists Fabric and Minecraft 26.2.
- [ ] Links In Chat is installed from the pinned Fabric 26.2 manifest when clickable server-chat links are desired.
- [ ] Welcome Message and Collective are installed from the pinned loader manifest and the welcome configuration is customized.
- [ ] Essential Commands and `ec-core` are loaded without errors on Fabric 26.2 when the Fabric loader is selected.
- [ ] No Chat Reports is loaded for the selected loader and Minecraft 26.2.
- [ ] Better Multiplayer Sleep is present in the configured world's `datapacks/` folder and loads without errors.
- [ ] A backup exists before adding technical mods.
- [ ] Java can connect.
- [ ] Bedrock can connect.
- [ ] The server console and `logs/latest.log` show no unresolved errors.

---

## 16. Troubleshooting

### `java` is not recognized

Java is not installed correctly or Windows cannot find it. Install a 64-bit Java 25 runtime and reopen Command Prompt.

### `UnsupportedClassVersionError`

The Java runtime is too old for the server. Minecraft 26.2 requires 64-bit Java 25 or newer. Do not launch `server.jar` directly, because Windows may use Java 8 or Java 21 for `.jar` files. Install a Windows x64 Java 25 JDK from <https://adoptium.net/temurin/releases/?version=25&os=windows&arch=x64&package=jdk>, close and reopen the terminal, and run the repository-root `start-server.bat`.

### The server says a mod is for the wrong version

Remove that mod and download a file that explicitly supports Minecraft 26.2 and Fabric. Do not ignore the error.

### The server crashes during startup

Open `logs/latest.log` and the newest file in `crash-reports/`. Look for the first `Caused by:` line, not only the final line. Common causes are a missing dependency, a client-only mod, duplicate mod files, or a version mismatch.

### The world sometimes appears corrupted after stopping the server

Always enter `stop` in the server console and wait. Do not click the window's X, terminate Java from Task Manager, or turn off the computer while Minecraft is saving. Jarock now prints `CLEAN SHUTDOWN COMPLETE` followed by `SAFE TO CLOSE` only after the Minecraft process exits normally. If the final message is missing or the exit code is not zero, make a backup of the current files, inspect `server\logs\latest.log` and the newest crash report, and restore the world from the newest known-good backup if necessary.

### The server stops with "Overworld settings missing" or does not load the world

The world folder may be incomplete, usually because an earlier startup was interrupted during world generation (for example by a crash, a timeout, or a power loss). Jarock does not move, rename, delete or replace an existing world automatically. It leaves Minecraft's error visible and stops. Inspect `server\logs\latest.log` and the newest crash report, then restore the world from a known-good backup. A fresh world is generated only when the configured `level-name` folder from `server.properties` is absent and no other possible old world folder remains. Java stores the Nether and End inside that world folder (`DIM-1` and `DIM1`). Jarock checks for possible old world folders even when the configured world exists; after a `level-name` change, it refuses to start instead of silently mixing or replacing worlds.

### Java works but Bedrock cannot connect

Check all of these:

- Geyser-Fabric is loaded in the console.
- Floodgate-Fabric is loaded.
- Geyser uses the expected UDP port.
- UDP is allowed in the firewall and router/host panel.
- The Bedrock client uses the correct address and port.
- Another service is not using the same UDP port.
- The Bedrock client is a version supported by the current Geyser release.

Run Geyser's `connectiontest` when available.

### Bedrock joins but is kicked immediately

Read the console. Check `auth-type: floodgate`, the current Floodgate build, whitelist formatting, and whether another authentication or proxy layer is involved. Do not turn off `online-mode` as a workaround.

### Bedrock players see broken content

Geyser translates Java protocol traffic; it does not install Java client mods on Bedrock. Remove client-required content from the required gameplay path, or provide a supported Bedrock resource-pack/mapping solution and test it carefully.

### A Java player cannot connect after adding a client mod

Remove the client mod temporarily and test again. If only one Java player is affected, the problem is likely on that player's client rather than the server.

### The server is laggy

Do not immediately install ten optimization mods. First check the server's tick performance, entity counts, view/simulation distances, world generation activity and host CPU. Add Lithium, FerriteCore and Krypton first, then measure. Use ServerCore conservatively.

---

## 17. Official references

- Fabric server installation: <https://fabricmc.net/use/server/>
- Fabric 26.2 information: <https://fabricmc.net/2026/06/15/262.html>
- Geyser setup: <https://geysermc.org/wiki/geyser/setup/>
- Floodgate setup: <https://geysermc.org/wiki/floodgate/setup/>
- Geyser downloads: <https://geysermc.org/download>
- Minecraft EULA: <https://www.minecraft.net/eula>
- Fabric API: <https://modrinth.com/mod/fabric-api>
- Cardboard project and version chart: <https://github.com/CardboardPowered/cardboard>
- Modrinth mod catalogue: <https://modrinth.com/mods>

Always prefer the project's current documentation and download page over a copied command from an old video or blog post.

<!-- jarock-auto-update-check -->

## Optional startup update check

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows console close protection:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Type stop and wait for SAFE TO CLOSE. Never force-close while the world is saving. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
