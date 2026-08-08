# Kako Jarock radi?

## Jednostavno objašnjenje poslužitelja

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Učitavač:** Fabric
**Glavna platforma:** Windows 10/11

Ovaj dokument objašnjava što se događa nakon preuzimanja Jarocka.


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome AWA is also included as a verified server-side Fabric 26.2 mod; it sends configurable colored join messages using `%player%` and supports `welcome reload`.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Napomena za održavanje:** Pokretač sada traži kompatibilni 64-bitni Java 25+ umjesto da vjeruje samo prvom `java.exe` u varijabli `PATH`. Koristi `scripts/java-runtime.ps1`, sprema odabranu izvršnu datoteku u `server/java-path.txt` i provjerava je prije pokretanja. Java 8 može ostati instalirana.

## 1. Sažetak

Korisnik instalira 64-bitni Java runtime, preuzme ovaj repository i pokrene `start-server.bat`. Program pronađe vlastitu mapu, provjeri Java i putanju, po potrebi zatraži uključivanje dugih Windows putanja, preuzme fiksirane Fabric datoteke i modove te provjeri svaku datoteku pomoću SHA-512.

Fabric stvara runtime u `server/`. Prvo pokretanje stvara `server/eula.txt` s vrijednošću `eula=false` i zaustavlja se. Korisnik mora pročitati <https://www.minecraft.net/eula>, postaviti `eula=true` ako prihvaća, a zatim ponovno pokrenuti program. Geyser prevodi Bedrock promet, a Floodgate upravlja Bedrock autentifikacijom.

Jarock **ne** postavlja router, firewall ni port forwarding.

## 2. Datoteke i tijek

Repository sadrži skripte, predloške i manifest, ali ne sadrži svijet ni generirane `.jar` datoteke:

```text
start-server.bat
scripts/bootstrap-server.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
scripts/version.txt
CHANGELOG.md
TODO.md
```

Runtime se stvara u `server/`. Git zanemaruje svjetove, logove, biblioteke, privatne ključeve i lokalne popise.

`start-server.bat` koristi vlastitu lokaciju umjesto fiksne putanje poput `C:\MinecraftServer`, pa podržava dostupne putanje s razmacima, Unicodeom, `!` i ugniježđenim mapama. Za duge putanje provjerava:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

Ako je potrebno, zatraži administratorske ovlasti i pokrene `scripts\enable-long-paths.ps1`. Promjena vrijedi za cijeli sustav i možda će trebati ponovno pokretanje Windowsa.

## 3. EULA, Geyser i pogreške

Prvo pokretanje stvara `server/eula.txt` s `eula=false` i zaustavlja se. Pročitajte EULA-u, promijenite vrijednost u `eula=true` ako se slažete i pokrenite ponovno.

Geyser stvara potpunu konfiguraciju tijekom prvog stvarnog pokretanja. Nakon stvaranja:

```text
server\config\Geyser-Fabric\config.yml
```

skripta postavlja:

```yaml
auth-type: floodgate
```

Java obično koristi TCP `25565`, a Bedrock UDP `19132`. Jarock ne otvara priključke. `key.pem` je privatan i ne smije se objaviti.

Nakon pogreške pročitajte `ERROR:` ili `WARNING:` i slijedite `Suggested fix:`. Ako se Java ugasi, potražite prvi `Caused by:` u `server\logs\latest.log` ili `server\crash-reports\`. Preostali zadaci nalaze se u `TODO.md`.

> **Tehnička napomena: Uvijek koristite `start-server.bat` iz korijena repozitorija. Nemojte dvaput kliknuti `server.jar`; Windows može koristiti Java 8 ili Java 21, dok Minecraft 26.2 zahtijeva 64-bitnu Javu 25+. Pogledajte [potpuni vodič na engleskom](../en/how-does-jarock-work.md).**

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> InvView 1.4.21 is a verified Minecraft 26.2 server-side Fabric mod. It requires Fabric API and lets authorized operators inspect and manage online or offline player inventories and ender chests; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

<!-- jarock-safe-shutdown -->

## Sigurno gašenje

> Upišite `stop` i ostavite prozor otvoren. Prije zatvaranja pričekajte `CLEAN SHUTDOWN COMPLETE`, a zatim `SAFE TO CLOSE`. Ako druga poruka nedostaje, provjerite zapisnik i izvještaj o padu te po potrebi vratite sigurnosnu kopiju.

<!-- jarock-updater -->


## Ažuriranje Jarocka

> Pročitajte `scripts/version.txt`, zaustavite poslužitelj i pričekajte `SAFE TO CLOSE`; zatim pokrenite `scripts/update-jarock.bat`. Traži noviju verziju istog beta/stabilnog kanala, traži potvrdu i stvara pričuvnu kopiju za povratak. Svijet, runtime, modovi, biblioteke i lokalne postavke ostaju sačuvani; ovisnosti se obnavljaju samo ako nedostaju ili nisu valjane.

> Potpuni paket i njegov objavljeni kontrolni zbroj SHA-512 provjeravaju se prije instalacije.

<!-- jarock-auto-update-check -->

## Provjera ažuriranja pri pokretanju

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Zaštita od zatvaranja Windows konzole:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Upišite stop i pričekajte SAFE TO CLOSE. Ne prisiljavajte zatvaranje dok se svijet sprema. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
