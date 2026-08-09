# První spuštění Jarock

## Než začnete

Tato příručka popisuje první použití čerstvého repozitáře Jarock. Vždy spusť kořenový `start-server.bat` a neotevírej přímo `server/server.jar`. Nainstaluj 64bitový JDK Java 25 nebo novější, v instalátoru Temurin povol **Set JAVA_HOME variable** a potom znovu otevři terminál.

## Výběr loaderu

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## Instalace a EULA

Jarock automaticky stáhne vybraný loader a připnuté serverové mody. První spuštění vytvoří `server/eula.txt` a obvykle se zastaví. Přečti Minecraft EULA a pouze pokud souhlasíš změň `eula=false` na `eula=true`. Před prvním úspěšným spuštěním nenastavuj `online-mode=false`; první spuštění dokonči s `online-mode=true`.

## Bezpečné ukončení

Spusť `start-server.bat` znovu a nech dokončit tvorbu světa, Geyser a Floodgate. Pro ukončení napiš do konzole `stop` a okno nezavírej. Počkej na `CLEAN SHUTDOWN COMPLETE` a `SAFE TO CLOSE`, teprve potom okno zavři.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## Po prvním spuštění

Pokud Java chybí, nainstaluj 64bitovou Java 25 a znovu otevři terminál. Při chybě stahování použij Suggested fix a opakuj spuštění. Pokud se smíchal Fabric s NeoForge, zazálohuj svět a spusť `clean-server-runtime.bat`. Pro běžné použití ponech `online-mode=true` a před zveřejněním si přečti `TODO.md`.

## Bezpečnostní poznámka

Aktualizaci nainstaluješ tak, že server bezpečně zastavíš a spustíš `scripts/update-jarock.bat`.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-cs -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Ochrana před zavřením konzole Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Napište stop a počkejte na SAFE TO CLOSE. Při ukládání světa nikdy nevynucujte zavření. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
