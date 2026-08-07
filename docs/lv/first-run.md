# Jarock pirmā palaišana

## Loader izvēle

Instalējiet 64 bitu Java 25 vai jaunāku JDK, Temurin instalētājā ieslēdziet JAVA_HOME un no jauna atveriet termināli. Vienmēr palaidiet saknes `start-server.bat` en `scripts/server-launch-settings.ini` un neatveriet `server/server.jar` tieši.

## Instalēšana un EULA

Palaidiet `start-server.bat` un izvēlieties Fabric (ieteicams), NeoForge (rezerves variants) vai Forge (Minecraft 26.2 pašlaik nav pieejams). `parameter-manager.bat` konfigurē RAM, GUI/konsole režīmu, GC, `online-mode`, reklāmkarogu un `AUTO_UPDATE_CHECK`. **Exit without saving** atceļ bez saglabāšanas.

## Droša apturēšana

Jarock automātiski lejupielādē loader un piespraustos mod. Pirmā palaišana izveido `server/eula.txt` un parasti apstājas. Izlasiet Minecraft EULA un mainiet `eula=false` uz `eula=true` tikai pēc piekrišanas. Pirms pirmās veiksmīgās palaišanas neizmantojiet `online-mode=false`.

## Droša apturēšana

Palaidiet vēlreiz, gaidiet world, Geyser un Floodgate pabeigšanu, ievadiet `stop` un gaidiet `CLEAN SHUTDOWN COMPLETE` un `SAFE TO CLOSE`. Kļūdas gadījumā sekojiet Suggested fix; ja loader sajaukti, dublējiet pasauli un palaidiet `clean-server-runtime.bat`. Pirms publiskas piekļuves izlasiet `TODO.md`.

## Drošības piezīme

Pabeidziet pirmo palaišanu ar `online-mode=true`, lai darbotos parastā autentifikācija.

## Drošības piezīme

Lai instalētu atjauninājumu, droši apturiet serveri un palaidiet `scripts/update-jarock.bat`.
