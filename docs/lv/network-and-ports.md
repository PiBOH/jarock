# Tīkla, ugunsmūra un maršrutētāja rokasgrāmata

Instalējiet 64 bitu Java 25, palaidiet `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` un pabeidziet `TODO.md` pirms portu atvēršanas. Piešķiriet fiksētu LAN IP, atveriet TCP `25565` (Java) un UDP `19132` (Bedrock) Windows ugunsmūrī, konfigurējiet portu pārsūtīšanu maršrutētājā vai izmantojiet UDP saderīgu tuneli, piemēram, playit.gg. Pārliecinieties, ka `online-mode=true` un `white-list=true` ir iespējoti un nekad nepubliskojiet `key.pem`. CGNAT gadījumā izmantojiet tuneli. Skatiet [kanonisko angļu rokasgrāmatu](../en/network-and-ports.md).

> Vienmēr izmantojiet `start-server.bat`; neveiciet dubultklikšķi uz `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Droša apturēšana

> Ierakstiet `stop` un atstājiet logu atvērtu. Pirms aizvēršanas gaidiet `CLEAN SHUTDOWN COMPLETE` un pēc tam `SAFE TO CLOSE`. Ja otrais ziņojums neparādās, pārbaudiet žurnālu un avārijas ziņojumu un vajadzības gadījumā atjaunojiet dublējumu.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Jarock atjaunināšana

> Izlasiet `scripts/version.txt`, apturiet serveri un gaidiet `SAFE TO CLOSE`; pēc tam palaidiet `scripts/update-jarock.bat`. Tas meklē jaunāku tās pašas beta/stabilā kanāla versiju, lūdz apstiprinājumu un izveido atcelšanas dublējumu. Pasaule, runtime, modifikācijas, bibliotēkas un lokālie iestatījumi tiek saglabāti; atkarības labo tikai tad, ja tās trūkst vai ir nederīgas.

> Pilnā pakotne un tās publicētā SHA-512 kontrolsumma tiek pārbaudīta pirms instalēšanas.

<!-- jarock-auto-update-check -->

## Atjauninājumu pārbaude palaišanas laikā

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows konsoles aizvēršanas aizsardzība:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Ierakstiet stop un gaidiet SAFE TO CLOSE. Nepiespiediet aizvēršanu pasaules saglabāšanas laikā. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
