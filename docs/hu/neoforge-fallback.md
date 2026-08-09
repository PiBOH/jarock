# NeoForge tartalék útmutató

A NeoForge csak végső tartalék, ha a Fabric nem megfelelő. A Forge és a NeoForge külön loader, a modoknak NeoForge-kompatibilisnek kell lenniük; szükség esetén használjon Geyser/Floodgate-et, és előbb másolaton teszteljen.

Olvassa a teljes angol útmutatót: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## Biztonságos leállítás

> Írja be a `stop` parancsot, és hagyja nyitva az ablakot. Bezárás előtt várja meg a `CLEAN SHUTDOWN COMPLETE`, majd a `SAFE TO CLOSE` üzenetet. Ha a második üzenet hiányzik, ellenőrizze a naplót és a hibajelentést, szükség esetén állítsa vissza a mentést.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Jarock frissítése

> Olvassa el a `scripts/version.txt` fájlt, állítsa le a szervert, és várja meg a `SAFE TO CLOSE` üzenetet; ezután futtassa az `scripts/update-jarock.bat` fájlt. Azonos béta/stabil csatornán keres újabb verziót, megerősítést kér és visszaállítási mentést készít. A világ, a runtime, a modok, a könyvtárak és a helyi beállítások megmaradnak; a függőségeket csak hiány vagy érvénytelenség esetén javítja.

> A teljes csomag és a hozzá közzétett SHA-512 ellenőrzőösszeg telepítés előtt ellenőrzésre kerül.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Frissítések ellenőrzése indításkor

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows-konzolabezárás elleni védelem:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Írja be a stop parancsot, és várjon a SAFE TO CLOSE üzenetre. Mentés közben ne kényszerítse a bezárást. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
