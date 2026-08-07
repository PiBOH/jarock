# Kako Jarock radi?

## Jednostavno objašnjenje poslužitelja

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Učitavač:** Fabric
**Glavna platforma:** Windows 10/11

Ovaj dokument objašnjava što se događa nakon preuzimanja Jarocka.


> DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512.

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
version.txt
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

<!-- jarock-safe-shutdown -->

## Sigurno gašenje

> Upišite `stop` i ostavite prozor otvoren. Prije zatvaranja pričekajte `CLEAN SHUTDOWN COMPLETE`, a zatim `SAFE TO CLOSE`. Ako druga poruka nedostaje, provjerite zapisnik i izvještaj o padu te po potrebi vratite sigurnosnu kopiju.

<!-- jarock-updater -->


## Ažuriranje Jarocka

> Pročitajte `version.txt`, zaustavite poslužitelj i pričekajte `SAFE TO CLOSE`; zatim pokrenite `update-jarock.bat`. Traži noviju verziju istog beta/stabilnog kanala, traži potvrdu i stvara pričuvnu kopiju za povratak. Svijet, runtime, modovi, biblioteke i lokalne postavke ostaju sačuvani; ovisnosti se obnavljaju samo ako nedostaju ili nisu valjane.

> Potpuni paket i njegov objavljeni kontrolni zbroj SHA-512 provjeravaju se prije instalacije.

<!-- jarock-auto-update-check -->

## Provjera ažuriranja pri pokretanju

Postavi AUTO_UPDATE_CHECK=true u parameter-manager.bat kako bi start-server.bat izvršio GitHub provjeru samo za čitanje. Prijavit će kompatibilnu noviju verziju, ali ništa neće automatski instalirati. Sigurno zaustavi poslužitelj, pričekaj SAFE TO CLOSE i pokreni update-jarock.bat. Zadano je AUTO_UPDATE_CHECK=false.
