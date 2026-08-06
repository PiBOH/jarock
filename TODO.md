# Public Release TODO

This checklist describes what must be completed before the Jarock Fabric server is safe to share publicly.

The repository intentionally does **not** open router ports, modify firewall rules, configure port forwarding, or expose the host to the Internet. Those tasks remain manual and are listed below.

## Required before public access

- [ ] Install a supported 64-bit Java runtime for Minecraft 26.2 and confirm `java -version`.
- [ ] Download this repository from a trusted source. The launcher supports spaces, Unicode names and ordinary deeply nested paths; do not use unavailable drives or folders where Windows denies write access.
- [ ] Run `start-server.bat` once to bootstrap the pinned Fabric server and mods.
- [ ] Read the Minecraft EULA at <https://www.minecraft.net/eula> and set the generated `server/eula.txt` to `eula=true` only if you agree.
- [ ] Review `server/server.properties` and replace the default `motd`, player limit, difficulty and gameplay settings.
- [ ] Keep `online-mode=true` unless an official proxy architecture explicitly requires a different configuration; never use `false` on a public server without trusted authentication.
- [ ] Keep `white-list=true` and add trusted Java players with the server console.
- [ ] Confirm the Floodgate authentication configuration and protect the generated `key.pem` file.
- [ ] Set an administrator/operator policy and add only trusted operators.
- [ ] Test a clean Java client connection on the local machine or LAN.
- [ ] Test a Bedrock connection through Geyser from a second device when possible.
- [ ] Test Java and Bedrock joining, movement, chat, commands, inventory, death/respawn, portals and server shutdown.
- [ ] Test the redstone farms and technical mechanics that the community will actually use.
- [ ] Confirm that every downloaded mod is for Minecraft 26.2, Fabric and the dedicated-server environment.
- [ ] Confirm that no client-only mod was placed in `server/mods/`.
- [ ] Create and restore a complete backup of the world before inviting players.
- [ ] Decide where backups will be stored and how often they will run.
- [ ] Confirm the host has enough CPU, RAM, disk space and uptime for the expected player count.
- [ ] If the repository path is long, confirm the launcher reported `LongPathsEnabled=1`; reboot Windows if an older application still reports the 260-character limit.

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
