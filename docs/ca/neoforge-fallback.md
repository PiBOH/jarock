# Guia alternativa NeoForge

Usa NeoForge com a última opció si Fabric no serveix. Forge i NeoForge són loaders diferents; els mods han de ser NeoForge. Afegeix Geyser/Floodgate si cal i prova una còpia.

See the [English NeoForge fallback guide](../en/neoforge-fallback.md) for the complete procedure. Verify every mod against the selected loader.

<!-- jarock-safe-shutdown -->

## Aturada segura

> Escriu `stop` a la consola i deixa la finestra oberta. Espera `CLEAN SHUTDOWN COMPLETE` i després `SAFE TO CLOSE` abans de tancar-la. Si falta el segon missatge, revisa el registre i l’informe de fallada i restaura una còpia si cal.

<!-- jarock-updater -->


## Actualitzar Jarock

> Llegeix `version.txt`, atura el servidor i espera `SAFE TO CLOSE`; després executa `update-jarock.bat`. Cerca una versió més nova del mateix canal beta/estable, demana confirmació i crea una còpia de retorn. Conserva el món, el runtime, els mods, les biblioteques i la configuració local; només repara dependències absents o invàlides.

> El paquet complet i la seva suma de verificació SHA-512 publicada es comproven abans de la instal·lació.
