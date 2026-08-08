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

Startup update modes: AUTO_UPDATE_MODE=auto checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.
