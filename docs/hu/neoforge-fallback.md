# NeoForge tartalék útmutató

A NeoForge csak végső tartalék, ha a Fabric nem megfelelő. A Forge és a NeoForge külön loader, a modoknak NeoForge-kompatibilisnek kell lenniük; szükség esetén használjon Geyser/Floodgate-et, és előbb másolaton teszteljen.

Olvassa a teljes angol útmutatót: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## Biztonságos leállítás

> Írja be a `stop` parancsot, és hagyja nyitva az ablakot. Bezárás előtt várja meg a `CLEAN SHUTDOWN COMPLETE`, majd a `SAFE TO CLOSE` üzenetet. Ha a második üzenet hiányzik, ellenőrizze a naplót és a hibajelentést, szükség esetén állítsa vissza a mentést.

<!-- jarock-updater -->


## Jarock frissítése

> Olvassa el a `scripts/version.txt` fájlt, állítsa le a szervert, és várja meg a `SAFE TO CLOSE` üzenetet; ezután futtassa az `scripts/update-jarock.bat` fájlt. Azonos béta/stabil csatornán keres újabb verziót, megerősítést kér és visszaállítási mentést készít. A világ, a runtime, a modok, a könyvtárak és a helyi beállítások megmaradnak; a függőségeket csak hiány vagy érvénytelenség esetén javítja.

> A teljes csomag és a hozzá közzétett SHA-512 ellenőrzőösszeg telepítés előtt ellenőrzésre kerül.

<!-- jarock-auto-update-check -->

## Frissítések ellenőrzése indításkor

Állítsd AUTO_UPDATE_CHECK=true értékre a parameter-manager.bat fájlban, hogy a start-server.bat csak olvasási GitHub-ellenőrzést végezzen. Jelzi a kompatibilis újabb verziót, de nem telepít automatikusan. Állítsd le biztonságosan a szervert, várd meg a SAFE TO CLOSE üzenetet, majd futtasd az scripts/update-jarock.bat fájlt. Az alapérték AUTO_UPDATE_CHECK=false. When a compatible newer release is found at startup, Jarock asks `Download and install it now? (y/N)`; choose y to install the verified Lite package, or N/Enter to continue with the current version. It never updates silently.
