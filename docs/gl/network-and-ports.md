# Guía de rede, firewall e router

Instala Java 25 de 64 bits, executa `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` e completa `TODO.md` antes de abrir portos. Asigna un IP LAN fixo, abre TCP `25565` (Java) e UDP `19132` (Bedrock) no firewall de Windows, configura o reenvío de portos no router ou usa un túnel UDP como playit.gg. Comproba `online-mode=true` e `white-list=true` e nunca publiques `key.pem`. Para CGNAT, usa un túnel. Consulta a [guía canónica en inglés](../en/network-and-ports.md).

> Usa sempre `start-server.bat`; non fagas dobre clic en `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Apagado seguro

> Escribe `stop` e deixa a xanela aberta. Agarda por `CLEAN SHUTDOWN COMPLETE` e despois `SAFE TO CLOSE` antes de pechala. Se falta a segunda mensaxe, revisa o rexistro e o informe de fallo e restaura unha copia se é preciso.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Actualizar Jarock

> Le `scripts/version.txt`, detén o servidor e agarda por `SAFE TO CLOSE`; despois executa `scripts/update-jarock.bat`. Busca unha versión máis nova da mesma canle beta/estable, pide confirmación e crea unha copia de recuperación. Conserva o mundo, runtime, mods, bibliotecas e configuración local; só repara dependencias ausentes ou inválidas.

> O paquete completo e a súa suma de comprobación SHA-512 publicada verifícanse antes da instalación.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Comprobación de actualizacións ao iniciar

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Protección contra o peche da consola de Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Escribe stop e agarda por SAFE TO CLOSE. Nunca forces o peche mentres se garda o mundo. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
