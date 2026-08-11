> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

# Prvi zagon Jarocka

## Izbira loaderja

Namestite 64-bitni JDK Java 25 ali novejši, v namestitvenem programu Temurin omogočite JAVA_HOME in znova odprite terminal. Vedno zaženite korenski `start-server.bat` en `scripts/server-launch-settings.ini` in ne odpirajte neposredno `server/server.jar`.

## Namestitev in EULA

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified package matching scripts/jarock-edition.ini automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## Varna zaustavitev

Jarock samodejno prenese loader in pripete mode. Prvi zagon ustvari `server/eula.txt` in se običajno ustavi. Preberite Minecraft EULA in spremenite `eula=false` v `eula=true` le, če se strinjate. Pred prvim uspešnim zagonom ne uporabljajte `online-mode=false`.

## Varna zaustavitev

Znova zaženite, počakajte na svet, Geyser in Floodgate, vnesite `stop` ter počakajte `CLEAN SHUTDOWN COMPLETE` in `SAFE TO CLOSE`. Pri napaki sledite Suggested fix; pri pomešanih loaderjih naredite varnostno kopijo in zaženite `clean-server-runtime.bat`. Pred javnim dostopom preberite `TODO.md`.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## Varnostna opomba

Prvi zagon dokončajte z `online-mode=true`, da bo običajno preverjanje pristnosti delovalo.

## Varnostna opomba

Za namestitev posodobitve varno ustavite strežnik in zaženite `scripts/update-jarock.bat`.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-sl -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Zaščita pred zapiranjem konzole Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Vnesite stop in počakajte na SAFE TO CLOSE. Med shranjevanjem sveta ne zapirajte prisilno. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
