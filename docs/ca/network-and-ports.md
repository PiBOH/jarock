# Guia de xarxa, tallafocs i router

Instal·la Java 25 de 64 bits, executa `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` i completa `TODO.md` abans d'obrir ports. Assigna una IP LAN fixa, obre TCP `25565` (Java) i UDP `19132` (Bedrock) al tallafocs de Windows, configura el reenviament de ports al router o utilitza un túnel UDP com playit.gg. Comprova `online-mode=true` i `white-list=true` i no publiquis mai `key.pem`. Per CGNAT, utilitza un túnel. Consulta la [guia canònica en anglès](../en/network-and-ports.md).

> Utilitza sempre `start-server.bat`; no facis doble clic a `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Aturada segura

> Escriu `stop` a la consola i deixa la finestra oberta. Espera `CLEAN SHUTDOWN COMPLETE` i després `SAFE TO CLOSE` abans de tancar-la. Si falta el segon missatge, revisa el registre i l’informe de fallada i restaura una còpia si cal.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Actualitzar Jarock

> Llegeix `scripts/version.txt`, atura el servidor i espera `SAFE TO CLOSE`; després executa `scripts/update-jarock.bat`. Cerca una versió més nova del mateix canal beta/estable, demana confirmació i crea una còpia de retorn. Conserva el món, el runtime, els mods, les biblioteques i la configuració local; només repara dependències absents o invàlides.

> El paquet complet i la seva suma de verificació SHA-512 publicada es comproven abans de la instal·lació.

<!-- jarock-auto-update-check -->

## Comprovació d'actualitzacions en iniciar

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Protecció contra el tancament de la consola de Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Escriu stop i espera SAFE TO CLOSE. No forcis el tancament mentre es desa el món. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
