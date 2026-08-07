# Eerste start van Jarock

## Loader kiezen

Installeer een 64-bits Java 25+ JDK, activeer JAVA_HOME in de Temurin-installer en open de terminal opnieuw. Gebruik altijd `start-server.bat` en `scripts/server-launch-settings.ini` in de hoofdmap en open `server/server.jar` niet rechtstreeks.

## Installatie en EULA

Start `start-server.bat` en kies Fabric (aanbevolen), NeoForge (fallback) of Forge (momenteel niet beschikbaar voor Minecraft 26.2). `parameter-manager.bat` stelt RAM, GUI/console, GC, `online-mode`, banner en `AUTO_UPDATE_CHECK` in. **Exit without saving** annuleert zonder op te slaan.

## Veilig afsluiten

Jarock downloadt de loader en vastgezette mods automatisch. De eerste run maakt `server/eula.txt` en stopt meestal. Lees de Minecraft EULA en wijzig `eula=false` alleen bij akkoord naar `eula=true`. Gebruik `online-mode=false` niet vóór de eerste geslaagde run.

## Veilig afsluiten

Start opnieuw, wacht op wereld, Geyser en Floodgate, typ `stop` en wacht op `CLEAN SHUTDOWN COMPLETE` en `SAFE TO CLOSE`. Volg Suggested fix bij fouten; bij gemengde loaders maak je een back-up en voer je `clean-server-runtime.bat` uit. Lees `TODO.md` vóór publieke toegang.

## Veiligheidsopmerking

Voltooi de eerste run met `online-mode=true` zodat normale authenticatie werkt.

## Veiligheidsopmerking

Stop de server veilig en voer `scripts/update-jarock.bat` uit om een update te installeren.
