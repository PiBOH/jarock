# První spuštění Jarock

## Než začnete

Tato příručka popisuje první použití čerstvého repozitáře Jarock. Vždy spusť kořenový `start-server.bat` a neotevírej přímo `server/server.jar`. Nainstaluj 64bitový JDK Java 25 nebo novější, v instalátoru Temurin povol **Set JAVA_HOME variable** a potom znovu otevři terminál.

## Výběr loaderu

Spusť `start-server.bat`. Jarock zkontroluje Javu, cesty a `scripts/server-launch-settings.ini` a případně automaticky přesune staré nastavení z kořene. Vyber Fabric (doporučeno), NeoForge (záložní volba) nebo Forge (pro Minecraft 26.2 momentálně není dostupný). `parameter-manager.bat` nastavuje RAM, GUI/konzoli, GC, `online-mode`, banner a `AUTO_UPDATE_CHECK`. **Exit without saving** zruší změny bez uložení.

## Instalace a EULA

Jarock automaticky stáhne vybraný loader a připnuté serverové mody. První spuštění vytvoří `server/eula.txt` a obvykle se zastaví. Přečti Minecraft EULA a pouze pokud souhlasíš změň `eula=false` na `eula=true`. Před prvním úspěšným spuštěním nenastavuj `online-mode=false`; první spuštění dokonči s `online-mode=true`.

## Bezpečné ukončení

Spusť `start-server.bat` znovu a nech dokončit tvorbu světa, Geyser a Floodgate. Pro ukončení napiš do konzole `stop` a okno nezavírej. Počkej na `CLEAN SHUTDOWN COMPLETE` a `SAFE TO CLOSE`, teprve potom okno zavři.

## Po prvním spuštění

Pokud Java chybí, nainstaluj 64bitovou Java 25 a znovu otevři terminál. Při chybě stahování použij Suggested fix a opakuj spuštění. Pokud se smíchal Fabric s NeoForge, zazálohuj svět a spusť `clean-server-runtime.bat`. Pro běžné použití ponech `online-mode=true` a před zveřejněním si přečti `TODO.md`.

## Bezpečnostní poznámka

Aktualizaci nainstaluješ tak, že server bezpečně zastavíš a spustíš `scripts/update-jarock.bat`.
