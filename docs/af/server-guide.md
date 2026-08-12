# Fabric-bedienergids

Installeer ondersteunde 64-bis Java 25, voer `start-server.bat` uit en gebruik `parameter-manager.bat` vir RAM en GUI of `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Lees `server/eula.txt` en stel `eula=true` slegs ná EULA-aanvaarding. Fabric, Geyser-Fabric en Floodgate-Fabric word gebruik; maak rugsteune. Jarock verander nie router, firewall of port forwarding nie.

See the [English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


Jarock never moves, renames, deletes or replaces an existing world automatically. If Minecraft reports a world-integrity or generation error, stop safely, inspect the logs and crash report, and restore the world from a known-good backup. A fresh world is generated only after you deliberately delete the existing `world`, `world_nether` and `world_the_end` folders yourself. If only some of `world`, `world_nether` and `world_the_end` exist, Jarock refuses to start to prevent mixing old and new dimensions; restore all three from a backup or deliberately delete all three to create a new world. Java stores the Nether and End inside the configured `level-name` folder as `DIM-1` and `DIM1`. If that configured folder exists, Jarock leaves it untouched and lets Minecraft load it or report its integrity error. A new world is possible only when the configured folder is absent and no other possible old world folder remains; after a `level-name` change, Jarock refuses to start instead of silently replacing an existing world.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Show ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> Technical fallback note: Links In Chat is included in the pinned Fabric 26.2 server stack. It makes URLs in server chat clickable and adds `/link` and `/linkwhisper`; clients do not need to install it. Welcome Message 2.8 with its required Collective library is included as a verified server-side Minecraft 26.2 mod for Fabric and NeoForge; it sends configurable join messages. On the first Jarock-managed startup, Jarock applies its configured `welcomemessage.json5` template once and preserves later operator edits. As die templaat ontbreek (byvoorbeeld na 'n opdatering vanaf 'n ouer weergawe), herstel die bootstrap dit outomaties by opstart. Die opruimingskrip behou die nagespoorde template, en geverifieerde Lite-pakketopdaterings verfris dit. Geverifieerde Lite-pakketopdaterings vereis die templaat en installeer dit uit die pakket selfs wanneer dit nie onder die geinstalleerde serverlêr voorkom nie.
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Tegniese nota: Gebruik altyd die `start-server.bat` in die wortel van die repository. Moenie op `server.jar` dubbelklik nie; Windows kan Java 8 of Java 21 gebruik, terwyl Minecraft 26.2 64-bis Java 25+ vereis. Sien die [volledige Engelse gids](../en/server-guide.md).**



<!-- jarock-lan-addresses-af -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> InvView 1.4.21 is a verified Minecraft 26.2 server-side Fabric mod. It requires Fabric API and lets authorized operators inspect and manage online or offline player inventories and ender chests; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> OfflineCommands 1.0.3 is a verified Minecraft 26.2 server-side Fabric mod for running commands on offline players. No compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

<!-- jarock-safe-shutdown -->

## Veilige afsluiting

> Tik `stop` in die bedienerkonsole en laat die venster oop. Wag vir `CLEAN SHUTDOWN COMPLETE` en daarna `SAFE TO CLOSE` voordat jy dit sluit. As die tweede boodskap ontbreek, lees die log en crash-verslag en herstel ’n rugsteun indien nodig.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-world-transfer -->

## World import and export

> English note: parameter-manager.bat option `I` (Import world) accepts the full path of a world folder containing `level.dat` or of a `.zip` world archive; the world is imported on the next `start-server.bat` run. If the configured world already exists you are asked to confirm and it is backed up first as `<name>_originalbkp`. The parameter manager asks whether to remember the source with `(Y/n)`; Enter accepts the default Yes. When remembered, the source stays saved and is imported again at every start: Jarock asks for confirmation and first moves the existing world aside as `<name>_originalbkp` (with a timestamp suffix when that name is already taken), so the imported world replaces the active one after the operator confirms. An incomplete world folder (for example missing `level.dat` after a crash) is also replaced after confirmation, with a backup first. If not remembered, the request is cleared after the one-shot import. Option `E` (Export world) accepts a destination folder outside `server/`; after every clean shutdown (`stop` + `SAFE TO CLOSE`) the world is copied there, overwriting the destination.

> Icon note: Jarock uses the tracked root `icon.png` only as the default icon for a world that has no custom icon, and preserves imported or customized world icons. The tracked `server/icon.png` is included in the server runtime, while `server/server-icon.png` is the multiplayer server-list icon. All three tracked icons are included in every CLI and TUI release package. The cleanup script also preserves the two tracked server icons; the repository-root icon.png and logo.png remain outside its cleanup scope.

<!-- jarock-updater -->


## Jarock-bywerking

> Lees `scripts/version.txt`, stop die bediener en wag vir `SAFE TO CLOSE`; voer dan `scripts/update-jarock.bat` uit. Dit soek ’n nuwer vrystelling in dieselfde beta/stabiele kanaal, vra bevestiging en maak ’n terugrolrugsteun. Die wêreld, runtime, mods, biblioteke en plaaslike instellings bly behoue; afhanklikhede word net herstel as hulle ontbreek of ongeldig is.

> Die volledige pakket en sy gepubliseerde SHA-512-kontrolesom word voor installasie nagegaan.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Kontrole vir opdaterings tydens opstart

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified package matching scripts/jarock-edition.ini automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows-konsole-sluitbeskerming:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Tik stop en wag vir SAFE TO CLOSE. Moet nooit forseer sluit terwyl die wêreld gestoor word nie. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
