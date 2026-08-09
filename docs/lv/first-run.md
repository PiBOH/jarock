# Jarock pirmā palaišana

## Loader izvēle

Instalējiet 64 bitu Java 25 vai jaunāku JDK, Temurin instalētājā ieslēdziet JAVA_HOME un no jauna atveriet termināli. Vienmēr palaidiet saknes `start-server.bat` en `scripts/server-launch-settings.ini` un neatveriet `server/server.jar` tieši.

## Instalēšana un EULA

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## Droša apturēšana

Jarock automātiski lejupielādē loader un piespraustos mod. Pirmā palaišana izveido `server/eula.txt` un parasti apstājas. Izlasiet Minecraft EULA un mainiet `eula=false` uz `eula=true` tikai pēc piekrišanas. Pirms pirmās veiksmīgās palaišanas neizmantojiet `online-mode=false`.

## Droša apturēšana

Palaidiet vēlreiz, gaidiet world, Geyser un Floodgate pabeigšanu, ievadiet `stop` un gaidiet `CLEAN SHUTDOWN COMPLETE` un `SAFE TO CLOSE`. Kļūdas gadījumā sekojiet Suggested fix; ja loader sajaukti, dublējiet pasauli un palaidiet `clean-server-runtime.bat`. Pirms publiskas piekļuves izlasiet `TODO.md`.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## Drošības piezīme

Pabeidziet pirmo palaišanu ar `online-mode=true`, lai darbotos parastā autentifikācija.

## Drošības piezīme

Lai instalētu atjauninājumu, droši apturiet serveri un palaidiet `scripts/update-jarock.bat`.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to run the same check without starting the server. If a verified compatible Lite package is available, the updater asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-lv -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Windows konsoles aizvēršanas aizsardzība:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Ierakstiet stop un gaidiet SAFE TO CLOSE. Nepiespiediet aizvēršanu pasaules saglabāšanas laikā. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
