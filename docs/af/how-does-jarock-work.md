# Hoe werk Jarock?

## Eenvoudige verduideliking van die bediener

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Laaier:** Fabric
**Hoofplatform:** Windows 10/11

Hierdie dokument verduidelik wat gebeur nadat iemand Jarock afgelaai het.


> DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Maintenance note:** The launcher now searches for compatible 64-bit Java 25+ instead of trusting only the first `java.exe` in `PATH`. It uses `scripts/java-runtime.ps1`, saves the selected executable in `server/java-path.txt`, and validates it before starting. Java 8 may remain installed.

## 1. Kort opsomming

Die gebruiker installeer 64-bis Java, laai hierdie repository af en begin `start-server.bat`. Die program vind sy eie vouer, kontroleer Java en die pad, versoek ondersteuning vir lang Windows-paaie wanneer nodig, laai die vasgespelde Fabric-installeerder en mods af, en kontroleer elke lêer met SHA-512.

Fabric skep die runtime in `server/`. Die eerste lopie skep `server/eula.txt` met `eula=false` en stop. Die gebruiker moet <https://www.minecraft.net/eula> lees, `eula=true` stel indien hy/sy instem, en weer begin. Geyser vertaal Bedrock-verkeer en Floodgate hanteer Bedrock-verifikasie.

Jarock stel **nie** die router, firewall of port forwarding op nie.

## 2. Lêers en vloei

Die repository bevat skrifte, sjablone en ’n manifest, maar nie die wêreld of gegenereerde `.jar`-lêers nie:

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

Die runtime word in `server/` geskep. Wêrelde, logs, biblioteke, private sleutels en plaaslike lyste word deur Git geïgnoreer.

`start-server.bat` gebruik sy eie ligging, nie ’n vaste pad soos `C:\MinecraftServer` nie. Dit ondersteun toeganklike paaie met spasies, Unicode, `!` en geneste vouers. Vir lang paaie kontroleer dit:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

Indien nodig, vra dit administrateurregte en voer `scripts\enable-long-paths.ps1` uit. Die verandering is masjienwyd en ’n herlaai kan nodig wees.

Daarna word `java -version`, `server\mods-manifest.ps1`, Fabric 26.2 met Loader `0.19.3`, die mods in `server\mods\` en alle SHA-512-hashes nagegaan. Plaaslike konfigurasies word nie oorskryf nie.

## 3. EULA, Geyser en foute

Die eerste lopie skep `server/eula.txt` met `eula=false`. Lees die EULA en verander dit na `eula=true` indien jy instem. Die tweede lopie begin die werklike bediener.

Geyser skep sy volledige konfigurasie tydens die eerste werklike begin. Daarna stel die skrif in:

```text
server\config\Geyser-Fabric\config.yml
```

```yaml
auth-type: floodgate
```

Java gebruik gewoonlik TCP `25565` en Bedrock UDP `19132`. Jarock maak geen poorte oop nie. `key.pem` is privaat en mag nooit gepubliseer word nie.

Na ’n fout, lees `ERROR:` of `WARNING:` en volg `Suggested fix:`. As Java stop, kyk na die eerste `Caused by:` in `server\logs\latest.log` of `server\crash-reports\`. Algemene oorsake is ontbrekende Java, onvoldoende regte, ’n beskadigde aflaai, ’n onaanvaarde EULA of ’n onversoenbare mod.

Jarock verander nie die router, firewall, port forwarding of openbare IP nie. Die oorblywende take staan in `TODO.md`.

> **Tegniese nota: Gebruik altyd die `start-server.bat` in die wortel van die repository. Moenie op `server.jar` dubbelklik nie; Windows kan Java 8 of Java 21 gebruik, terwyl Minecraft 26.2 64-bis Java 25+ vereis. Sien die [volledige Engelse gids](../en/how-does-jarock-work.md).**

<!-- jarock-safe-shutdown -->

## Veilige afsluiting

> Tik `stop` in die bedienerkonsole en laat die venster oop. Wag vir `CLEAN SHUTDOWN COMPLETE` en daarna `SAFE TO CLOSE` voordat jy dit sluit. As die tweede boodskap ontbreek, lees die log en crash-verslag en herstel ’n rugsteun indien nodig.

<!-- jarock-updater -->


## Jarock-bywerking

> Lees `scripts/version.txt`, stop die bediener en wag vir `SAFE TO CLOSE`; voer dan `scripts/update-jarock.bat` uit. Dit soek ’n nuwer vrystelling in dieselfde beta/stabiele kanaal, vra bevestiging en maak ’n terugrolrugsteun. Die wêreld, runtime, mods, biblioteke en plaaslike instellings bly behoue; afhanklikhede word net herstel as hulle ontbreek of ongeldig is.

> Die volledige pakket en sy gepubliseerde SHA-512-kontrolesom word voor installasie nagegaan.

<!-- jarock-auto-update-check -->

## Kontrole vir opdaterings tydens opstart

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows-konsole-sluitbeskerming:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Tik stop en wag vir SAFE TO CLOSE. Moet nooit forseer sluit terwyl die wêreld gestoor word nie. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
