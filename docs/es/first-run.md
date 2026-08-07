# Primer arranque de Jarock

## Antes de empezar

Esta guía explica el primer uso de un repositorio Jarock nuevo. Ejecuta siempre el `start-server.bat` de la raíz, no abras `server/server.jar` directamente, instala un JDK Java 25+ de 64 bits, activa **Set JAVA_HOME variable** en Temurin y vuelve a abrir el terminal.

## Elegir el loader

Ejecuta `start-server.bat`. Jarock comprueba Java, rutas y `scripts/server-launch-settings.ini`, migra la configuración antigua y permite elegir Fabric (recomendado), NeoForge (alternativa) o Forge (no disponible actualmente para Minecraft 26.2). Usa `parameter-manager.bat` para RAM, GUI/consola, GC, `online-mode`, banner y `AUTO_UPDATE_CHECK`; **Exit without saving** cancela sin guardar.

## Instalación y EULA

El loader y los mods fijados se descargan automáticamente. El primer arranque crea `server/eula.txt` y se detiene. Lee la Minecraft EULA y cambia `eula=false` a `eula=true` solo si aceptas. No uses `online-mode=false` antes del primer arranque correcto; usa primero `online-mode=true`.

## Apagado seguro

Ejecuta de nuevo `start-server.bat` y espera a que terminen el mundo, Geyser y Floodgate. Para detenerlo escribe `stop` y espera `CLEAN SHUTDOWN COMPLETE` y `SAFE TO CLOSE` antes de cerrar la ventana.

## Después del primer arranque

Si falta Java, instala Java 25 de 64 bits. Ante errores, sigue Suggested fix. Si se mezclan loaders, haz una copia y ejecuta `clean-server-runtime.bat`. Mantén `online-mode=true` y consulta `TODO.md` antes de publicar.

## Nota de seguridad

Para instalar una actualización, detén el servidor de forma segura y ejecuta `scripts/update-jarock.bat`.
