# Primo avvio di Jarock

## Prima di iniziare

Questa guida spiega il primo utilizzo di un repository Jarock appena scaricato. Usa sempre `start-server.bat` nella root e non aprire direttamente `server/server.jar`. Installa un JDK Java 25+ a 64 bit, attiva **Set JAVA_HOME variable** nell’installer Temurin e riapri il terminale.

## Scegliere il loader

Avvia `start-server.bat`. Jarock controlla Java, percorsi e `scripts/server-launch-settings.ini`, migrando le vecchie impostazioni. Scegli Fabric (consigliato), NeoForge (fallback) o Forge (attualmente non disponibile per Minecraft 26.2). `parameter-manager.bat` configura RAM, GUI/console, GC, `online-mode`, banner e `AUTO_UPDATE_CHECK`; **Exit without saving** annulla senza salvare.

## Installazione ed EULA

Il loader e le mod bloccate vengono scaricati automaticamente. Il primo avvio crea `server/eula.txt` e normalmente si ferma. Leggi la Minecraft EULA e cambia `eula=false` in `eula=true` solo se accetti. Non impostare `online-mode=false` prima del primo avvio riuscito: usa prima `online-mode=true`.

## Arresto sicuro

Avvia di nuovo `start-server.bat` e lascia completare mondo, Geyser e Floodgate. Per fermare il server scrivi `stop` e aspetta `CLEAN SHUTDOWN COMPLETE` e `SAFE TO CLOSE` prima di chiudere la finestra.

## Dopo il primo avvio

Se Java manca, installa Java 25 a 64 bit. In caso di errore segui Suggested fix. Se hai mescolato Fabric e NeoForge, fai un backup ed esegui `clean-server-runtime.bat`. Leggi `TODO.md` prima di rendere il server pubblico.

## Nota di sicurezza

Per installare un aggiornamento, arresta il server in modo sicuro ed esegui `scripts/update-jarock.bat`.
