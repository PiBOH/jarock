# Primo avvio di Jarock

## Prima di iniziare

Questa guida spiega il primo utilizzo di un repository Jarock appena scaricato. Usa sempre `start-server.bat` nella root e non aprire direttamente `server/server.jar`. Installa un JDK Java 25+ a 64 bit, attiva **Set JAVA_HOME variable** nell’installer Temurin e riapri il terminale.

## Scegliere il loader

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.

## Installazione ed EULA

Il loader e le mod bloccate vengono scaricati automaticamente. Il primo avvio crea `server/eula.txt` e normalmente si ferma. Leggi la Minecraft EULA e cambia `eula=false` in `eula=true` solo se accetti. Non impostare `online-mode=false` prima del primo avvio riuscito: usa prima `online-mode=true`.

## Arresto sicuro

Avvia di nuovo `start-server.bat` e lascia completare mondo, Geyser e Floodgate. Per fermare il server scrivi `stop` e aspetta `CLEAN SHUTDOWN COMPLETE` e `SAFE TO CLOSE` prima di chiudere la finestra.

## Dopo il primo avvio

Se Java manca, installa Java 25 a 64 bit. In caso di errore segui Suggested fix. Se hai mescolato Fabric e NeoForge, fai un backup ed esegui `clean-server-runtime.bat`. Leggi `TODO.md` prima di rendere il server pubblico.

## Nota di sicurezza

Per installare un aggiornamento, arresta il server in modo sicuro ed esegui `scripts/update-jarock.bat`.

<!-- jarock-lan-addresses-it -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Protezione dalla chiusura della console Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Digita stop e attendi SAFE TO CLOSE. Non forzare la chiusura durante il salvataggio del mondo. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
