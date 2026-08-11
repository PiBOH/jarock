# Guida a rete, firewall e router

Installa Java 25 a 64 bit (abilita "Set JAVA_HOME variable" nell'installer Temurin), esegui `start-server.bat` e completa `TODO.md` prima di aprire le porte. Assegna un IP LAN statico, apri TCP `25565` (Java) e UDP `19132` (Bedrock) nel firewall di Windows, configura il port forwarding sul router oppure usa un tunnel compatibile UDP come playit.gg. Assicurati che `online-mode=true` e `white-list=true` siano attivi e non pubblicare mai `key.pem`. In caso di CGNAT, usa un tunnel. Vedi la [guida canonica in inglese](../en/network-and-ports.md).

> Usa sempre `start-server.bat`; non fare doppio clic su `server.jar`.

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

<!-- jarock-safe-shutdown -->

## Arresto sicuro

> Scrivi `stop` nella console e lascia aperta la finestra. Prima di chiuderla attendi `CLEAN SHUTDOWN COMPLETE` e poi `SAFE TO CLOSE`. Se il secondo messaggio non compare, controlla log e crash report e ripristina un backup se necessario.
> Nota: quando viene rilevato il comando `stop`, Jarock avvisa che il mondo sta venendo salvato e poi stampa la conferma finale `SAFE TO CLOSE` direttamente nella console del server, appena il salvataggio è completo, sia in modalità `gui` sia `nogui`. Tieni la finestra aperta fino a quando non appare quel messaggio.

<!-- jarock-updater -->


## Aggiornare Jarock

> Leggi `scripts/version.txt`, arresta il server e attendi `SAFE TO CLOSE`; poi esegui `scripts/update-jarock.bat`. Cerca una release più recente nello stesso canale beta/stabile, chiede conferma e crea un backup per il rollback. Mondo, runtime, mod, librerie e impostazioni locali vengono preservati; le dipendenze vengono riscaricate solo se mancanti o non valide.

> Il pacchetto completo e il relativo checksum SHA-512 pubblicato vengono verificati prima dell'installazione.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Controllo aggiornamenti all'avvio

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Protezione dalla chiusura della console Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Digita stop e attendi SAFE TO CLOSE. Non forzare la chiusura durante il salvataggio del mondo. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
