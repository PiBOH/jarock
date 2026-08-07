# Fabric servera rokasgrāmata

Instalējiet 64 bitu Java 25, palaidiet `start-server.bat` un ar `parameter-manager.bat` iestatiet RAM un GUI vai `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Izlasiet `server/eula.txt`, pieņemiet EULA un iestatiet `eula=true`; izmantojiet Fabric, Geyser-Fabric un Floodgate-Fabric un veidojiet dublējumus. Jarock nemaina maršrutētāju, ugunsmūri vai port forwarding.

Skatiet pilno angļu rokasgrāmatu: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Show ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Tehniska piezīme: Vienmēr izmantojiet repozitorija saknes mapē esošo `start-server.bat`. Neveiciet dubultklikšķi uz `server.jar`; Windows var izmantot Java 8 vai Java 21, bet Minecraft 26.2 nepieciešama 64 bitu Java 25+. Skatiet [pilno rokasgrāmatu angļu valodā](../en/server-guide.md).**

<!-- jarock-safe-shutdown -->

## Droša apturēšana

> Ierakstiet `stop` un atstājiet logu atvērtu. Pirms aizvēršanas gaidiet `CLEAN SHUTDOWN COMPLETE` un pēc tam `SAFE TO CLOSE`. Ja otrais ziņojums neparādās, pārbaudiet žurnālu un avārijas ziņojumu un vajadzības gadījumā atjaunojiet dublējumu.

<!-- jarock-updater -->


## Jarock atjaunināšana

> Izlasiet `scripts/version.txt`, apturiet serveri un gaidiet `SAFE TO CLOSE`; pēc tam palaidiet `scripts/update-jarock.bat`. Tas meklē jaunāku tās pašas beta/stabilā kanāla versiju, lūdz apstiprinājumu un izveido atcelšanas dublējumu. Pasaule, runtime, modifikācijas, bibliotēkas un lokālie iestatījumi tiek saglabāti; atkarības labo tikai tad, ja tās trūkst vai ir nederīgas.

> Pilnā pakotne un tās publicētā SHA-512 kontrolsumma tiek pārbaudīta pirms instalēšanas.

<!-- jarock-auto-update-check -->

## Atjauninājumu pārbaude palaišanas laikā

Iestatiet AUTO_UPDATE_CHECK=true failā parameter-manager.bat, lai start-server.bat veiktu tikai lasāmu GitHub pārbaudi. Tiks ziņots par saderīgu jaunāku Jarock versiju, bet nekas netiks instalēts automātiski. Apturiet serveri, uzgaidiet SAFE TO CLOSE un palaidiet scripts/update-jarock.bat. Noklusējums ir AUTO_UPDATE_CHECK=false. When a compatible newer release is found at startup, Jarock asks `Download and install it now? (y/N)`; choose y to install the verified Lite package, or N/Enter to continue with the current version. It never updates silently.
