# Primeiro arranque de Jarock

## Antes de comezar

Instala Java 25 ou posterior de 64 bits, activa JAVA_HOME no instalador Temurin e reabre o terminal. Usa sempre o `start-server.bat` situado na raíz; as configuracións locais gárdanse en `scripts/server-launch-settings.ini`. Non abras directamente `server/server.jar`.

## Selección do loader

Executa `start-server.bat` e escolle Fabric (recomendado), NeoForge (alternativa) ou Forge (non dispoñible actualmente para Minecraft 26.2). `parameter-manager.bat` configura RAM, GUI/consola, GC, `online-mode`, o banner e `AUTO_UPDATE_CHECK`. **Exit without saving** cancela sen gardar.

## Instalación e EULA

Jarock descarga o loader e os mods fixados automaticamente. O primeiro arranque crea `server/eula.txt` e detense. Le a Minecraft EULA e cambia `eula=false` a `eula=true` só se aceptas. Non uses `online-mode=false` antes do primeiro arranque correcto.

## Parada segura

Reinicia, agarda polo mundo, Geyser e Floodgate, escribe `stop` e espera `CLEAN SHUTDOWN COMPLETE` e `SAFE TO CLOSE`. Segue Suggested fix ante erros; se mesturas loaders, fai unha copia e executa `clean-server-runtime.bat`. Le `TODO.md` antes de publicar.

## Nota de seguridade e actualizacións

Completa a primeira execución con `online-mode=true` para que a autenticación normal funcione. Para instalar unha actualización, detén o servidor con seguridade e executa `scripts/update-jarock.bat`.
