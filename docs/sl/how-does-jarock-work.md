# Kako deluje Jarock?

## Preprosta razlaga strežnika

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Nalagalnik:** Fabric
**Glavna platforma:** Windows 10/11

Ta dokument razloži, kaj se zgodi po prenosu Jarocka.


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome Message 2.8 with its required Collective library is included as a verified server-side Minecraft 26.2 mod for Fabric and NeoForge; it sends configurable join messages.

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
scripts/version.txt
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

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> InvView 1.4.21 is a verified Minecraft 26.2 server-side Fabric mod. It requires Fabric API and lets authorized operators inspect and manage online or offline player inventories and ender chests; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> OfflineCommands 1.0.3 is a verified Minecraft 26.2 server-side Fabric mod for running commands on offline players. No compatible NeoForge 26.2 build is available, so NeoForge does not install it.

<!-- jarock-safe-shutdown -->

## Varna zaustavitev

> Vnesite `stop` in pustite okno odprto. Pred zaprtjem počakajte na `CLEAN SHUTDOWN COMPLETE` in nato `SAFE TO CLOSE`. Če drugega sporočila ni, preverite dnevnik in poročilo o sesutju ter po potrebi obnovite varnostno kopijo.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Posodobitev Jarock

> Preberite `scripts/version.txt`, ustavite strežnik in počakajte na `SAFE TO CLOSE`; nato zaženite `scripts/update-jarock.bat`. Poišče novejšo izdajo istega beta/stabilnega kanala, zahteva potrditev in ustvari varnostno kopijo za povrnitev. Svet, runtime, modifikacije, knjižnice in lokalne nastavitve ostanejo; odvisnosti se popravijo le, če manjkajo ali so neveljavne.

> Celoten paket in njegova objavljena kontrolna vsota SHA-512 se preverita pred namestitvijo.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to run the same check without starting the server. If a verified compatible Lite package is available, the updater asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Preverjanje posodobitev ob zagonu

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Zaščita pred zapiranjem konzole Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Vnesite stop in počakajte na SAFE TO CLOSE. Med shranjevanjem sveta ne zapirajte prisilno. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
