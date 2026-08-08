# Cum funcționează Jarock?

## Explicația simplă a serverului

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Loader:** Fabric
**Platforma principală:** Windows 10/11

Acest document explică ce se întâmplă după descărcarea Jarock.


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome AWA is also included as a verified server-side Fabric 26.2 mod; it sends configurable colored join messages using `%player%` and supports `welcome reload`.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Notă de întreținere:** lansatorul caută acum un runtime Java 25+ compatibil pe 64 de biți, în loc să se bazeze doar pe primul `java.exe` din `PATH`. Folosește `scripts/java-runtime.ps1`, salvează executabilul ales în `server/java-path.txt` și îl validează înainte de pornire. Java 8 poate rămâne instalată.

## 1. Pe scurt

Utilizatorul instalează Java pe 64 de biți, descarcă acest repository și rulează `start-server.bat`. Programul își găsește propriul folder, verifică Java și calea, solicită activarea căilor lungi Windows dacă este necesar, descarcă Fabric installer și mods fixate și verifică fiecare fișier cu SHA-512.

Fabric creează runtime-ul în `server/`. Prima rulare creează `server/eula.txt` cu `eula=false` și se oprește. Utilizatorul trebuie să citească <https://www.minecraft.net/eula>, să schimbe în `eula=true` dacă acceptă și să ruleze din nou. Geyser traduce traficul Bedrock, iar Floodgate gestionează autentificarea Bedrock.

Jarock **nu** configurează routerul, firewall-ul sau port forwarding.

## 2. Fișiere și flux

Repository conține scripts, șabloane și manifest, dar nu conține lumea sau fișierele `.jar` generate:

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

Runtime-ul este creat în `server/`. Git ignoră lumi, logs, biblioteci, chei private și liste locale.

`start-server.bat` folosește propria locație, nu o cale fixă precum `C:\MinecraftServer`, astfel încât acceptă căi accesibile cu spații, Unicode, `!` și foldere imbricate. Pentru căi lungi verifică:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

Dacă este necesar, cere drepturi de administrator și rulează `scripts\enable-long-paths.ps1`. Schimbarea este la nivelul întregului sistem și aplicațiile vechi pot necesita repornirea Windows.

## 3. EULA, Geyser și erori

Prima rulare creează `server/eula.txt` cu `eula=false` și se oprește. Citește EULA, schimbă în `eula=true` dacă ești de acord și rulează din nou.

Geyser creează configurația completă la prima pornire reală a serverului. După ce există:

```text
server\config\Geyser-Fabric\config.yml
```

scriptul setează:

```yaml
auth-type: floodgate
```

Java folosește de obicei TCP `25565`, iar Bedrock UDP `19132`. Jarock nu deschide porturi. `key.pem` este privat și nu trebuie publicat.

După o eroare, citește `ERROR:` sau `WARNING:` și urmează `Suggested fix:`. Dacă Java se oprește, caută primul `Caused by:` în `server\logs\latest.log` sau `server\crash-reports\`. Sarcinile rămase sunt în `TODO.md`.

> **Notă tehnică: Folosiți întotdeauna `start-server.bat` din rădăcina repository-ului. Nu faceți dublu clic pe `server.jar`; Windows poate folosi Java 8 sau Java 21, în timp ce Minecraft 26.2 necesită Java 25+ pe 64 de biți. Consultați [ghidul complet în engleză](../en/how-does-jarock-work.md).**

<!-- jarock-safe-shutdown -->

## Oprire sigură

> Scrieți `stop` și lăsați fereastra deschisă. Înainte de închidere așteptați `CLEAN SHUTDOWN COMPLETE`, apoi `SAFE TO CLOSE`. Dacă al doilea mesaj lipsește, verificați jurnalul și raportul de eroare și restaurați o copie dacă este necesar.

<!-- jarock-updater -->


## Actualizarea Jarock

> Citiți `scripts/version.txt`, opriți serverul și așteptați `SAFE TO CLOSE`; apoi rulați `scripts/update-jarock.bat`. Caută o versiune mai nouă în același canal beta/stabil, cere confirmare și creează o copie pentru revenire. Lumea, runtime-ul, modurile, bibliotecile și setările locale sunt păstrate; dependențele sunt reparate doar dacă lipsesc sau sunt invalide.

> Pachetul complet și suma de verificare SHA-512 publicată sunt verificate înainte de instalare.

<!-- jarock-auto-update-check -->

## Verificarea actualizărilor la pornire

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Protecție împotriva închiderii consolei Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Tastează stop și așteaptă SAFE TO CLOSE. Nu forța închiderea în timpul salvării lumii. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
