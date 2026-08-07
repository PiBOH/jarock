# Guia de xarxa, tallafocs i router

Instal·la Java 25 de 64 bits, executa `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` i completa `TODO.md` abans d'obrir ports. Assigna una IP LAN fixa, obre TCP `25565` (Java) i UDP `19132` (Bedrock) al tallafocs de Windows, configura el reenviament de ports al router o utilitza un túnel UDP com playit.gg. Comprova `online-mode=true` i `white-list=true` i no publiquis mai `key.pem`. Per CGNAT, utilitza un túnel. Consulta la [guia canònica en anglès](../en/network-and-ports.md).

> Utilitza sempre `start-server.bat`; no facis doble clic a `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

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
