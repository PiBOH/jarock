> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

# Första starten av Jarock

## Välj loader

Installera ett 64-bitars Java 25+-JDK, aktivera JAVA_HOME i Temurin-installationen och öppna terminalen igen. Kör alltid rotens `start-server.bat` en `scripts/server-launch-settings.ini` och öppna inte `server/server.jar` direkt.

## Installation och EULA

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified package matching scripts/jarock-edition.ini automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## Säker avstängning

Jarock laddar automatiskt ner loader och låsta mods. Första körningen skapar `server/eula.txt` och stoppas vanligtvis. Läs Minecraft EULA och ändra `eula=false` till `eula=true` bara om du godkänner. Använd inte `online-mode=false` före första lyckade körningen.

## Säker avstängning

Kör igen, vänta på värld, Geyser och Floodgate, skriv `stop` och vänta på `CLEAN SHUTDOWN COMPLETE` och `SAFE TO CLOSE`. Följ Suggested fix vid fel; om loaders blandats, säkerhetskopiera och kör `clean-server-runtime.bat`. Läs `TODO.md` före offentlig åtkomst.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## Säkerhetsinformation

Slutför den första körningen med `online-mode=true` så att normal autentisering fungerar.

## Säkerhetsinformation

Stoppa servern säkert och kör `scripts/update-jarock.bat` för att installera en uppdatering.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-sv -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Skydd mot att stänga Windows-konsolen:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Skriv stop och vänta på SAFE TO CLOSE. Tvinga aldrig stängning medan världen sparas. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
