# Guida a rete, firewall e router

Installa Java 25 a 64 bit (abilita "Set JAVA_HOME variable" nell'installer Temurin), esegui `start-server.bat` e completa `TODO.md` prima di aprire le porte. Assegna un IP LAN statico, apri TCP `25565` (Java) e UDP `19132` (Bedrock) nel firewall di Windows, configura il port forwarding sul router oppure usa un tunnel compatibile UDP come playit.gg. Assicurati che `online-mode=true` e `white-list=true` siano attivi e non pubblicare mai `key.pem`. In caso di CGNAT, usa un tunnel. Vedi la [guida canonica in inglese](../en/network-and-ports.md).

> Usa sempre `start-server.bat`; non fare doppio clic su `server.jar`.

<!-- jarock-safe-shutdown -->

## Arresto sicuro

> Scrivi `stop` nella console e lascia aperta la finestra. Prima di chiuderla attendi `CLEAN SHUTDOWN COMPLETE` e poi `SAFE TO CLOSE`. Se il secondo messaggio non compare, controlla log e crash report e ripristina un backup se necessario.

<!-- jarock-updater -->


## Aggiornare Jarock

> Leggi `version.txt`, arresta il server e attendi `SAFE TO CLOSE`; poi esegui `update-jarock.bat`. Cerca una release più recente nello stesso canale beta/stabile, chiede conferma e crea un backup per il rollback. Mondo, runtime, mod, librerie e impostazioni locali vengono preservati; le dipendenze vengono riscaricate solo se mancanti o non valide.

> Il pacchetto completo e il relativo checksum SHA-512 pubblicato vengono verificati prima dell'installazione.
