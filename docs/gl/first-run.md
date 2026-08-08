# Primeiro arranque de Jarock

## Antes de comezar

Instala Java 25 ou posterior de 64 bits, activa JAVA_HOME no instalador Temurin e reabre o terminal. Usa sempre o `start-server.bat` situado na raíz; as configuracións locais gárdanse en `scripts/server-launch-settings.ini`. Non abras directamente `server/server.jar`.

## Selección do loader

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.

## Instalación e EULA

Jarock descarga o loader e os mods fixados automaticamente. O primeiro arranque crea `server/eula.txt` e detense. Le a Minecraft EULA e cambia `eula=false` a `eula=true` só se aceptas. Non uses `online-mode=false` antes do primeiro arranque correcto.

## Parada segura

Reinicia, agarda polo mundo, Geyser e Floodgate, escribe `stop` e espera `CLEAN SHUTDOWN COMPLETE` e `SAFE TO CLOSE`. Segue Suggested fix ante erros; se mesturas loaders, fai unha copia e executa `clean-server-runtime.bat`. Le `TODO.md` antes de publicar.

## Nota de seguridade e actualizacións

Completa a primeira execución con `online-mode=true` para que a autenticación normal funcione. Para instalar unha actualización, detén o servidor con seguridade e executa `scripts/update-jarock.bat`.

<!-- jarock-lan-addresses-gl -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.
