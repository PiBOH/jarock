# Server Minecraft Java 26.2 con Fabric

## Guida pratica in italiano

Questa è la guida italiana rapida e operativa. La guida tecnica canonica, mantenuta in inglese, è disponibile qui: [English complete guide](../en/server-guide.md).

**Obiettivo:** creare un server Minecraft Java 26.2 con Fabric, mod per ottimizzazione/redstone, accesso Java e Bedrock tramite Geyser e Floodgate.

> Minecraft, Fabric, Geyser, Floodgate e le mod vengono aggiornati separatamente. Scarica soltanto file che indicano esplicitamente **Fabric + Minecraft 26.2**. I nomi e le versioni esatte dei file cambiano nel tempo.

---

## 1. Architettura consigliata

```text
Giocatori Java ─────────────┐
 ├── Fabric Server 26.2 ── mondo
Giocatori Bedrock ─ Geyser ─┘ │
 ├── Fabric API
 ├── mod performance
 └── Carpet per il gioco tecnico
```

Componenti:

- **Java 25 a 64 bit:** esegue Minecraft 26.2.
- **Fabric Server:** carica le mod Fabric.
- **Fabric API:** dipendenza richiesta da molte mod.
- **Geyser-Fabric:** traduce il traffico Bedrock in traffico comprensibile dal server Java.
- **Floodgate-Fabric:** permette agli utenti Bedrock autenticati di entrare senza un account Java a pagamento.
- **Lithium, FerriteCore, Krypton:** ottimizzazione iniziale consigliata.
- **Fabric Carpet:** strumenti tecnici, regole e test per redstone.
- **Essential Commands:** comandi utili per il server, con il componente obbligatorio `ec-core`; disponibile per Fabric 26.2, non per NeoForge.
- **InvView:** consente agli operatori autorizzati di visualizzare e gestire gli inventari e i bauli dell'End dei giocatori online o offline; disponibile per Fabric 26.2, non per NeoForge.
- **OfflineCommands:** permette di eseguire i comandi supportati sui giocatori offline; disponibile per Fabric 26.2, non per NeoForge. Il file verificato si chiama `OfflineCommands-1.0.3+26.1-rc-3.jar`, ma i metadati Modrinth includono esplicitamente Minecraft 26.2. Limita l'accesso agli operatori fidati e verifica i permessi prima dell'uso pubblico.
- **Links In Chat:** mod server-side che rende cliccabili gli URL nella chat e aggiunge i comandi `/link` e `/linkwhisper`; i client non devono installarla.
- **Welcome Message:** mod server-side che invia messaggi configurabili quando entra un giocatore; richiede la libreria Collective ed è disponibile per Fabric e NeoForge 26.2. Al primo avvio gestito da Jarock viene applicato `server/config/welcomemessage.json5.template-jarock` come `server/config/welcomemessage.json5`; gli avvii successivi conservano le tue modifiche. Il template viene preservato da clean-server-runtime.bat e aggiornato dagli update Lite verificati. Se il template manca (ad esempio dopo un aggiornamento da una versione piu vecchia), il bootstrap lo ripristina automaticamente all'avvio. Gli update Lite verificati richiedono il template e lo installano dal pacchetto anche quando non e presente tra i file del server installato.

- **No Chat Reports:** mod server-side inclusa per Fabric e NeoForge 26.2 che impedisce al server di inoltrare dati firmati per la segnalazione della chat. I client vanilla possono comunque mostrare l'avviso dei messaggi non firmati.
- **Better Multiplayer Sleep:** datapack verificato che permette a un solo giocatore di dormire per saltare la notte; viene installato nella cartella `datapacks` del mondo configurato, sia con Fabric sia con NeoForge.
- **ServerCore, Carpet Extra e Carpet TIS Addition:** opzionali; installali solo se esiste una build compatibile con 26.2.

### Cosa non installare sul server

- **Sodium** è principalmente una mod grafica client-side: può aiutare un giocatore Java, ma non ottimizza il server.
- **Litematica, MiniHUD e Tweakeroo** sono normalmente mod client-side.
- Non copiare sul server una mod che richiede l'installazione obbligatoria anche sul client.

### Perché non Cardboard all'inizio

Cardboard cerca di fornire le API Bukkit/Spigot/Paper su Fabric. Può caricare alcuni plugin, ma la compatibilità non è totale e aggiunge un livello di compatibilità fragile. Per un server professionale basato su mod Fabric, usa mod Fabric native. Valuta Cardboard soltanto se hai un plugin Bukkit indispensabile, dopo aver verificato il ramo 26.2 e aver testato tutto su una copia del mondo.

---

## 2. Cosa serve

- Un PC o un hosting che rimanga acceso mentre le persone giocano.
- Sistema operativo a 64 bit.
- Almeno 8 GB di RAM complessiva consigliati per iniziare.
- SSD e connessione stabile.
- Spazio libero per mondo, log e backup.

Un hosting Minecraft è spesso più semplice di un PC di casa, perché evita molte impostazioni del router. Verifica che supporti Fabric, Java 25, mod e traffico UDP. Un hosting può assegnare porte diverse da quelle predefinite: in quel caso usa sempre le porte assegnate.

Puoi collocare il repository nella cartella che preferisci. Questo è soltanto un esempio per principianti, non un percorso obbligatorio:

```text
C:\MinecraftServer
```

Gli script Jarock calcolano la root dalla posizione di `start-server.bat` e supportano percorsi accessibili con spazi, caratteri Unicode, `!` e normale annidamento. Quando possibile evita `Downloads`, cartelle sincronizzate dal cloud e cartelle protette di Windows, perché possono aggiungere problemi di permessi o blocchi dei file.

---

## 3. Installare Java 25

Installa un runtime **Java 25 a 64 bit** proveniente da un distributore affidabile, per esempio Eclipse Temurin 25, oppure seleziona Java 25 dal pannello del tuo hosting.

**Se usi l'installer Eclipse Temurin (HotSpot JDK):** durante l'installazione, quando compare la schermata "Custom Setup", assicurati che l'opzione **"Set JAVA_HOME variable"** sia attivata. Di solito è un'icona con una X rossa — cliccaci sopra e seleziona **"Will be installed on local hard drive"** così che `JAVA_HOME` venga configurato automaticamente. Senza `JAVA_HOME`, Jarock e il server potrebbero non trovare Java.

1. Apri il menu Start di Windows.
2. Scrivi `cmd`.
3. Apri **Prompt dei comandi**.
4. Esegui:

```bat
java -version
```

Devi vedere Java 25 e un runtime a 64 bit. Se compare il messaggio che `java` non è riconosciuto, Java non è installato correttamente o non è presente nel PATH. Reinstalla Java o chiedi all'hosting di selezionare la versione corretta.

Le versioni di Java richieste possono cambiare tra le release Minecraft. Se il launcher o l'installer Fabric ufficiale indica una versione diversa, segui quella indicazione ufficiale.

> Se non viene trovato nessun Java compatibile, `start-server.bat` avvia automaticamente gli installer inclusi: prima il runtime legacy Java 8 (`prerequisites/jre-8-windows-x64.exe`) e, una volta terminato, l'installer MSI di Eclipse Temurin JDK 25 (`prerequisites/OpenJDK25U-jdk_x64_windows_hotspot.msi`). Accetta ogni richiesta UAC e lascia finire gli installer; Jarock ricontrolla poi Java e prosegue.

---

## 4. Installare Fabric Server

Jarock installa automaticamente il loader al primo avvio. Non devi visitare il sito Fabric, scaricare l'installer o eseguire comandi Java. Avvia semplicemente `start-server.bat`, scegli Fabric o NeoForge, e Jarock scarica e installa tutto ciò che serve.

---

## 5. Configurare i parametri e il primo avvio

In questo repository non devi creare manualmente `start.bat`. Avvia `parameter-manager.bat` dalla root del progetto. Il menu permette di scegliere:

- RAM iniziale e massima, per esempio `4G` e `6G`;
- modalità console `nogui` oppure GUI;
- profilo GC predefinito o `low-pause`;
- configurazione automatica dell'ambiente Java dell'utente;
- banner di fine caricamento del server: mostra o nasconde l'avviso ASCII-art quando il server ha terminato l'avvio (opzione "Show ready banner").

Le impostazioni vengono salvate in `scripts/server-launch-settings.ini`, un file locale ignorato da Git. Essential Commands 0.41.0 e il componente obbligatorio `ec-core` 1.3.0 vengono installati per Fabric 26.2. InvView 1.4.21 viene installata per Fabric e permette agli operatori autorizzati di gestire inventari e bauli dell'End dei giocatori online o offline. OfflineCommands 1.0.3 viene installata per Fabric e permette di eseguire i comandi supportati sui giocatori offline. Anche se il nome del file verificato contiene `26.1-rc-3`, i metadati Modrinth includono esplicitamente Minecraft 26.2. Poiché può modificare i dati dei giocatori offline, limita l'accesso agli operatori fidati e verifica i permessi prima dell'uso pubblico. Non esistono build NeoForge 26.2 compatibili per queste tre mod, quindi NeoForge non le installa. No Chat Reports viene installata automaticamente dal manifest del loader selezionato; non viene modificato `enforce-secure-profile`, quindi il comportamento deve essere verificato con i client che userai.
 Il programma controlla che la RAM sia valida, che sia almeno `1G`, che la RAM iniziale non superi quella massima e che non superi la memoria fisica rilevata.

Dopo aver salvato, scegli **Save and start the server** oppure esegui `start-server.bat`. Jarock trova automaticamente un Java 25 a 64 bit compatibile e usa quel percorso, anche se Java 8 è il primo elemento del `PATH`.

Il primo avvio si fermerà creando `eula.txt`. Al bootstrap Jarock verifica Better Multiplayer Sleep e lo installa in `server\world\datapacks` (oppure nel mondo indicato da `level-name`), senza sostituire il mondo o gli altri datapack. Dopo una modifica manuale durante l'esecuzione usa `/reload`.

1. Chiudi il server.
2. Apri `server\eula.txt` nella cartella del repository.
3. Leggi <https://www.minecraft.net/eula>.
4. Se accetti, cambia:

```text
eula=false
```

in:

```text
eula=true
```

5. Salva e avvia nuovamente `start-server.bat` oppure usa `parameter-manager.bat`.

Quando il server è completamente avviato, nel log comparirà il messaggio che indica che è pronto. Per fermarlo correttamente, scrivi nella console:

```text
stop
```

---

## 6. Impostazioni di base

Ferma il server e apri `server.properties` con Notepad. Come base sicura usa o controlla:

```properties
motd=My Fabric 26.2 Server
online-mode=true
white-list=false
enforce-whitelist=false
max-players=20
view-distance=8
simulation-distance=6
server-port=25565
```

- Lascia **`online-mode=true`**. Non disattivarlo per far funzionare Floodgate.

> **Non impostare `online-mode=false` prima di aver creato il server per la prima volta.** Il file server.properties potrebbe non esistere ancora, e forzare la modalità offline prima che il loader abbia completato l'installazione iniziale può interferire con il primo avvio. Fai sempre partire il server con `online-mode=true` almeno una volta, poi eventualmente modificalo dopo se hai una ragione documentata e testata.
- La whitelist è **disabilitata di default** (`white-list=false`, `enforce-whitelist=false`) così chiunque può entrare per i test. Prima di aprire il server al pubblico imposta entrambi su `true` e aggiungi ogni giocatore fidato; `enforce-whitelist` applica la whitelist anche agli operatori.
- `25565` è la porta Java TCP predefinita; un hosting potrebbe assegnarne un'altra.
- `view-distance` e `simulation-distance` possono essere aumentate dopo aver misurato le prestazioni.

Aggiungi un giocatore Java con:

```text
whitelist add NomeDelGiocatore
```

Per un giocatore Bedrock, usa il nome esatto mostrato dal server dopo l'installazione di Floodgate. Può essere presente un prefisso, ad esempio un punto. La sintassi può cambiare: consulta sempre le istruzioni attuali di Floodgate.

---

## 7. Installare Fabric API, Geyser e Floodgate

Pagine ufficiali:

- Fabric API: <https://modrinth.com/mod/fabric-api>
- Download Geyser: <https://geysermc.org/download>
- Guida Geyser: <https://geysermc.org/wiki/geyser/setup/>
- Guida Floodgate: <https://geysermc.org/wiki/floodgate/setup/>

Ferma il server e crea:

```text
C:\MinecraftServer\mods
```

Inserisci nella cartella soltanto file `.jar` compatibili con **Fabric e Minecraft 26.2**:

```text
fabric-api-<compatible-version>.jar
Geyser-Fabric-<compatible-version>.jar
floodgate-fabric-<compatible-version>.jar
collective-26.2.0-8.39.jar
welcomemessage-26.2.0-2.8.jar
```

Non scompattare i `.jar` e non usare siti che ricaricano file modificati.

Avvia il server una volta per generare la configurazione. Poi fermalo e apri:

```text
C:\MinecraftServer\config\Geyser-Fabric\config.yml
```

Imposta:

```yaml
auth-type: floodgate
```

Mantieni la struttura YAML e modifica solo il valore. Riavvia il server e controlla la console.

**Non condividere mai i file `key.pem` di Floodgate.** Non caricarli su GitHub, non inviarli a estranei e non inserirli in un archivio pubblico.

---

## 8. Porte Java e Bedrock

| Edizione | Porta predefinita | Protocollo |
|---|---:|---|
| Java | `25565` | TCP |
| Bedrock tramite Geyser | `19132` | UDP |

La porta Bedrock è UDP: non è la stessa cosa della porta TCP Java.

### Stessa rete domestica

Sul PC server esegui:

```bat
ipconfig
```

Cerca un indirizzo IPv4 simile a `192.168.1.25` o `10.0.0.25`.

- Java usa quell'indirizzo e la porta Java.
- Bedrock usa quell'indirizzo e la porta UDP configurata in Geyser, normalmente `19132`.

Consenti Java e Geyser in Windows Defender Firewall. Per il primo test Bedrock è più semplice usare un secondo dispositivo della stessa rete; la connessione Bedrock dallo stesso PC può richiedere un fix di loopback Windows.

### Accesso da Internet

Hai due possibilità:

1. **Port forwarding:** inoltra la porta Java TCP (normalmente `25565`) e la porta Geyser UDP (normalmente `19132`) verso l'IP locale del PC server. Apri le stesse porte anche nel firewall.
2. **Tunnel:** usa un servizio che supporti TCP e UDP, come l'opzione `playit.gg` indicata dalla documentazione Geyser. Un tunnel solo TCP, come il normale ngrok, non trasporta Bedrock UDP.

Non condividere la porta UDP Geyser con voice chat, query o altri servizi UDP. Se il tuo hosting fornisce porte diverse, configura quelle porte in `server.properties`, in Geyser e nelle istruzioni date ai giocatori.

Quando disponibile, puoi testare dalla console:

```text
geyser connectiontest your.public.address 19132
```

---

## 9. Mod di ottimizzazione e redstone

Controlla sempre nella pagina ufficiale della mod: versione **26.2**, loader **Fabric**, lato **server-side** e dipendenze richieste.

| Mod | Uso | Nota |
|---|---|---|
| Lithium | Ottimizzazione della logica di gioco | Buona prima scelta |
| FerriteCore | Riduzione dell'uso di memoria | Verifica la build 26.2 |
| Krypton | Ottimizzazione della rete | Testala insieme a Geyser |
| ServerCore | Controlli aggiuntivi sulle prestazioni | Impostazioni conservative |
| Fabric Carpet | Regole, diagnostica e strumenti tecnici | Base consigliata per redstone |
| Essential Commands | Comandi utili per il server e componente `ec-core` | Solo Fabric 26.2 |
| Welcome Message | Messaggi configurabili all'ingresso | Richiede Collective; Fabric e NeoForge 26.2. Jarock applica `server/config/welcomemessage.json5.template-jarock` al primo setup e conserva le modifiche successive. |

| Carpet Extra | Estensioni di Carpet | Deve corrispondere alla versione di Carpet |
| Carpet TIS Addition | Strumenti tecnici avanzati | Opzionale, verifica 26.2 |

Installa una mod alla volta:

1. Ferma il server.
2. Copia il `.jar` in `mods/`.
3. Avvia il server.
4. Controlla `logs/latest.log`.
5. Prova un accesso Java e, se possibile, Bedrock.
6. Se tutto funziona, passa alla mod successiva.

Non installare vecchie build di Starlight, Phosphor o Noisium senza una pagina ufficiale che confermi il supporto a 26.2. Se non esiste una build compatibile, lasciale fuori.

---

## 10. Backup e aggiornamenti

Prima di aggiornare Minecraft, Fabric, Geyser, Floodgate o una mod:

1. Scrivi `stop` nella console.
2. Copia almeno `world`, `world_nether`, `world_the_end`, `config`, `mods`, `server.properties` e `whitelist.json`.
3. Usa un nome con la data, per esempio `backup-2026-08-05-before-update`.
4. Aggiorna un solo componente alla volta.
5. Avvia, leggi i log e prova Java e Bedrock.
6. Conserva il backup finché il nuovo server è stato testato.

Non pubblicare:

```text
world/
world_nether/
world_the_end/
config/Geyser-Fabric/key.pem
config/floodgate/key.pem
logs/
```

### 10.1 Importazione ed esportazione del mondo

Jarock può importare ed esportare i mondi da `parameter-manager.bat`.

**Importare un mondo** (`I. Import world`): incolla il percorso completo di una cartella mondo (che contiene `level.dat`) oppure di un archivio `.zip` di un mondo, oppure lascia vuoto il campo e premi Invio per aprire un selettore di cartelle di Windows; digita `CLEAR` per rimuovere la richiesta. Al successivo avvio di `start-server.bat`, Jarock importa il mondo nella cartella configurata da `level-name` (di default `server\world`) prima dell'avvio del server. Se lì esiste già un mondo, Jarock chiede conferma e prima lo sposta da parte come `server\<nome>_originalbkp` (con suffisso data/ora se quel nome è già occupato), quindi nessun dato viene perso. Il parameter manager chiede poi `Remember this world for future starts? (Y/n)`, con Sì come impostazione predefinita. Se rispondi sì, `WORLD_IMPORT_SOURCE` rimane salvato e la sorgente viene riutilizzata solo se in seguito elimini il mondo configurato; nei normali riavvii il mondo esistente non viene mai sovrascritto e non viene mai chiesta conferma per sovrascriverlo. Se rispondi `n`, la richiesta viene cancellata dopo l'importazione una tantum. Il mondo importato è una copia: la cartella o l'archivio sorgente non vengono mai modificati.

**Esportare un mondo** (`E. Export world`): incolla il percorso completo di una cartella di destinazione fuori da `server/`, oppure lascia vuoto il campo e premi Invio per aprire il selettore di cartelle; digita `CLEAR` per rimuovere la richiesta. Dopo ogni arresto pulito (`stop` e la conferma finale `SAFE TO CLOSE`) Jarock copia il mondo corrente in quella cartella di destinazione, sovrascrivendola. La destinazione deve restare fuori da `server/`: una cartella mondo dentro la cartella del server verrebbe rilevata come possibile dato di un mondo precedente al successivo avvio. L'esportazione avviene solo dopo un arresto pulito, mai dopo un crash o una chiusura forzata.

Entrambi i percorsi sono salvati localmente in `scripts/server-launch-settings.ini` (`WORLD_IMPORT_SOURCE` e `WORLD_EXPORT_DEST`) e sono ignorati da Git. La scelta di ricordare il mondo viene salvata in `WORLD_IMPORT_REMEMBER`; `WORLD_IMPORT_APPLIED` è un indicatore interno gestito da Jarock.

<!-- jarock-world-transfer -->

---

## 11. Problemi comuni

### `java` non è riconosciuto

Installa Java 25 a 64 bit e riapri il Prompt dei comandi.

### `UnsupportedClassVersionError`

La versione Java è troppo vecchia. Minecraft 26.2 richiede Java 25 o più recente a 64 bit. Non avviare direttamente `server.jar`, perché Windows potrebbe usare Java 8 o Java 21. Installa un JDK Windows x64 Java 25 da <https://adoptium.net/temurin/releases/?version=25&os=windows&arch=x64&package=jdk>, chiudi e riapri il terminale, quindi avvia `start-server.bat` dalla root del repository.

### Crash all'avvio

Apri `logs/latest.log` e l'ultimo file in `crash-reports/`. Cerca la prima riga `Caused by:`. Le cause comuni sono dipendenze mancanti, mod client-only, file duplicati o versioni sbagliate.

### Il server si ferma con "Overworld settings missing" o non carica il mondo

La cartella del mondo potrebbe essere incompleta, per esempio perché un avvio precedente è stato interrotto durante la generazione. Jarock non sposta, rinomina, elimina o sostituisce automaticamente un mondo esistente. Lascia visibile l’errore di Minecraft e interrompe l’avvio. Controlla `server\logs\latest.log` e l’ultimo crash report, poi ripristina il mondo da un backup funzionante. Un mondo nuovo viene generato soltanto quando la cartella configurata da `level-name` in `server.properties` non esiste e non rimane nessun’altra cartella che possa contenere un vecchio mondo. In Java il Nether e l’End sono salvati dentro quella cartella (`DIM-1` e `DIM1`). Jarock controlla eventuali vecchi mondi anche quando quello configurato esiste; dopo un cambio di `level-name`, rifiuta di avviarsi invece di mescolare o sostituire silenziosamente i mondi.

### Java funziona ma Bedrock no

Controlla che Geyser e Floodgate siano caricati, che `auth-type` sia `floodgate`, che la porta UDP sia corretta e aperta nel firewall/router e che nessun altro servizio usi quella porta.

### Bedrock entra e viene espulso

Controlla autenticazione Floodgate, whitelist e console. Non usare `online-mode=false` come soluzione.

### Contenuti Bedrock rotti

Geyser traduce il protocollo; non installa mod Java client-side sul dispositivo Bedrock. Mod con rendering, oggetti o dimensioni personalizzate possono richiedere soluzioni dedicate e test approfonditi.

### Server lento

Non installare dieci mod subito. Controlla CPU, entità, generazione dei chunk, `view-distance` e `simulation-distance`. Parti da Lithium, FerriteCore e Krypton, poi misura.

---

## 12. Checklist finale

- [ ] Java 25 a 64 bit funziona con `java -version`.
- [ ] Fabric Server è per Minecraft 26.2.
- [ ] Hai letto e accettato la EULA.
- [ ] `online-mode=true` è attivo.
- [ ] La whitelist è attiva prima dei test pubblici (di default è disabilitata: imposta `white-list=true` e `enforce-whitelist=true`).
- [ ] Fabric API, Geyser-Fabric e Floodgate-Fabric sono compatibili con 26.2.
- [ ] `auth-type: floodgate` è configurato.
- [ ] Porta Java TCP e porta Bedrock UDP sono corrette e diverse.
- [ ] Nessuna mod client-only è nella cartella server `mods/`.
- [ ] Essential Commands e `ec-core` sono caricati senza errori quando è selezionato Fabric 26.2.
- [ ] No Chat Reports è caricata dal loader selezionato senza errori.
- [ ] Better Multiplayer Sleep è presente nella cartella `datapacks` del mondo configurato e non produce errori.
- [ ] Esiste un backup.
- [ ] Java riesce a entrare.
- [ ] Bedrock riesce a entrare.
- [ ] `logs/latest.log` non mostra errori irrisolti.

## Riferimenti

- <https://fabricmc.net/use/server/>
- <https://fabricmc.net/2026/06/15/262.html>
- <https://geysermc.org/wiki/geyser/setup/>
- <https://geysermc.org/wiki/floodgate/setup/>
- <https://geysermc.org/download>
- <https://www.minecraft.net/eula>
- <https://github.com/CardboardPowered/cardboard>



<!-- jarock-lan-addresses-it -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

<!-- jarock-safe-shutdown -->

## Arresto sicuro

> Scrivi `stop` nella console e lascia aperta la finestra. Prima di chiuderla attendi `CLEAN SHUTDOWN COMPLETE` e poi `SAFE TO CLOSE`. Se il secondo messaggio non compare, controlla log e crash report e ripristina un backup se necessario.
> Nota: quando viene rilevato il comando `stop`, Jarock avvisa che il mondo sta venendo salvato e poi stampa la conferma finale `SAFE TO CLOSE` direttamente nella console del server, appena il salvataggio è completo, sia in modalità `gui` sia `nogui`. Tieni la finestra aperta fino a quando non appare quel messaggio.

> **Icone Jarock:** il file root `icon.png` viene usato solo come icona predefinita per un mondo che non possiede già una propria icona; le icone di mondi importati o personalizzati vengono preservate. `server/server-icon.png` è l'icona mostrata nell'elenco multiplayer. I tre file tracciati sono inclusi nei pacchetti di rilascio Full e Lite; lo script di pulizia preserva le due icone nella cartella server, mentre icon.png e logo.png nella root restano fuori dal suo ambito.

<!-- jarock-updater -->


## Aggiornare Jarock

> Leggi `scripts/version.txt`, arresta il server e attendi `SAFE TO CLOSE`; poi esegui `scripts/update-jarock.bat`. Cerca una release più recente nello stesso canale beta/stabile, chiede conferma e crea un backup per il rollback. Mondo, runtime, mod, librerie e impostazioni locali vengono preservati; le dipendenze vengono riscaricate solo se mancanti o non valide.

> Il pacchetto completo e il relativo checksum SHA-512 pubblicato vengono verificati prima dell'installazione.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Controllo aggiornamenti all'avvio

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Protezione dalla chiusura della console Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Digita stop e attendi SAFE TO CLOSE. Non forzare la chiusura durante il salvataggio del mondo. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
