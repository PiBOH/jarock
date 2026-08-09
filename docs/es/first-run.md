# Primer arranque de Jarock

## Antes de empezar

Esta guía explica el primer uso de un repositorio Jarock nuevo. Ejecuta siempre el `start-server.bat` de la raíz, no abras `server/server.jar` directamente, instala un JDK Java 25+ de 64 bits, activa **Set JAVA_HOME variable** en Temurin y vuelve a abrir el terminal.

## Elegir el loader

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## Instalación y EULA

El loader y los mods fijados se descargan automáticamente. El primer arranque crea `server/eula.txt` y se detiene. Lee la Minecraft EULA y cambia `eula=false` a `eula=true` solo si aceptas. No uses `online-mode=false` antes del primer arranque correcto; usa primero `online-mode=true`.

## Apagado seguro

Ejecuta de nuevo `start-server.bat` y espera a que terminen el mundo, Geyser y Floodgate. Para detenerlo escribe `stop` y espera `CLEAN SHUTDOWN COMPLETE` y `SAFE TO CLOSE` antes de cerrar la ventana.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## Después del primer arranque

Si falta Java, instala Java 25 de 64 bits. Ante errores, sigue Suggested fix. Si se mezclan loaders, haz una copia y ejecuta `clean-server-runtime.bat`. Mantén `online-mode=true` y consulta `TODO.md` antes de publicar.

## Nota de seguridad

Para instalar una actualización, detén el servidor de forma segura y ejecuta `scripts/update-jarock.bat`.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-es -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Protección contra el cierre de la consola de Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Escribe stop y espera SAFE TO CLOSE. Nunca fuerces el cierre mientras se guarda el mundo. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
