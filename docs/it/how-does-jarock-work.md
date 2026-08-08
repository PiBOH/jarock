# Come funziona Jarock?

## Spiegazione semplice del server

**Minecraft:** Java Edition `26.2`
**Loader:** Fabric
**Piattaforma principale:** Windows 10/11

Questo documento spiega cosa succede dopo aver scaricato Jarock.

## 1. In breve

L'utente deve:

1. Installare un JDK Java 25 a 64 bit compatibile. **Se usi l'installer Eclipse Temurin:** durante l'installazione, attiva l'opzione "Set JAVA_HOME variable" (clicca sull'icona con la X rossa e seleziona "Will be installed on local hard drive"). Senza `JAVA_HOME`, Jarock e il server potrebbero non trovare Java.
2. Scaricare o clonare il repository.
3. Avviare `start-server.bat`.
4. Il programma trova automaticamente la propria cartella.
5. PowerShell controlla Java, il percorso e i file del repository.
6. Se necessario, viene richiesto di abilitare i percorsi lunghi di Windows.
7. Vengono scaricati Fabric e le mod bloccate nel manifest.
8. Ogni download viene verificato con SHA-512. DedicatedPower è l'eccezione: è una mod solo per Fabric, aggiornata automaticamente all'ultima release GitHub e dimensione e checksum vengono verificati dopo il download.
9. Fabric crea il runtime in `server/`.
10. Il primo avvio crea `server/eula.txt` e si ferma.
11. Dopo aver impostato `eula=true`, un nuovo avvio parte normalmente.
12. Geyser traduce il traffico Bedrock e Floodgate gestisce l'autenticazione Bedrock.

Jarock **non** configura router, firewall o port forwarding. Avvia sempre questo repository con `start-server.bat`: non fare doppio clic su `server/server.jar`, perché Windows può associarlo a Java 8 o Java 21 e produrre `UnsupportedClassVersionError`.

## 2. Repository e runtime

Il repository contiene script, template e manifest; non contiene il mondo né i `.jar` generati. I file principali sono:

```text
start-server.bat
scripts/bootstrap-server.ps1
scripts/java-runtime.ps1
scripts/run-server.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
scripts/version.txt
CHANGELOG.md
TODO.md
```

Il runtime viene creato in `server/`. Mondi, log, librerie, chiavi private e liste locali sono esclusi da Git.

Non impostare `online-mode=false` prima che il server sia stato avviato almeno una volta. Il primo avvio crea `server.properties`; forzare la modalità offline prima che il file esista può interferire con l'installazione iniziale del loader. Completa sempre il primo avvio con `online-mode=true`.

## 3. Il flusso di `start-server.bat`

Il file salva la cartella in cui si trova e non usa un percorso fisso come `C:\MinecraftServer`. Per questo può essere spostato su un'altra unità e può contenere spazi, Unicode e `!`.

Esegue `scripts\bootstrap-server.ps1`, controlla `server/fabric-server-launch.jar`, verifica `server/eula.txt`, quindi esegue `scripts\configure-geyser.ps1`. Il bootstrap cerca Java 25+ a 64 bit in `JAVA_HOME`, in tutte le occorrenze di `PATH`, nelle cartelle standard e nel registro; se trova soltanto Java 8 o Java 21, interrompe l'avvio e mostra i candidati rilevati insieme al link diretto per installare Java 25; salva il percorso scelto in `server\java-path.txt`. `scripts\run-server.ps1` verifica nuovamente quel percorso e avvia l'eseguibile selezionato, non necessariamente il vecchio Java 8 del `PATH`:

```text
<selected-java.exe> -Xms4G -Xmx4G -jar fabric-server-launch.jar nogui
```

Se Java termina con un codice diverso da zero, consultare:

```text
server\logs\latest.log
server\crash-reports\
```

## 4. Cosa fa il bootstrap

Il root viene calcolato da `$PSScriptRoot`, quindi non dipende dalla cartella corrente. Per percorsi profondi controlla `LongPathsEnabled` in:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

Se non vale `1`, può chiedere privilegi amministrativi ed eseguire `scripts\enable-long-paths.ps1`. Il cambiamento è globale per la macchina e può richiedere un riavvio.

Controlla quindi i candidati Java con `java -version`, richiedendo Java 25+ a 64 bit, carica `server\mods-manifest.ps1`, installa Fabric 26.2 con Loader `0.19.3`, scarica le mod in `server\mods\` e verifica ogni SHA-512 (l'eccezione è DedicatedPower, mod solo per Fabric, presa sempre dall'ultima release GitHub). I file esistenti vengono verificati e le configurazioni locali non vengono sovrascritte. Java 8 può restare installato senza bloccare il progetto.

La configurazione predefinita include Fabric API, Geyser-Fabric, Floodgate-Fabric, Lithium, FerriteCore, Krypton, ServerCore, Fabric Carpet e DedicatedPower. Non installa plugin Bukkit/Spigot/Paper.

## 5. Perché servono due avvii

Il bootstrap iniziale crea `server/eula.txt` con `eula=false` e si ferma. L'utente deve leggere <https://www.minecraft.net/eula> e, se accetta, modificare:

```text
eula=false
```

in:

```text
eula=true
```

Il secondo avvio controlla il valore e avvia Fabric. Questa prima esecuzione reale permette a Geyser di creare la configurazione completa. Dopo aver fermato il server con `stop`, `configure-geyser.ps1` imposta `auth-type: floodgate`; è necessario un ulteriore avvio per caricare Floodgate. Jarock automatizza l'installazione, ma non accetta la EULA al posto del proprietario.

## 6. Geyser e Floodgate

Geyser genera la configurazione completa durante il primo avvio reale. Dopo la creazione di:

```text
server\config\Geyser-Fabric\config.yml
```

lo script imposta:

```yaml
auth-type: floodgate
```

La porta Bedrock predefinita è UDP `19132`; Java usa normalmente TCP `25565`. Jarock documenta questi valori ma non apre né inoltra porte. `key.pem` è privato e non deve essere pubblicato.

## 7. Mod e limiti

Lithium ottimizza la logica, FerriteCore la memoria, Krypton la rete, ServerCore le prestazioni e Carpet gli strumenti tecnici/redstone. Sodium, Litematica, MiniHUD e Tweakeroo sono normalmente client-side e non vanno in `server/mods/`.

Un server Fabric normale non esegue plugin Bukkit. Se un plugin è indispensabile, bisogna riprogettare lo stack.

## 8. Errori e sicurezza

Dopo ogni errore leggere `ERROR:` o `WARNING:` e seguire `Suggested fix:`. Se il processo Java si chiude, controllare il primo `Caused by:` nei log. Cause comuni: Java mancante, permessi, download corrotto, EULA non accettata o mod incompatibile.

Jarock non modifica router, firewall, port forwarding, IP pubblico, permessi operatori o repository GitHub. Le attività mancanti sono in `TODO.md`.

<!-- jarock-safe-shutdown -->

## Arresto sicuro

> Scrivi `stop` nella console e lascia aperta la finestra. Prima di chiuderla attendi `CLEAN SHUTDOWN COMPLETE` e poi `SAFE TO CLOSE`. Se il secondo messaggio non compare, controlla log e crash report e ripristina un backup se necessario.

<!-- jarock-updater -->


## Aggiornare Jarock

> Leggi `scripts/version.txt`, arresta il server e attendi `SAFE TO CLOSE`; poi esegui `scripts/update-jarock.bat`. Cerca una release più recente nello stesso canale beta/stabile, chiede conferma e crea un backup per il rollback. Mondo, runtime, mod, librerie e impostazioni locali vengono preservati; le dipendenze vengono riscaricate solo se mancanti o non valide.

> Il pacchetto completo e il relativo checksum SHA-512 pubblicato vengono verificati prima dell'installazione.

<!-- jarock-auto-update-check -->

## Controllo aggiornamenti all'avvio

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.

<!-- jarock-console-close-protection -->

> **Protezione dalla chiusura della console Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Digita stop e attendi SAFE TO CLOSE. Non forzare la chiusura durante il salvataggio del mondo. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
