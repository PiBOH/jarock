# První spuštění Jarock

## Než začnete

Tato příručka popisuje první použití čerstvého repozitáře Jarock. Vždy spusť kořenový `start-server.bat` a neotevírej přímo `server/server.jar`. Nainstaluj 64bitový JDK Java 25 nebo novější, v instalátoru Temurin povol **Set JAVA_HOME variable** a potom znovu otevři terminál.

## Výběr loaderu

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.

## Instalace a EULA

Jarock automaticky stáhne vybraný loader a připnuté serverové mody. První spuštění vytvoří `server/eula.txt` a obvykle se zastaví. Přečti Minecraft EULA a pouze pokud souhlasíš změň `eula=false` na `eula=true`. Před prvním úspěšným spuštěním nenastavuj `online-mode=false`; první spuštění dokonči s `online-mode=true`.

## Bezpečné ukončení

Spusť `start-server.bat` znovu a nech dokončit tvorbu světa, Geyser a Floodgate. Pro ukončení napiš do konzole `stop` a okno nezavírej. Počkej na `CLEAN SHUTDOWN COMPLETE` a `SAFE TO CLOSE`, teprve potom okno zavři.

## Po prvním spuštění

Pokud Java chybí, nainstaluj 64bitovou Java 25 a znovu otevři terminál. Při chybě stahování použij Suggested fix a opakuj spuštění. Pokud se smíchal Fabric s NeoForge, zazálohuj svět a spusť `clean-server-runtime.bat`. Pro běžné použití ponech `online-mode=true` a před zveřejněním si přečti `TODO.md`.

## Bezpečnostní poznámka

Aktualizaci nainstaluješ tak, že server bezpečně zastavíš a spustíš `scripts/update-jarock.bat`.

<!-- jarock-lan-addresses-cs -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.
