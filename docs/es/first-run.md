# Primer arranque de Jarock

## Antes de empezar

Esta guía explica el primer uso de un repositorio Jarock nuevo. Ejecuta siempre el `start-server.bat` de la raíz, no abras `server/server.jar` directamente, instala un JDK Java 25+ de 64 bits, activa **Set JAVA_HOME variable** en Temurin y vuelve a abrir el terminal.

## Elegir el loader

Startup update modes: AUTO_UPDATE_MODE=auto checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.

## Instalación y EULA

El loader y los mods fijados se descargan automáticamente. El primer arranque crea `server/eula.txt` y se detiene. Lee la Minecraft EULA y cambia `eula=false` a `eula=true` solo si aceptas. No uses `online-mode=false` antes del primer arranque correcto; usa primero `online-mode=true`.

## Apagado seguro

Ejecuta de nuevo `start-server.bat` y espera a que terminen el mundo, Geyser y Floodgate. Para detenerlo escribe `stop` y espera `CLEAN SHUTDOWN COMPLETE` y `SAFE TO CLOSE` antes de cerrar la ventana.

## Después del primer arranque

Si falta Java, instala Java 25 de 64 bits. Ante errores, sigue Suggested fix. Si se mezclan loaders, haz una copia y ejecuta `clean-server-runtime.bat`. Mantén `online-mode=true` y consulta `TODO.md` antes de publicar.

## Nota de seguridad

Para instalar una actualización, detén el servidor de forma segura y ejecuta `scripts/update-jarock.bat`.

<!-- jarock-lan-addresses-es -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.
