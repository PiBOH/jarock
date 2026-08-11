> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

# Primeiro arranque de Jarock

## Antes de comezar

Instala Java 25 ou posterior de 64 bits, activa JAVA_HOME no instalador Temurin e reabre o terminal. Usa sempre o `start-server.bat` situado na raíz; as configuracións locais gárdanse en `scripts/server-launch-settings.ini`. Non abras directamente `server/server.jar`.

## Selección do loader

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified package matching scripts/jarock-edition.ini automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## Instalación e EULA

Jarock descarga o loader e os mods fixados automaticamente. O primeiro arranque crea `server/eula.txt` e detense. Le a Minecraft EULA e cambia `eula=false` a `eula=true` só se aceptas. Non uses `online-mode=false` antes do primeiro arranque correcto.

## Parada segura

Reinicia, agarda polo mundo, Geyser e Floodgate, escribe `stop` e espera `CLEAN SHUTDOWN COMPLETE` e `SAFE TO CLOSE`. Segue Suggested fix ante erros; se mesturas loaders, fai unha copia e executa `clean-server-runtime.bat`. Le `TODO.md` antes de publicar.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## Nota de seguridade e actualizacións

Completa a primeira execución con `online-mode=true` para que a autenticación normal funcione. Para instalar unha actualización, detén o servidor con seguridade e executa `scripts/update-jarock.bat`.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-gl -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Protección contra o peche da consola de Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Escribe stop e agarda por SAFE TO CLOSE. Nunca forces o peche mentres se garda o mundo. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
