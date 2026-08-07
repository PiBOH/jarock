# Guía alternativa de NeoForge

NeoForge es la última opción si Fabric no sirve. Forge y NeoForge son loaders distintos y los mods deben ser para NeoForge. Añade Geyser/Floodgate si hace falta y prueba primero una copia.

See the [English NeoForge fallback guide](../en/neoforge-fallback.md) for the complete procedure. Verify every mod against the selected loader.

<!-- jarock-safe-shutdown -->

## Apagado seguro

> Escribe `stop` y deja la ventana abierta. Antes de cerrarla, espera `CLEAN SHUTDOWN COMPLETE` y después `SAFE TO CLOSE`. Si falta el segundo mensaje, revisa el registro y el informe de error y restaura una copia si es necesario.

<!-- jarock-updater -->


## Actualizar Jarock

> Lee `scripts/version.txt`, detén el servidor y espera a `SAFE TO CLOSE`; después ejecuta `scripts/update-jarock.bat`. Busca una versión más nueva del mismo canal beta/estable, pide confirmación y crea una copia de rollback. Conserva el mundo, runtime, mods, bibliotecas y ajustes locales; solo repara dependencias ausentes o inválidas.

> El paquete completo y su suma de comprobación SHA-512 publicada se verifican antes de la instalación.

<!-- jarock-auto-update-check -->

## Comprobación de actualizaciones al iniciar

Establece AUTO_UPDATE_CHECK=true en parameter-manager.bat para que start-server.bat compruebe GitHub en modo de solo lectura. Informará de una versión compatible más reciente, pero pedirá confirmación antes de instalar. Elige y o escribe yes para instalar la actualización Lite o N/Enter para continuar con la versión actual. El valor predeterminado es AUTO_UPDATE_CHECK=false. When a compatible newer release is found at startup, Jarock asks `Download and install it now? (y/N)`; choose y to install the verified Lite package, or N/Enter to continue with the current version. It never updates silently.
