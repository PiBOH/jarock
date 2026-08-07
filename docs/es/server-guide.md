# Guía del servidor Fabric

Instala Java 25 de 64 bits, ejecuta `start-server.bat` y usa `parameter-manager.bat` para RAM y GUI o `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Lee `server/eula.txt` y cambia a `eula=true` solo después de aceptar la EULA. Usa Fabric, Geyser-Fabric y Floodgate-Fabric y crea copias de seguridad. Jarock no modifica router, firewall ni port forwarding.

See the [English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Show ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Nota técnica: Usa siempre `start-server.bat` en la raíz del repositorio. No hagas doble clic en `server.jar`; Windows puede usar Java 8 o Java 21, mientras que Minecraft 26.2 requiere Java 25+ de 64 bits. Consulta la [guía completa en inglés](../en/server-guide.md).**

<!-- jarock-safe-shutdown -->

## Apagado seguro

> Escribe `stop` y deja la ventana abierta. Antes de cerrarla, espera `CLEAN SHUTDOWN COMPLETE` y después `SAFE TO CLOSE`. Si falta el segundo mensaje, revisa el registro y el informe de error y restaura una copia si es necesario.

<!-- jarock-updater -->


## Actualizar Jarock

> Lee `scripts/version.txt`, detén el servidor y espera a `SAFE TO CLOSE`; después ejecuta `scripts/update-jarock.bat`. Busca una versión más nueva del mismo canal beta/estable, pide confirmación y crea una copia de rollback. Conserva el mundo, runtime, mods, bibliotecas y ajustes locales; solo repara dependencias ausentes o inválidas.

> El paquete completo y su suma de comprobación SHA-512 publicada se verifican antes de la instalación.

<!-- jarock-auto-update-check -->

## Comprobación de actualizaciones al iniciar

Establece AUTO_UPDATE_CHECK=true en parameter-manager.bat para que start-server.bat compruebe GitHub en modo de solo lectura. Informará de una versión compatible más reciente, pero pedirá confirmación antes de instalar. Elige Y para instalar la actualización Lite o N/Enter para continuar con la versión actual. El valor predeterminado es AUTO_UPDATE_CHECK=false. When a compatible newer release is found at startup, Jarock asks `Download and install it now? (y/N)`; choose y to install the verified Lite package, or N/Enter to continue with the current version. It never updates silently.
