> Technical note: Async is an experimental server-side Minecraft 26.3 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

# Primo avvio di Jarock

## Prima di iniziare

Questa guida spiega il primo utilizzo di un repository Jarock appena scaricato. Usa sempre `start-server.bat` nella root e non aprire direttamente `server/server.jar`. Installa un JDK Java 25+ a 64 bit, attiva **Set JAVA_HOME variable** nell’installer Temurin e riapri il terminale.

## Scegliere il loader

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified package matching scripts/jarock-edition.ini automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## Installazione ed EULA

Il loader e le mod bloccate vengono scaricati automaticamente. Il primo avvio crea `server/eula.txt` e normalmente si ferma. Leggi la Minecraft EULA e cambia `eula=false` in `eula=true` solo se accetti. Non impostare `online-mode=false` prima del primo avvio riuscito: usa prima `online-mode=true`.

## Arresto sicuro

Avvia di nuovo `start-server.bat` e lascia completare mondo, Geyser e Floodgate. Per fermare il server scrivi `stop` e aspetta `CLEAN SHUTDOWN COMPLETE` e `SAFE TO CLOSE` prima di chiudere la finestra.
> Nota: quando viene rilevato il comando `stop`, Jarock avvisa che il mondo sta venendo salvato e poi stampa la conferma finale `SAFE TO CLOSE` direttamente nella console del server, appena il salvataggio è completo, sia in modalità `gui` sia `nogui`. Tieni la finestra aperta fino a quando non appare quel messaggio.

## Dopo il primo avvio

Se Java manca, installa Java 25 a 64 bit. In caso di errore segui Suggested fix. Se hai mescolato Fabric e NeoForge, fai un backup ed esegui `clean-server-runtime.bat`. Leggi `TODO.md` prima di rendere il server pubblico.

## Nota di sicurezza

Per installare un aggiornamento, arresta il server in modo sicuro ed esegui `scripts/update-jarock.bat`.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-it -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Protezione dalla chiusura della console Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Digita stop e attendi SAFE TO CLOSE. Non forzare la chiusura durante il salvataggio del mondo. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.

## Scegliere la versione di Minecraft

Jarock chiede la versione di Minecraft al primo avvio e salva la risposta in
`MINECRAFT_VERSION` dentro `scripts/jarock.ini`. Puoi cambiarla in seguito senza
avviare il server: lancia `parameter-manager.bat` e scegli
`M. Choose Minecraft version` (26.3 o 26.2), oppure modifica quella riga a mano.

`scripts/jarock.ini` è l'unico file di configurazione: contiene la versione del
progetto (`JAROCK_VERSION`) e tutte le impostazioni di lancio, quindi non c'è
nient'altro da modificare. Cambiando la linea di Minecraft, all'avvio successivo
vengono reinstallati loader, mod e datapack corrispondenti; il mondo e le altre
impostazioni non vengono mai sostituiti, ma fai un backup del mondo prima.
Jarock rifiuta di mescolare due linee di Minecraft nella stessa cartella server:
se la cartella esegue già un'altra linea, lancia prima
`clean-server-runtime.bat`.

Jarock accetta anche l'EULA di Minecraft per te: al primo avvio
`server/eula.txt` viene creato con `eula=true`. Leggi
https://www.minecraft.net/eula prima di tenere il server online.
