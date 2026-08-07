# Första starten av Jarock

## Välj loader

Installera ett 64-bitars Java 25+-JDK, aktivera JAVA_HOME i Temurin-installationen och öppna terminalen igen. Kör alltid rotens `start-server.bat` en `scripts/server-launch-settings.ini` och öppna inte `server/server.jar` direkt.

## Installation och EULA

Kör `start-server.bat` och välj Fabric (rekommenderas), NeoForge (reserv) eller Forge (inte tillgängligt för Minecraft 26.2 just nu). `parameter-manager.bat` ställer in RAM, GUI/konsol, GC, `online-mode`, banner och `AUTO_UPDATE_CHECK`. **Exit without saving** avbryter utan att spara.

## Säker avstängning

Jarock laddar automatiskt ner loader och låsta mods. Första körningen skapar `server/eula.txt` och stoppas vanligtvis. Läs Minecraft EULA och ändra `eula=false` till `eula=true` bara om du godkänner. Använd inte `online-mode=false` före första lyckade körningen.

## Säker avstängning

Kör igen, vänta på värld, Geyser och Floodgate, skriv `stop` och vänta på `CLEAN SHUTDOWN COMPLETE` och `SAFE TO CLOSE`. Följ Suggested fix vid fel; om loaders blandats, säkerhetskopiera och kör `clean-server-runtime.bat`. Läs `TODO.md` före offentlig åtkomst.

## Säkerhetsinformation

Slutför den första körningen med `online-mode=true` så att normal autentisering fungerar.

## Säkerhetsinformation

Stoppa servern säkert och kör `scripts/update-jarock.bat` för att installera en uppdatering.
