# Fallback NeoForge per Minecraft Java 26.2

## Quando Fabric non è adatto

**Obiettivo:** server Minecraft Java 26.2 con NeoForge, mod tecniche e accesso Java/Bedrock.

> Per la versione 26.2 usa **NeoForge**, non la procedura del vecchio Forge classico. Forge e NeoForge sono loader distinti e le loro mod non sono automaticamente intercambiabili.

La guida completa in inglese è qui: [NeoForge fallback — English](../en/neoforge-fallback.md).

---

## 1. Quando scegliere NeoForge

Scegli NeoForge se:

- una mod indispensabile non ha una versione Fabric;
- il modpack che vuoi usare è pubblicato per NeoForge;
- le mod tecniche che ti servono sono più aggiornate o complete su NeoForge;
- hai verificato che Fabric non sia compatibile con una mod realmente necessaria.

Se tutte le mod funzionano su Fabric, non cambiare loader senza motivo: NeoForge non migliora automaticamente prestazioni o compatibilità con i plugin.

### Attenzione ai plugin

NeoForge è un **loader per mod**, non un server Bukkit/Spigot/Paper. Installare NeoForge non crea un server capace di eseguire automaticamente i plugin Bukkit.

| Priorità | Architettura consigliata |
|---|---|
| Mod Fabric e gioco tecnico | Fabric + mod Fabric native + Geyser-Fabric |
| Mod o modpack NeoForge | NeoForge + mod NeoForge native + Geyser-NeoForge |
| Molti plugin Bukkit maturi | Paper/Spigot + Geyser, senza mod NeoForge |
| Modpack e plugin specifici insieme | Solo un progetto ibrido con build esatta per 26.2, dopo test in un server separato |

Non installare un vecchio Mohist, Magma o Arclight soltanto perché contiene la parola Forge. Un server ibrido può causare crash, incompatibilità, lag e problemi ai mondi.

---

## 2. Java e parametri di avvio

Nel repository Fabric il file `parameter-manager.bat` configura RAM e modalità di avvio. Non usarlo come installer NeoForge: NeoForge è un'architettura separata e va installato con la procedura ufficiale qui sotto. La scoperta Java del progetto usa `scripts/java-runtime.ps1`; il percorso selezionato viene salvato localmente in `server/java-path.txt`.

## 3. Installare NeoForge

1. Crea una cartella semplice, per esempio `C:\MinecraftServer`.
2. Apri il sito ufficiale: <https://neoforged.net/>.
3. Seleziona la versione NeoForge per Minecraft **26.2**.
4. Scarica l'installer `.jar` ufficiale.
5. Mettilo in `C:\MinecraftServer`.
6. Apri il Prompt dei comandi ed esegui:

```bat
cd /d C:\MinecraftServer
java -jar neoforge-<version>-installer.jar --installServer
```

Sostituisci `<version>` con il nome reale del file. L'installer creerà `run.bat`, le librerie e `user_jvm_args.txt`.

Apri `user_jvm_args.txt` e segui i commenti presenti per impostare la RAM. Parti da 4 GB per i test, oppure 6 GB se il computer ha abbastanza memoria. Non assegnare tutta la RAM del PC a Minecraft.

---

## 4. Primo avvio e EULA

1. Fai doppio clic su `run.bat`.
2. Il primo avvio si fermerà creando `eula.txt`.
3. Leggi <https://www.minecraft.net/eula>.
4. Se accetti, cambia:

```text
eula=false
```

in:

```text
eula=true
```

5. Salva il file.
6. Avvia di nuovo `run.bat`.

Per fermare correttamente il server usa:

```text
stop
```

---

## 5. Installare le mod NeoForge

Dopo il primo avvio comparirà la cartella:

```text
C:\MinecraftServer\mods
```

Scarica soltanto mod che dichiarano esplicitamente:

- Minecraft 26.2;
- NeoForge, non soltanto Forge o Fabric;
- supporto server-side, se richiesto;
- dipendenze corrette.

Le mod Fabric di Lithium, FerriteCore, Krypton o Carpet non possono essere copiate direttamente in NeoForge: serve una build NeoForge specifica. Se il progetto non la pubblica, usa un'alternativa NeoForge o non installarla.

Le mod client-side come Sodium, Litematica, MiniHUD e Tweakeroo non vanno nella cartella server `mods/`, salvo indicazione esplicita dell'autore.

Aggiungi una mod alla volta, avvia `run.bat`, controlla `logs/latest.log` e prova il collegamento Java prima di continuare.

---

## 6. Installare Geyser-NeoForge

La documentazione ufficiale Geyser indica **Geyser-NeoForge** per server NeoForge Minecraft 26.2:

- Download: <https://geysermc.org/download>
- Guida server modded: <https://geysermc.org/wiki/geyser/setup/self/modded-servers/>
- Versioni supportate: <https://geysermc.org/wiki/geyser/supported-versions/>

Scarica la build NeoForge che supporta esplicitamente Minecraft 26.2 e mettila in:

```text
C:\MinecraftServer\mods
```

Riavvia una volta il server. Geyser creerà:

```text
C:\MinecraftServer\config\Geyser-NeoForge\config.yml
```

Controlla la porta Bedrock:

```yaml
bedrock:
 address: 0.0.0.0
 port: 19132
 clone-remote-port: false
```

Mantieni l'indentazione YAML. Se l'hosting assegna una porta diversa, usa quella assegnata.

---

## 7. Installare Floodgate-NeoForge

Floodgate è opzionale, ma permette agli utenti Bedrock autenticati di entrare senza possedere Minecraft Java.

Dalla pagina ufficiale dei download seleziona la build **Floodgate-NeoForge** compatibile con 26.2 e mettila in:

```text
C:\MinecraftServer\mods
```

Non installare per errore `floodgate-fabric` su NeoForge.

Nel file di configurazione Geyser imposta:

```yaml
auth-type: floodgate
```

Riavvia e controlla la console.

Il file privato `key.pem` è una credenziale: non caricarlo su GitHub, non inviarlo a estranei e non inserirlo in un backup pubblico.

---

## 8. Porte e rete

| Edizione | Porta predefinita | Protocollo |
|---|---:|---|
| Java | `25565` | TCP |
| Bedrock tramite Geyser | `19132` | UDP |

Un hosting può assegnare porte diverse. Usa i valori dell'hosting in `server.properties`, nella configurazione Geyser e nelle istruzioni ai giocatori.

Su un PC di casa devi:

1. permettere la porta Java TCP nel firewall;
2. permettere la porta Geyser UDP nel firewall;
3. inoltrare la porta Java TCP nel router;
4. inoltrare la porta Geyser UDP nel router;
5. non condividere la porta UDP Geyser con voice chat, query o altri servizi UDP.

Per un tunnel scegli una soluzione che supporti UDP, come l'opzione `playit.gg` documentata da Geyser. Un tunnel solo TCP non trasporta Bedrock.

Testa quando disponibile:

```text
geyser connectiontest your.public.address 19132
```

---

## 9. Impostazioni sicure

In `server.properties` mantieni:

```properties
online-mode=true
white-list=false
enforce-whitelist=false
server-port=25565
view-distance=8
simulation-distance=6
```

Non impostare `online-mode=false` per usare Floodgate. La whitelist è disabilitata di default così chiunque può entrare per i test; prima dell'accesso pubblico imposta `white-list=true` e `enforce-whitelist=true` e aggiungi ogni giocatore fidato. Aggiungi un giocatore Java con:

```text
whitelist add JavaPlayerName
```

Per Bedrock usa il nome esatto Floodgate mostrato dalla console. Può esserci un prefisso; consulta la documentazione aggiornata invece di indovinare il nome.

---

## 10. Limiti per i giocatori Bedrock

Geyser traduce il protocollo Java/Bedrock, ma non installa le mod NeoForge sul dispositivo Bedrock. Non sono automaticamente disponibili:

- rendering personalizzato lato client;
- HUD e minimap Java;
- blocchi, oggetti o entità personalizzate arbitrarie;
- mod che richiedono l'installazione su ogni client;
- ogni dimensione o sistema di risorse personalizzato.

Le mod server-side che conservano blocchi, oggetti ed entità vanilla hanno più possibilità di funzionare. Prova sempre le fattorie e la redstone realmente usate dalla community.

---

## 11. Plugin Bukkit

Su un NeoForge normale i plugin Bukkit non si caricano: NeoForge carica mod NeoForge.

Se un plugin è indispensabile, puoi:

1. cercare una mod NeoForge equivalente;
2. scegliere un server Paper/Spigot se la priorità sono i plugin;
3. valutare un ibrido con build esatta per Minecraft 26.2, in un mondo di test separato.

Non usare un ibrido casuale in produzione.

---

## 12. Backup e problemi comuni

Prima di aggiornare NeoForge, Geyser, Floodgate o una mod:

1. esegui `stop`;
2. salva `world`, `world_nether`, `world_the_end`, `config`, `mods`, `server.properties` e `whitelist.json`;
3. aggiorna un solo componente;
4. avvia e leggi `logs/latest.log`;
5. prova Java e Bedrock.

Non pubblicare la chiave privata Floodgate né la sua cartella di configurazione. Il percorso esatto può variare; spesso si trova sotto `config/floodgate/key.pem`:

```text
world/
world_nether/
world_the_end/
config/floodgate/
logs/
```

Se una mod viene rifiutata, probabilmente è per Fabric, Forge classico, un'altra versione Minecraft o un'altra versione NeoForge. Se Java funziona ma Bedrock no, controlla Geyser, Floodgate, la porta UDP, firewall/router e la versione Bedrock supportata.

## Riferimenti ufficiali

- <https://neoforged.net/>
- <https://docs.neoforged.net/user/docs/server/>
- <https://geysermc.org/wiki/geyser/setup/self/modded-servers/>
- <https://geysermc.org/download>
- <https://geysermc.org/wiki/floodgate/setup/>
- <https://www.minecraft.net/eula>

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
