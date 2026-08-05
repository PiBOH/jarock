# Jarock

Beginner-friendly template and documentation for a professional Minecraft Java 26.2 server.

## Recommended architecture

### First choice: Fabric

- Fabric Server for Minecraft Java 26.2
- Fabric API
- Geyser-Fabric for Java/Bedrock cross-play
- Floodgate-Fabric for Bedrock authentication
- Native Fabric performance and technical mods
- Java 25 runtime

### Fallback: NeoForge

If an essential mod or modpack is not available for Fabric, use **NeoForge** for Minecraft 26.2:

- NeoForge Server
- Geyser-NeoForge
- Floodgate-NeoForge
- Native NeoForge mods only
- Java 25 runtime, unless the current official tooling states otherwise

**Forge and NeoForge are separate loaders.** For modern Minecraft 26.2, NeoForge is the practical choice; Forge mods are not automatically compatible with NeoForge.

Neither Fabric nor NeoForge automatically runs Bukkit/Spigot/Paper plugins. If the main requirement is a large collection of mature Bukkit plugins, use a plugin-first Paper/Spigot architecture instead. Hybrid projects should be considered only when an exact 26.2 build exists and has been tested separately.

## Quick start

1. Install a supported 64-bit Java runtime for Minecraft 26.2.
2. Clone or download this repository.
3. Double-click `start-server.bat` once; the bootstrap creates `server/eula.txt` from the template and downloads the runtime.
4. Read the generated `server/eula.txt` and, if you accept the Minecraft EULA, change `eula=false` to `eula=true`.
5. Double-click `start-server.bat` again.
6. The script downloads and verifies the pinned Fabric server and mods, then starts the server.
7. Type `stop` in the server console to shut it down safely.

The bootstrap calculates its root from the location of the repository, so it does not depend on a fixed drive or folder. It supports spaces, Unicode names and ordinary deeply nested paths. If the Windows path is long enough to risk the legacy 260-character limit, it checks `LongPathsEnabled` and requests administrator permission to enable it; the script prints whether the change succeeded. It cannot bypass folders for which Windows denies access, unavailable drives, network shares that do not support long paths, or legacy applications that are not long-path-aware. The bootstrap downloads generated runtime files into `server/`, which is ignored by Git. It does **not** open router ports, change firewall rules, configure port forwarding, or expose the server publicly. Configure those items manually only after completing [TODO.md](TODO.md).

The default stack contains Fabric mods only. It does not install or run arbitrary Bukkit/Spigot/Paper plugins. Add a Fabric-native mod only after verifying Minecraft 26.2 compatibility and its server-side support. The bootstrap does not blindly use the first Java on `PATH`: it searches for a 64-bit Java 25+ runtime, reports the selected executable, saves it in the ignored local file `server/java-path.txt`, and reuses that exact path. Therefore an older Java 8 installation can remain on the computer without blocking Jarock. If a failure occurs, the launcher prints an actionable suggested fix; inspect `server/logs/latest.log` and `server/crash-reports/` when the Java process exits with an error.

## Guides

- [Complete English Fabric installation guide](docs/en/server-guide.md)
- [English NeoForge fallback guide](docs/en/neoforge-fallback.md)
- [All installation and fallback translations (including clearly labeled English fallback summaries)](docs/README.md)
- [Guida italiana Fabric](docs/it/server-guide.md)
- [Guida italiana NeoForge](docs/it/neoforge-fallback.md)
- [Configure RAM, GUI and safe launch options](parameter-manager.bat)
- [How Jarock works — English](docs/en/how-does-jarock-work.md)
- [How Jarock works — all translations](docs/README.md)
- [Documentation and translation roadmap](docs/README.md)
- [Project maintenance and contribution guidelines](CONTRIBUTING.md)

The guides explain installation from zero, Java and Bedrock networking, Geyser/Floodgate authentication, optimization and redstone mods, backups, security, troubleshooting and the limitations of client-side mods. See [TODO.md](TODO.md) for the work that remains before public access.

## License

This project is released under the [MIT License](LICENSE).
