# How does Jarock work?

## A plain-English explanation of the server

**Current project version:** `0.0.2-alpha`  
**Minecraft target:** Java Edition `26.2`  
**Default loader:** Fabric  
**Main platform:** Windows 10/11  
**Canonical language:** English

This document explains what happens after someone downloads the Jarock repository. It describes the real files and scripts in this repository, not an imaginary installer.

---

## 1. The short version

The user does not manually assemble a Minecraft server from many websites. They do this:

1. Install a supported 64-bit Java runtime.
2. Download or clone this repository.
3. Run `start-server.bat`.
4. The repository finds its own location.
5. PowerShell checks Java, the Windows path and the repository files.
6. If necessary, Windows long-path support is requested.
7. The bootstrap downloads the pinned Fabric installer and mod files.
8. Every downloaded file is checked with SHA-512.
9. Fabric creates the Minecraft server runtime in `server/`.
10. The first bootstrap creates `server/eula.txt`; the launcher stops so the user can read the EULA.
11. After the user sets `eula=true`, the first real server run starts Fabric and lets Geyser generate its complete configuration.
12. When that run is stopped, `configure-geyser.ps1` sets `auth-type: floodgate`.
13. The next run starts the server with Floodgate fully configured. Geyser translates Bedrock traffic and Floodgate handles Bedrock authentication.

The router, firewall and port forwarding are **not** configured by Jarock.

---

## 2. The repository is the launcher, not the generated server

The Git repository contains instructions, scripts, templates and a pinned manifest. It does not commit the generated world or downloaded `.jar` files.

Important tracked files include:

```text
start-server.bat
scripts/bootstrap-fabric.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
version.txt
CHANGELOG.md
TODO.md
```

The generated runtime is placed below:

```text
server/
```

Generated files such as the world, logs, downloaded `.jar` files, libraries, private keys and local player lists are ignored by Git. This keeps the repository small and prevents secrets or changing runtime data from being published.

---

## 3. What `start-server.bat` does

`start-server.bat` is the single Windows entry point.

It first stores the directory in which the batch file lives. It does not assume a drive letter or a path such as `C:\MinecraftServer`. Therefore the repository can be moved to another drive or folder, including a path containing spaces or Unicode characters.

It then runs:

```text
scripts\bootstrap-fabric.ps1
```

If that script fails, the batch file stops and tells the user to read the detailed error and its suggested fix. It does not continue into a broken server.

After bootstrap, the batch file checks that:

- `server/fabric-server-launch.jar` exists;
- `server/eula.txt` exists;
- the file contains exactly `eula=true`.

If the EULA has not been accepted, the server is not started. The user receives the official EULA link and the exact file to edit.

Next, the batch file runs:

```text
scripts\configure-geyser.ps1
```

Finally, it enters the generated `server/` directory with a quoted path and starts:

```text
java -Xms4G -Xmx4G -jar fabric-server-launch.jar nogui
```

When Java exits, the batch file reports the exit code. If it is not zero, it tells the user to inspect:

```text
server\logs\latest.log
server\crash-reports\
```

The first meaningful `Caused by:` line usually identifies the problem.

---

## 4. What `bootstrap-fabric.ps1` does

The bootstrap script is deliberately repeatable. Running it again verifies existing files and downloads only files that are missing.

### Step 1: calculate the root

The script calculates the repository root from `$PSScriptRoot`. It does not use a hard-coded working directory. Paths are built with PowerShell path functions such as `Join-Path` and are passed as literal paths where possible.

This is why a normal folder such as these can work:

```text
C:\Users\Alex\Downloads\jarock
D:\Minecraft Projects\Jarock
C:\Progetti\Server Minecraft\jarock
```

The folder still needs to exist, be available, and be writable by the current Windows user.

### Step 2: check long paths

The script estimates whether the repository is deep enough to risk Windows' legacy 260-character limit. If the path is short, it prints that long-path support is not required.

If the path is deep, it checks:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

If the value is not `1`, Jarock requests administrator permission and runs:

```text
scripts\enable-long-paths.ps1
```

That helper attempts to set `LongPathsEnabled` to the DWORD value `1`. It prints that the change is machine-wide and that a reboot may be needed by older applications.

Jarock never changes router settings or firewall rules as part of this operation.

### Important path limitation

No script can make an unavailable drive, a read-only folder, a denied permission, an unsupported network share or a legacy non-long-path-aware application work. Jarock supports arbitrary **accessible Windows repository locations**; it cannot override Windows access restrictions.

### Step 3: check Java

The script requires the `java` command and reads the output of:

```text
java -version
```

The configured Minecraft 26.2 setup requires Java 25 or newer according to the current project configuration. If Java is missing or too old, the bootstrap stops and explains how to install Java and reopen the terminal.

### Step 4: load the mod manifest

The script loads:

```text
server\mods-manifest.ps1
```

The manifest contains a filename, a download URL, an SHA-512 hash, a purpose and a required flag for each pinned mod. The current default stack contains:

- Fabric API;
- Geyser-Fabric;
- Floodgate-Fabric;
- Lithium;
- FerriteCore;
- Krypton;
- ServerCore;
- Fabric Carpet.

The repository does not put arbitrary Bukkit, Spigot or Paper plugins in a `plugins/` directory. This is a pure Fabric server and uses Fabric mods.

### Step 5: download and verify Fabric

The script downloads the pinned Fabric installer from the official Fabric Maven URL. It calculates the local SHA-512 hash and compares it with the pinned value.

If the file is altered, incomplete or replaced by a proxy/error page, the script deletes it and reports the failure. The suggested fix is to retry and check Internet access, antivirus and proxy interference.

### Step 6: install the server

If `server/fabric-server-launch.jar` is missing, the script executes the Fabric installer inside the generated server directory:

```text
java -jar fabric-installer-1.1.2.jar server -mcversion 26.2 -loader 0.19.3 -downloadMinecraft
```

The installer creates the Fabric launcher, Minecraft server files and libraries. If the installer returns a non-zero exit code, the bootstrap stops with a suggested fix instead of starting a partial installation.

### Step 7: download and verify mods

Each entry in `server/mods-manifest.ps1` is downloaded into:

```text
server\mods\
```

Each file is hashed with SHA-512. A mismatch removes the invalid file and tells the user to retry or investigate antivirus/proxy interference.

### Step 8: create local templates

The script creates these files only when they do not already exist:

```text
server\eula.txt
server\server.properties
```

It never overwrites a user's existing local configuration.

---

## 5. Why the first start is two-stage

Minecraft requires the operator to accept the EULA. Jarock therefore cannot silently accept it.

### First run

The first run normally does this:

1. downloads the runtime and mods;
2. creates `server/eula.txt` with `eula=false`;
3. stops before launching the real server.

The user must read <https://www.minecraft.net/eula>. If they agree, they edit:

```text
server\eula.txt
```

and change:

```text
eula=false
```

to:

```text
eula=true
```

### Second run

The second run checks the exact value. If it is `eula=true`, Jarock continues and launches Fabric. During this first real server run, Geyser creates its complete configuration. The server may then be stopped safely with `stop`.

After shutdown, `configure-geyser.ps1` changes the generated Geyser configuration to:

```yaml
auth-type: floodgate
```

Run `start-server.bat` once more so Geyser and Floodgate load the new authentication setting. This is intentional: the project automates installation, but it does not make the legal decision for the server owner.

---

## 6. What happens to Geyser and Floodgate

Geyser-Fabric and Floodgate-Fabric are downloaded as Fabric mods.

Geyser's complete configuration is generated by Geyser during the first real server start. Jarock does not replace that generated YAML with an incomplete template. Because the helper can only patch a configuration that already exists, Floodgate authentication becomes active on the following server start.

After Geyser has created:

```text
server\config\Geyser-Fabric\config.yml
```

the configuration helper looks for `auth-type` and sets:

```yaml
auth-type: floodgate
```

On a later run, the helper sees that the value is already correct and leaves it unchanged.

Geyser uses a Bedrock UDP listener, normally port `19132`. Java normally uses TCP port `25565`. Jarock documents these values but does not open, forward or test them by changing the host network.

The Floodgate private key, commonly `key.pem`, must never be uploaded to GitHub or shared. Generated configuration and secrets are ignored by Git where appropriate.

---

## 7. What the server mods do

The default server is intentionally mod-based:

- **Fabric API** supplies common Fabric APIs.
- **Geyser-Fabric** translates Bedrock protocol traffic.
- **Floodgate-Fabric** handles Bedrock authentication integration.
- **Lithium** optimizes game logic.
- **FerriteCore** reduces memory usage.
- **Krypton** optimizes networking.
- **ServerCore** provides server performance controls.
- **Fabric Carpet** provides technical rules and redstone tools.

Client-only mods such as Sodium, Litematica, MiniHUD and Tweakeroo are not part of the server manifest. A client-only mod should not be copied into `server/mods/`.

A normal Fabric server does not run arbitrary Bukkit, Spigot or Paper plugins. If a plugin is required, the architecture must be reconsidered rather than silently copying the plugin into the server folder.

---

## 8. What Jarock does not do

Jarock does not:

- open the router;
- configure port forwarding;
- change Windows Firewall rules;
- publish a public IP address;
- create a hosting account;
- start a proxy;
- accept the Minecraft EULA for the user;
- grant operator permissions automatically;
- upload worlds or secrets to GitHub;
- install arbitrary Bukkit plugins.

These omissions are deliberate safety boundaries. The remaining public-release tasks are listed in `TODO.md`.

---

## 9. What to do after an error

Jarock is designed to print a suggested fix after failures.

1. Read the `ERROR:` or `WARNING:` line.
2. Follow the `Suggested fix:` text.
3. Run `start-server.bat` again.
4. If Java starts and then stops, inspect:

```text
server\logs\latest.log
server\crash-reports\
```

5. Look for the first `Caused by:` entry.
6. Check that the relevant mod is for Fabric and Minecraft `26.2`.
7. Never delete the world before making a backup.

Common causes are missing Java, an old Java version, no write permission, no Internet access, a corrupted download, an unaccepted EULA, a client-only mod on the server or an incompatible mod update.

---

## 10. The complete flow in one diagram

```text
User downloads repository
          │
          ▼
  start-server.bat
          │
          ▼
 bootstrap-fabric.ps1
          │
          ├── calculate repository root
          ├── check long-path policy
          ├── check Java 25+
          ├── load pinned mod manifest
          ├── download + verify Fabric installer
          ├── install Fabric Server 26.2
          ├── download + verify Fabric mods
          └── create EULA/properties templates
          │
          ▼
 First run stops at eula=false
          │
          ▼
 User reads EULA and sets eula=true
          │
          ▼
 start-server.bat again
          │
          └── java ... fabric-server-launch.jar nogui
                          │
                          ├── Geyser generates config.yml
                          └── server is stopped safely
                                      │
                                      ▼
                         configure-geyser.ps1 sets floodgate
                                      │
                                      ▼
                            start-server.bat once more
                                      │
                                      └── java ... fabric-server-launch.jar nogui
                                                        │
                          ├── Java players via TCP
                          └── Bedrock players via Geyser UDP
```

That is Jarock: a reproducible, verified, local Fabric server bootstrap with clear safety boundaries and actionable errors.
