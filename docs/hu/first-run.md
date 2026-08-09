# A Jarock első indítása

## Loader kiválasztása

Telepíts 64 bites Java 25 vagy újabb JDK-t, a Temurin telepítőben engedélyezd a JAVA_HOME beállítást, majd nyisd meg újra a terminált. Mindig a gyökérben lévő `start-server.bat` en `scripts/server-launch-settings.ini` fájlt futtasd, és ne nyisd meg közvetlenül a `server/server.jar` fájlt.

## Telepítés és EULA

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## Biztonságos leállítás

A Jarock automatikusan letölti a loadert és a rögzített modokat. Az első futtatás létrehozza a `server/eula.txt` fájlt, majd leáll. Olvasd el a Minecraft EULA-t, és csak elfogadás után módosítsd az `eula=false` értéket `eula=true` értékre. Az első sikeres futtatás előtt ne használd az `online-mode=false` beállítást.

## Biztonságos leállítás

Indítsd újra, várd meg a világ, a Geyser és a Floodgate betöltését, írd be a `stop` parancsot, és várd meg a `CLEAN SHUTDOWN COMPLETE` és `SAFE TO CLOSE` üzeneteket. Hiba esetén kövesd a Suggested fix utasítást; kevert loaderek esetén készíts mentést és futtasd a `clean-server-runtime.bat` fájlt. Nyilvános hozzáférés előtt olvasd el a `TODO.md` fájlt.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## Biztonsági megjegyzés

Az első futtatást `online-mode=true` beállítással fejezd be a normál hitelesítéshez.

## Biztonsági megjegyzés

Frissítés telepítéséhez állítsd le biztonságosan a szervert, majd futtasd a `scripts/update-jarock.bat` fájlt.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-hu -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Windows-konzolabezárás elleni védelem:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Írja be a stop parancsot, és várjon a SAFE TO CLOSE üzenetre. Mentés közben ne kényszerítse a bezárást. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
