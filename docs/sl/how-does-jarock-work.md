# Kako deluje Jarock?

## Preprosta razlaga strežnika

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Nalagalnik:** Fabric
**Glavna platforma:** Windows 10/11

Ta dokument razloži, kaj se zgodi po prenosu Jarocka.


> DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Opomba za vzdrževanje:** zaganjalnik zdaj poišče združljiv 64-bitni Java 25+ namesto zaupanja samo prvemu `java.exe` v `PATH`. Uporabi `scripts/java-runtime.ps1`, izbrano izvedljivo datoteko shrani v `server/java-path.txt` in jo preveri pred zagonom. Java 8 lahko ostane nameščena.

## 1. Na kratko

Uporabnik namesti 64-bitno Javo, prenese ta repository in zažene `start-server.bat`. Program poišče svojo mapo, preveri Javo in pot, po potrebi zahteva vklop dolgih poti sistema Windows, prenese pripeti Fabric installer in mods ter preveri vsako datoteko s SHA-512.

Fabric ustvari runtime v mapi `server/`. Prvi zagon ustvari `server/eula.txt` z vrednostjo `eula=false` in se ustavi. Uporabnik mora prebrati <https://www.minecraft.net/eula>, ob soglasju nastaviti `eula=true` in zagnati znova. Geyser prevaja promet Bedrock, Floodgate pa upravlja preverjanje pristnosti Bedrock.

Jarock **ne** nastavi routerja, požarnega zidu ali port forwarding.

## 2. Datoteke in potek

Repository vsebuje scripts, predloge in manifest, ne vsebuje pa sveta ali ustvarjenih datotek `.jar`:

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

Runtime se ustvari v `server/`. Git prezre svetove, logs, knjižnice, zasebne ključe in lokalne sezname.

`start-server.bat` uporablja svojo lokacijo namesto stalne poti, kot je `C:\MinecraftServer`, zato podpira dostopne poti s presledki, Unicode, `!` in gnezdenimi mapami. Pri dolgih poteh preveri:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

Če je potrebno, zahteva skrbniška dovoljenja in zažene `scripts\enable-long-paths.ps1`. Sprememba velja za celoten računalnik, starejši programi pa lahko zahtevajo ponovni zagon sistema Windows.

## 3. EULA, Geyser in napake

Prvi zagon ustvari `server/eula.txt` z `eula=false` in se ustavi. Preberi EULA, spremeni v `eula=true`, če se strinjaš, in zaženi znova.

Geyser ustvari popolno konfiguracijo pri prvem pravem zagonu strežnika. Nato skript v:

```text
server\config\Geyser-Fabric\config.yml
```

nastavi:

```yaml
auth-type: floodgate
```

Java običajno uporablja TCP `25565`, Bedrock pa UDP `19132`. Jarock ne odpira vrat. `key.pem` je zaseben in ga ni dovoljeno objaviti.

Po napaki preberi `ERROR:` ali `WARNING:` in sledi `Suggested fix:`. Če se Java konča, poišči prvi `Caused by:` v `server\logs\latest.log` ali `server\crash-reports\`. Preostala opravila so v `TODO.md`.

> **Tehnična opomba: Vedno uporabite `start-server.bat` v korenu repozitorija. Ne dvokliknite `server.jar`; Windows lahko uporabi Java 8 ali Java 21, Minecraft 26.2 pa zahteva 64-bitno Javo 25+. Glejte [celoten angleški priročnik](../en/how-does-jarock-work.md).**

<!-- jarock-safe-shutdown -->

## Varna zaustavitev

> Vnesite `stop` in pustite okno odprto. Pred zaprtjem počakajte na `CLEAN SHUTDOWN COMPLETE` in nato `SAFE TO CLOSE`. Če drugega sporočila ni, preverite dnevnik in poročilo o sesutju ter po potrebi obnovite varnostno kopijo.

<!-- jarock-updater -->


## Posodobitev Jarock

> Preberite `version.txt`, ustavite strežnik in počakajte na `SAFE TO CLOSE`; nato zaženite `update-jarock.bat`. Poišče novejšo izdajo istega beta/stabilnega kanala, zahteva potrditev in ustvari varnostno kopijo za povrnitev. Svet, runtime, modifikacije, knjižnice in lokalne nastavitve ostanejo; odvisnosti se popravijo le, če manjkajo ali so neveljavne.

> Celoten paket in njegova objavljena kontrolna vsota SHA-512 se preverita pred namestitvijo.
