# Kā darbojas Jarock?

## Vienkāršs servera skaidrojums

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Ielādētājs:** Fabric
**Galvenā platforma:** Windows 10/11

Šis dokuments izskaidro, kas notiek pēc Jarock lejupielādes.


> DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Uzturēšanas piezīme:** palaidējs tagad meklē saderīgu 64 bitu Java 25+ vidi, nevis paļaujas tikai uz pirmo `java.exe` failu `PATH`. Tas izmanto `scripts/java-runtime.ps1`, saglabā izvēlēto izpildāmo failu `server/java-path.txt` un pārbauda to pirms palaišanas. Java 8 var palikt instalēta.

## 1. Īsumā

Lietotājs instalē atbalstītu 64 bitu Java, lejupielādē šo repository un palaiž `start-server.bat`. Programma atrod savu mapi, pārbauda Java un ceļu, vajadzības gadījumā pieprasa Windows garo ceļu atbalstu, lejupielādē fiksēto Fabric installer un mods, kā arī pārbauda katru failu ar SHA-512.

Fabric izveido runtime mapē `server/`. Pirmā palaišana izveido `server/eula.txt` ar `eula=false` un apstājas. Lietotājam jāizlasa <https://www.minecraft.net/eula>, jāiestata `eula=true`, ja viņš piekrīt, un jāpalaiž vēlreiz. Geyser pārveido Bedrock datplūsmu, bet Floodgate apstrādā Bedrock autentifikāciju.

Jarock **ne**iestata router, firewall vai port forwarding.

## 2. Faili un darbplūsma

Repository satur scripts, veidnes un manifest, bet nesatur pasauli vai ģenerētos `.jar` failus:

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

Runtime tiek izveidots mapē `server/`. Git ignorē pasaules, logs, bibliotēkas, privātās atslēgas un vietējos sarakstus.

`start-server.bat` izmanto savu atrašanās vietu, nevis fiksētu ceļu, piemēram, `C:\MinecraftServer`, tāpēc tiek atbalstīti pieejami ceļi ar atstarpēm, Unicode, `!` un ligzdotām mapēm. Garajiem ceļiem tiek pārbaudīts:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

Ja nepieciešams, skripts pieprasa administratora tiesības un palaiž `scripts\enable-long-paths.ps1`. Izmaiņa ir visas ierīces līmenī, un vecākām programmām var būt vajadzīga Windows restartēšana.

## 3. EULA, Geyser un kļūdas

Pirmā palaišana izveido `server/eula.txt` ar `eula=false` un apstājas. Izlasi EULA, maini uz `eula=true`, ja piekrīti, un palaid vēlreiz.

Geyser pilno konfigurāciju izveido pirmās īstās servera palaišanas laikā. Pēc tam skripts failā:

```text
server\config\Geyser-Fabric\config.yml
```

iestata:

```yaml
auth-type: floodgate
```

Java parasti izmanto TCP `25565`, bet Bedrock UDP `19132`. Jarock neatver portus. `key.pem` ir privāts un to nedrīkst publicēt.

Pēc kļūdas izlasi `ERROR:` vai `WARNING:` un izpildi `Suggested fix:`. Ja Java apstājas, meklē pirmo `Caused by:` ierakstu failā `server\logs\latest.log` vai mapē `server\crash-reports\`. Atlikušie uzdevumi ir `TODO.md`.

> **Tehniska piezīme: Vienmēr izmantojiet repozitorija saknes mapē esošo `start-server.bat`. Neveiciet dubultklikšķi uz `server.jar`; Windows var izmantot Java 8 vai Java 21, bet Minecraft 26.2 nepieciešama 64 bitu Java 25+. Skatiet [pilno rokasgrāmatu angļu valodā](../en/how-does-jarock-work.md).**

<!-- jarock-safe-shutdown -->

## Droša apturēšana

> Ierakstiet `stop` un atstājiet logu atvērtu. Pirms aizvēršanas gaidiet `CLEAN SHUTDOWN COMPLETE` un pēc tam `SAFE TO CLOSE`. Ja otrais ziņojums neparādās, pārbaudiet žurnālu un avārijas ziņojumu un vajadzības gadījumā atjaunojiet dublējumu.

<!-- jarock-updater -->


## Jarock atjaunināšana

> Izlasiet `scripts/version.txt`, apturiet serveri un gaidiet `SAFE TO CLOSE`; pēc tam palaidiet `scripts/update-jarock.bat`. Tas meklē jaunāku tās pašas beta/stabilā kanāla versiju, lūdz apstiprinājumu un izveido atcelšanas dublējumu. Pasaule, runtime, modifikācijas, bibliotēkas un lokālie iestatījumi tiek saglabāti; atkarības labo tikai tad, ja tās trūkst vai ir nederīgas.

> Pilnā pakotne un tās publicētā SHA-512 kontrolsumma tiek pārbaudīta pirms instalēšanas.

<!-- jarock-auto-update-check -->

## Atjauninājumu pārbaude palaišanas laikā

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows konsoles aizvēršanas aizsardzība:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Ierakstiet stop un gaidiet SAFE TO CLOSE. Nepiespiediet aizvēršanu pasaules saglabāšanas laikā. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
