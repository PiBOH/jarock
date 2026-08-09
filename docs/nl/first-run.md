# Eerste start van Jarock

## Loader kiezen

Installeer een 64-bits Java 25+ JDK, activeer JAVA_HOME in de Temurin-installer en open de terminal opnieuw. Gebruik altijd `start-server.bat` en `scripts/server-launch-settings.ini` in de hoofdmap en open `server/server.jar` niet rechtstreeks.

## Installatie en EULA

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## Veilig afsluiten

Jarock downloadt de loader en vastgezette mods automatisch. De eerste run maakt `server/eula.txt` en stopt meestal. Lees de Minecraft EULA en wijzig `eula=false` alleen bij akkoord naar `eula=true`. Gebruik `online-mode=false` niet vóór de eerste geslaagde run.

## Veilig afsluiten

Start opnieuw, wacht op wereld, Geyser en Floodgate, typ `stop` en wacht op `CLEAN SHUTDOWN COMPLETE` en `SAFE TO CLOSE`. Volg Suggested fix bij fouten; bij gemengde loaders maak je een back-up en voer je `clean-server-runtime.bat` uit. Lees `TODO.md` vóór publieke toegang.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## Veiligheidsopmerking

Voltooi de eerste run met `online-mode=true` zodat normale authenticatie werkt.

## Veiligheidsopmerking

Stop de server veilig en voer `scripts/update-jarock.bat` uit om een update te installeren.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to run the same check without starting the server. If a verified compatible Lite package is available, the updater asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-nl -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Bescherming tegen het sluiten van de Windows-console:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Typ stop en wacht op SAFE TO CLOSE. Forceer nooit het sluiten tijdens het opslaan van de wereld. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
