# Första starten av Jarock

## Välj loader

Installera ett 64-bitars Java 25+-JDK, aktivera JAVA_HOME i Temurin-installationen och öppna terminalen igen. Kör alltid rotens `start-server.bat` en `scripts/server-launch-settings.ini` och öppna inte `server/server.jar` direkt.

## Installation och EULA

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.

## Säker avstängning

Jarock laddar automatiskt ner loader och låsta mods. Första körningen skapar `server/eula.txt` och stoppas vanligtvis. Läs Minecraft EULA och ändra `eula=false` till `eula=true` bara om du godkänner. Använd inte `online-mode=false` före första lyckade körningen.

## Säker avstängning

Kör igen, vänta på värld, Geyser och Floodgate, skriv `stop` och vänta på `CLEAN SHUTDOWN COMPLETE` och `SAFE TO CLOSE`. Följ Suggested fix vid fel; om loaders blandats, säkerhetskopiera och kör `clean-server-runtime.bat`. Läs `TODO.md` före offentlig åtkomst.

## Säkerhetsinformation

Slutför den första körningen med `online-mode=true` så att normal autentisering fungerar.

## Säkerhetsinformation

Stoppa servern säkert och kör `scripts/update-jarock.bat` för att installera en uppdatering.

<!-- jarock-lan-addresses-sv -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.
