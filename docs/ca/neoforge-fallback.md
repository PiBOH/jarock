# Guia alternativa NeoForge

Usa NeoForge com a última opció si Fabric no serveix. Forge i NeoForge són loaders diferents; els mods han de ser NeoForge. Afegeix Geyser/Floodgate si cal i prova una còpia.

See the [English NeoForge fallback guide](../en/neoforge-fallback.md) for the complete procedure. Verify every mod against the selected loader.

<!-- jarock-safe-shutdown -->

## Aturada segura

> Escriu `stop` a la consola i deixa la finestra oberta. Espera `CLEAN SHUTDOWN COMPLETE` i després `SAFE TO CLOSE` abans de tancar-la. Si falta el segon missatge, revisa el registre i l’informe de fallada i restaura una còpia si cal.

<!-- jarock-updater -->


## Actualitzar Jarock

> Llegeix `scripts/version.txt`, atura el servidor i espera `SAFE TO CLOSE`; després executa `scripts/update-jarock.bat`. Cerca una versió més nova del mateix canal beta/estable, demana confirmació i crea una còpia de retorn. Conserva el món, el runtime, els mods, les biblioteques i la configuració local; només repara dependències absents o invàlides.

> El paquet complet i la seva suma de verificació SHA-512 publicada es comproven abans de la instal·lació.

<!-- jarock-auto-update-check -->

## Comprovació d'actualitzacions en iniciar

Estableix AUTO_UPDATE_CHECK=true a parameter-manager.bat perquè start-server.bat faci una comprovació de GitHub només de lectura. Informa d'una versió compatible més nova, però demana confirmació abans d’instal·lar. Tria y o escriu yes per instal·lar l’actualització Lite o N/Enter per continuar amb la versió actual. El valor predeterminat és AUTO_UPDATE_CHECK=false. When a compatible newer release is found at startup, Jarock asks `Download and install it now? (y/N)`; choose y to install the verified Lite package, or N/Enter to continue with the current version. It never updates silently.
