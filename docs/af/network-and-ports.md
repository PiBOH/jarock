# Gids vir netwerk, firewall en router

Installeer 64-bis Java 25, voer `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` uit en voltooi `TODO.md` voordat jy poorte oopmaak. Ken 'n vaste LAN IP toe, maak TCP `25565` (Java) en UDP `19132` (Bedrock) in Windows Defender Firewall oop, stel poort-aanstuur op die router op of gebruik 'n UDP-versoenbare tonnel soos playit.gg. Maak seker `online-mode=true` en `white-list=true` is aan en publiseer nooit `key.pem` nie. Gebruik 'n tonnel vir CGNAT. Sien die [kanonieke Engelse gids](../en/network-and-ports.md).

> Gebruik altyd `start-server.bat`; moenie op `server.jar` dubbelklik nie.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

<!-- jarock-safe-shutdown -->

## Veilige afsluiting

> Tik `stop` in die bedienerkonsole en laat die venster oop. Wag vir `CLEAN SHUTDOWN COMPLETE` en daarna `SAFE TO CLOSE` voordat jy dit sluit. As die tweede boodskap ontbreek, lees die log en crash-verslag en herstel ’n rugsteun indien nodig.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

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
