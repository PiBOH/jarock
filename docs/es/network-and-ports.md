# Guía de red, firewall y router

Instala Java 25 de 64 bits, ejecuta `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` y completa `TODO.md` antes de abrir puertos. Asigna una IP LAN fija, abre TCP `25565` (Java) y UDP `19132` (Bedrock) en el firewall de Windows, configura el reenvío de puertos en el router o usa un túnel UDP como playit.gg. Comprueba que `online-mode=true` y `white-list=true`, y nunca publiques `key.pem`. Si tienes CGNAT, usa un túnel. Consulta la [guía canónica en inglés](../en/network-and-ports.md).

> Usa siempre `start-server.bat`; no hagas doble clic en `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

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
