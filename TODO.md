# Public Release TODO

This checklist describes what must be completed before the Jarock loader-aware server is safe to share publicly. Fabric is the first choice; NeoForge is the fallback; Forge remains unavailable until an official Minecraft 26.2 build is verified.

The repository intentionally does **not** open router ports, modify firewall rules, configure port forwarding, or expose the host to the Internet. Those tasks remain manual and are listed below.

## Required before public access

- [ ] Test `jarock-tui.exe` on a clean Windows x64 machine and confirm OpenTUI native rendering, menu actions, and bundled runtime behavior. (CI smoke test is configured; clean-machine verification remains pending.)
- [ ] Publish and verify the four CLI/TUI release ZIP families and their SHA-512 assets in a real GitHub Actions release.

- [x] Install a supported 64-bit Java runtime for Minecraft 26.2 and confirm `java -version` (Java 25.0.4, 64-bit, selected successfully by the launcher).
- [x] Download this repository from a trusted source. The launcher supports spaces, Unicode names and ordinary deeply nested paths; do not use unavailable drives or folders where Windows denies write access.
- [x] Run `start-server.bat` once, choose Fabric or NeoForge, and confirm the selected loader-specific runtime and mods are installed. Fabric 26.2 was selected, the runtime was generated, and the server booted successfully with all pinned mods (Fabric API, Geyser, Floodgate, Lithium, FerriteCore, Krypton, ServerCore, Async, Fabric Carpet, Essential Commands, ec-core, InvView, OfflineCommands, I'm Fast, Links In Chat, Welcome Message, Collective, No Chat Reports, DedicatedPower) and the verified Better Multiplayer Sleep datapack.
- [x] Read the Minecraft EULA at <https://www.minecraft.net/eula> and set the generated `server/eula.txt` to `eula=true` only if you agree. The generated `server/eula.txt` is set to `eula=true`.
- [x] Review `server/server.properties` and replace the default `motd`, player limit, difficulty and gameplay settings. Customized: a branded two-line color-coded `motd` (Jarock name + site link), `max-players=20`, `difficulty=normal`, `gamemode=survival`. The `online-mode` rewrite preserves the `motd` byte-for-byte (Latin-1/UTF-8/BOM safe).
- [x] Verify `parameter-manager.bat`: it opens and shows the current settings, edits a temporary copy, and `Save and exit` / `Save and start` / `Exit without saving` behave correctly. It configures RAM, GUI/console mode, the GC profile, online-mode, the Java environment setup, the ready banner, world import/export (`I` / `E`, with manual paths, `CLEAR` and a Windows folder picker), the remembered-world choice (`Remember this world for future starts? (Y/n)`) and the startup update mode.
- [x] Verify the world import/export feature: `I. Import world` imports a folder or `.zip` world into the configured `level-name` on the next start (asking for confirmation and backing up the existing world as `<name>_originalbkp` first); the parameter manager asks `Remember this world for future starts? (Y/n)` with Yes as the default. A remembered source is retained and imported again at every start with confirmation and a backup of the existing world (`world_originalbkp`); an incomplete world folder is replaced the same way after confirmation; answering `n` keeps one-shot behavior. `E. Export world` mirrors the world to a destination folder outside `server/` after every clean shutdown. The `test-world-transfer.yml` workflow covers folder, zip, backup, remembered-source recovery and export behavior.
- [x] Verify the ready banner: the ASCII-art "Done!" banner appears in the console once the server finishes loading (after Geyser when it is installed), and the `Show ready banner` option in the parameter manager shows or hides it.
- [x] Verify the Jarock icons: the tracked root `icon.png` is applied only as the default icon for worlds without a custom `icon.png`, `server/icon.png` is included in the server runtime, `server/server-icon.png` is used for the multiplayer server list, and all three files are included in Full and Lite autorelease ZIPs.
- [x] Verify the safe-shutdown flow: typing `stop` prints a world-saving notice and then the final `SAFE TO CLOSE` confirmation directly in the server console (in both `gui` and `nogui` modes) once the world save completes; the console-close protection warns against forced closing.
- [ ] Keep `online-mode=true` unless an official proxy architecture explicitly requires a different configuration; never use `false` on a public server without trusted authentication. **Currently `online-mode=false` in `server/server.properties` — flip it to `true` before going public.**
- [ ] Keep `white-list=true` and add trusted Java players with the server console. **Currently `white-list=false` — enable it and add trusted players before going public.**
- [ ] Confirm the Floodgate authentication configuration and protect the generated `key.pem` file.
- [ ] Set an administrator/operator policy and add only trusted operators.
- [ ] Test a clean Java client connection on the local machine or LAN.
- [ ] Test a Bedrock connection through Geyser from a second device when possible.
- [ ] Test Java and Bedrock joining, movement, chat, commands, inventory, death/respawn, portals and server shutdown.
- [ ] Test the redstone farms and technical mechanics that the community will actually use.
- [x] Confirm that every downloaded mod is for Minecraft 26.2, the selected loader and the dedicated-server environment; Essential Commands, `ec-core`, InvView and OfflineCommands are Fabric-only, Welcome Message and Collective are verified for both Fabric and NeoForge, Async is pinned for both loaders as an experimental server-side mod, No Chat Reports is verified for both loaders, and the Better Multiplayer Sleep datapack is pinned separately and installed into the configured world. The Jarock Welcome Message template is applied once on first setup and later edits are preserved.
- [x] Rename the Welcome Message template from `server/config/welcomemessage.json5.template-jarock` to `server/config/welcomemessage.json5.jarock`, update all references and release workflows, and preserve legacy updater compatibility through the temporary archive alias and automatic bootstrap migration.
- [ ] Confirm that the Better Multiplayer Sleep datapack loads successfully in a live world and that one-player sleep behavior matches the server's intended rules.
- [x] Confirm that no client-only mod was placed in `server/mods/`; No Chat Reports is the reviewed server-side build for both supported loaders.
- [ ] Confirm that vanilla and modified clients display the intended unsigned-chat behavior with `enforce-secure-profile` kept explicit.
- [ ] Create and restore a complete backup of the world before inviting players.
- [ ] Decide where backups will be stored and how often they will run.
- [ ] Confirm the host has enough CPU, RAM, disk space and uptime for the expected player count.
- [x] Check the repository path length. The tested path was safe, so Windows long-path policy was not required; reboot Windows if an older application still reports the 260-character limit.

## Manual network and hosting tasks

- [ ] Decide whether the server runs at home, on a Minecraft host or on a VPS.
- [ ] If self-hosting, assign the computer a stable LAN IP address.
- [ ] Open the Java server port in the operating-system firewall manually, if required.
- [ ] Open the Geyser Bedrock UDP port in the operating-system firewall manually, if required.
- [ ] Configure router port forwarding manually for the Java TCP port, if Internet access is required.
- [ ] Configure router port forwarding manually for the Geyser UDP port, if Bedrock Internet access is required.
- [ ] Never share the Geyser UDP port with voice chat, query or another UDP service.
- [ ] If using a tunnel, choose one that supports UDP; a TCP-only tunnel is not sufficient for Bedrock.
- [ ] Test the public endpoint from a network that is not the server's LAN.
- [ ] Do not publish the home IP address unnecessarily; consider a reputable host or UDP-capable tunnel.

## Security and operations

- [ ] Enable automated backups and periodically perform a restore test.
- [ ] Keep Floodgate private keys, world data, logs and local configuration out of public repositories.
- [ ] Do not give operator permissions to ordinary players.
- [ ] Create a written moderation and ban policy.
- [ ] Decide how logs will be retained and who can access them.
- [ ] Keep Minecraft, Fabric, Geyser, Floodgate and mods pinned and update them one component at a time.
- [ ] Read each update's compatibility notes before applying it.
- [ ] Back up the world before every Minecraft, loader or mod update.
- [ ] Monitor tick performance, memory, disk usage and player reports.
- [ ] Document a rollback procedure.
- [ ] Verify the license and redistribution terms for every mod and plugin added later.

## Release gate

The server is **not ready for public access** until all Required items are checked, a backup restore has succeeded, Java and Bedrock have both been tested, and the manual network configuration has been reviewed by the server owner.
