# Průvodce sítí, firewallem a routerem

Nainstalujte 64bitovou Javu 25, spusťte `start-server.bat` a dokončete `TODO.md` před otevřením portů. Přidělte pevnou LAN IP, otevřete TCP `25565` (Java) a UDP `19132` (Bedrock) ve Windows Firewallu, nakonfigurujte přesměrování portů na routeru nebo použijte UDP tunel jako playit.gg. Zkontrolujte `online-mode=true` a `white-list=true` a nikdy nezveřejňujte `key.pem`. Pro CGNAT použijte tunel. Viz [kanonický anglický průvodce](../en/network-and-ports.md). (abilita Set JAVA_HOME nell’installer Temurin) (enable "Set JAVA_HOME variable" in the Temurin installer)

> Vždy používejte `start-server.bat`; neklikejte dvakrát na `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

<!-- jarock-safe-shutdown -->

## Bezpečné vypnutí

> Napište `stop` do konzole a nechte okno otevřené. Před zavřením počkejte na `CLEAN SHUTDOWN COMPLETE` a potom `SAFE TO CLOSE`. Pokud druhá zpráva chybí, zkontrolujte log a hlášení pádu a podle potřeby obnovte zálohu.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Aktualizace Jarock

> Přečtěte `scripts/version.txt`, zastavte server a počkejte na `SAFE TO CLOSE`; potom spusťte `scripts/update-jarock.bat`. Vyhledá novější verzi ve stejném beta/stabilním kanálu, vyžádá potvrzení a vytvoří zálohu pro návrat. Svět, runtime, mody, knihovny a místní nastavení zůstanou zachovány; závislosti se obnoví jen při chybění nebo neplatnosti.

> Úplný balíček a jeho zveřejněný kontrolní součet SHA-512 se před instalací ověří.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Kontrola aktualizací při spuštění

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified package matching scripts/jarock-edition.ini automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Ochrana před zavřením konzole Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Napište stop a počkejte na SAFE TO CLOSE. Při ukládání světa nikdy nevynucujte zavření. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
