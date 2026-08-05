# Cum funcționează Jarock?

## Explicația simplă a serverului

**Minecraft:** Java Edition `26.2`
**Loader:** Fabric
**Platforma principală:** Windows 10/11

Acest document explică ce se întâmplă după descărcarea Jarock.

> **Notă de întreținere:** lansatorul caută acum un runtime Java 25+ compatibil pe 64 de biți, în loc să se bazeze doar pe primul `java.exe` din `PATH`. Folosește `scripts/java-runtime.ps1`, salvează executabilul ales în `server/java-path.txt` și îl validează înainte de pornire. Java 8 poate rămâne instalată.

## 1. Pe scurt

Utilizatorul instalează Java pe 64 de biți, descarcă acest repository și rulează `start-server.bat`. Programul își găsește propriul folder, verifică Java și calea, solicită activarea căilor lungi Windows dacă este necesar, descarcă Fabric installer și mods fixate și verifică fiecare fișier cu SHA-512.

Fabric creează runtime-ul în `server/`. Prima rulare creează `server/eula.txt` cu `eula=false` și se oprește. Utilizatorul trebuie să citească <https://www.minecraft.net/eula>, să schimbe în `eula=true` dacă acceptă și să ruleze din nou. Geyser traduce traficul Bedrock, iar Floodgate gestionează autentificarea Bedrock.

Jarock **nu** configurează routerul, firewall-ul sau port forwarding.

## 2. Fișiere și flux

Repository conține scripts, șabloane și manifest, dar nu conține lumea sau fișierele `.jar` generate:

```text
start-server.bat
scripts/bootstrap-fabric.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
version.txt
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