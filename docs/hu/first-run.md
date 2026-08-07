# A Jarock első indítása

## Loader kiválasztása

Telepíts 64 bites Java 25 vagy újabb JDK-t, a Temurin telepítőben engedélyezd a JAVA_HOME beállítást, majd nyisd meg újra a terminált. Mindig a gyökérben lévő `start-server.bat` en `scripts/server-launch-settings.ini` fájlt futtasd, és ne nyisd meg közvetlenül a `server/server.jar` fájlt.

## Telepítés és EULA

Futtasd a `start-server.bat` fájlt, majd válaszd a Fabricet (ajánlott), a NeoForge-ot (tartalék) vagy a Forge-ot (Minecraft 26.2-höz jelenleg nem érhető el). A `parameter-manager.bat` a RAM-ot, GUI/konzolt, GC-t, `online-mode`-ot, bannert és `AUTO_UPDATE_CHECK` értéket állítja. Az **Exit without saving** mentés nélkül megszakítja a műveletet.

## Biztonságos leállítás

A Jarock automatikusan letölti a loadert és a rögzített modokat. Az első futtatás létrehozza a `server/eula.txt` fájlt, majd leáll. Olvasd el a Minecraft EULA-t, és csak elfogadás után módosítsd az `eula=false` értéket `eula=true` értékre. Az első sikeres futtatás előtt ne használd az `online-mode=false` beállítást.

## Biztonságos leállítás

Indítsd újra, várd meg a világ, a Geyser és a Floodgate betöltését, írd be a `stop` parancsot, és várd meg a `CLEAN SHUTDOWN COMPLETE` és `SAFE TO CLOSE` üzeneteket. Hiba esetén kövesd a Suggested fix utasítást; kevert loaderek esetén készíts mentést és futtasd a `clean-server-runtime.bat` fájlt. Nyilvános hozzáférés előtt olvasd el a `TODO.md` fájlt.

## Biztonsági megjegyzés

Az első futtatást `online-mode=true` beállítással fejezd be a normál hitelesítéshez.

## Biztonsági megjegyzés

Frissítés telepítéséhez állítsd le biztonságosan a szervert, majd futtasd a `scripts/update-jarock.bat` fájlt.
