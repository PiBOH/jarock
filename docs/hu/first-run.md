# A Jarock első indítása

## Loader kiválasztása

Telepíts 64 bites Java 25 vagy újabb JDK-t, a Temurin telepítőben engedélyezd a JAVA_HOME beállítást, majd nyisd meg újra a terminált. Mindig a gyökérben lévő `start-server.bat` en `scripts/server-launch-settings.ini` fájlt futtasd, és ne nyisd meg közvetlenül a `server/server.jar` fájlt.

## Telepítés és EULA

Startup update modes: AUTO_UPDATE_MODE=auto checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.

## Biztonságos leállítás

A Jarock automatikusan letölti a loadert és a rögzített modokat. Az első futtatás létrehozza a `server/eula.txt` fájlt, majd leáll. Olvasd el a Minecraft EULA-t, és csak elfogadás után módosítsd az `eula=false` értéket `eula=true` értékre. Az első sikeres futtatás előtt ne használd az `online-mode=false` beállítást.

## Biztonságos leállítás

Indítsd újra, várd meg a világ, a Geyser és a Floodgate betöltését, írd be a `stop` parancsot, és várd meg a `CLEAN SHUTDOWN COMPLETE` és `SAFE TO CLOSE` üzeneteket. Hiba esetén kövesd a Suggested fix utasítást; kevert loaderek esetén készíts mentést és futtasd a `clean-server-runtime.bat` fájlt. Nyilvános hozzáférés előtt olvasd el a `TODO.md` fájlt.

## Biztonsági megjegyzés

Az első futtatást `online-mode=true` beállítással fejezd be a normál hitelesítéshez.

## Biztonsági megjegyzés

Frissítés telepítéséhez állítsd le biztonságosan a szervert, majd futtasd a `scripts/update-jarock.bat` fájlt.

<!-- jarock-lan-addresses-hu -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.
