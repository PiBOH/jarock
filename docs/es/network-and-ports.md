# Guía de red, firewall y router

Instala Java 25 de 64 bits, ejecuta `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` y completa `TODO.md` antes de abrir puertos. Asigna una IP LAN fija, abre TCP `25565` (Java) y UDP `19132` (Bedrock) en el firewall de Windows, configura el reenvío de puertos en el router o usa un túnel UDP como playit.gg. Comprueba que `online-mode=true` y `white-list=true`, y nunca publiques `key.pem`. Si tienes CGNAT, usa un túnel. Consulta la [guía canónica en inglés](../en/network-and-ports.md).

> Usa siempre `start-server.bat`; no hagas doble clic en `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Apagado seguro

> Escribe `stop` y deja la ventana abierta. Antes de cerrarla, espera `CLEAN SHUTDOWN COMPLETE` y después `SAFE TO CLOSE`. Si falta el segundo mensaje, revisa el registro y el informe de error y restaura una copia si es necesario.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Actualizar Jarock

> Lee `scripts/version.txt`, detén el servidor y espera a `SAFE TO CLOSE`; después ejecuta `scripts/update-jarock.bat`. Busca una versión más nueva del mismo canal beta/estable, pide confirmación y crea una copia de rollback. Conserva el mundo, runtime, mods, bibliotecas y ajustes locales; solo repara dependencias ausentes o inválidas.

> El paquete completo y su suma de comprobación SHA-512 publicada se verifican antes de la instalación.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Comprobación de actualizaciones al iniciar

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Protección contra el cierre de la consola de Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Escribe stop y espera SAFE TO CLOSE. Nunca fuerces el cierre mientras se guarda el mundo. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
