# Eerste start van Jarock

## Loader kiezen

Installeer een 64-bits Java 25+ JDK, activeer JAVA_HOME in de Temurin-installer en open de terminal opnieuw. Gebruik altijd `start-server.bat` en `scripts/server-launch-settings.ini` in de hoofdmap en open `server/server.jar` niet rechtstreeks.

## Installatie en EULA

Startup update modes: AUTO_UPDATE_MODE=auto checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.

## Veilig afsluiten

Jarock downloadt de loader en vastgezette mods automatisch. De eerste run maakt `server/eula.txt` en stopt meestal. Lees de Minecraft EULA en wijzig `eula=false` alleen bij akkoord naar `eula=true`. Gebruik `online-mode=false` niet vóór de eerste geslaagde run.

## Veilig afsluiten

Start opnieuw, wacht op wereld, Geyser en Floodgate, typ `stop` en wacht op `CLEAN SHUTDOWN COMPLETE` en `SAFE TO CLOSE`. Volg Suggested fix bij fouten; bij gemengde loaders maak je een back-up en voer je `clean-server-runtime.bat` uit. Lees `TODO.md` vóór publieke toegang.

## Veiligheidsopmerking

Voltooi de eerste run met `online-mode=true` zodat normale authenticatie werkt.

## Veiligheidsopmerking

Stop de server veilig en voer `scripts/update-jarock.bat` uit om een update te installeren.

<!-- jarock-lan-addresses-nl -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.
