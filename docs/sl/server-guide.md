# Vodnik za strežnik Fabric

Namestite 64-bitno Javo 25, zaženite `start-server.bat` in uporabite `parameter-manager.bat` za RAM ter GUI ali `nogui`. Preberite `server/eula.txt`, sprejmite EULA in nastavite `eula=true`; uporabite Fabric, Geyser-Fabric in Floodgate-Fabric, naredite varnostne kopije, Jarock pa ne spreminja usmerjevalnika, požarnega zidu ali port forwarding.

Oglejte si celoten angleški priročnik: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Show ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Tehnična opomba: Vedno uporabite `start-server.bat` v korenu repozitorija. (enable "Set JAVA_HOME variable" in the Temurin installer) Ne dvokliknite `server.jar`; Windows lahko uporabi Java 8 ali Java 21, Minecraft 26.2 pa zahteva 64-bitno Javo 25+. Glejte [celoten angleški priročnik](../en/server-guide.md).**

<!-- jarock-safe-shutdown -->

## Varna zaustavitev

> Vnesite `stop` in pustite okno odprto. Pred zaprtjem počakajte na `CLEAN SHUTDOWN COMPLETE` in nato `SAFE TO CLOSE`. Če drugega sporočila ni, preverite dnevnik in poročilo o sesutju ter po potrebi obnovite varnostno kopijo.

<!-- jarock-updater -->


## Posodobitev Jarock

> Preberite `scripts/version.txt`, ustavite strežnik in počakajte na `SAFE TO CLOSE`; nato zaženite `scripts/update-jarock.bat`. Poišče novejšo izdajo istega beta/stabilnega kanala, zahteva potrditev in ustvari varnostno kopijo za povrnitev. Svet, runtime, modifikacije, knjižnice in lokalne nastavitve ostanejo; odvisnosti se popravijo le, če manjkajo ali so neveljavne.

> Celoten paket in njegova objavljena kontrolna vsota SHA-512 se preverita pred namestitvijo.

<!-- jarock-auto-update-check -->

## Preverjanje posodobitev ob zagonu

V parameter-manager.bat nastavite AUTO_UPDATE_CHECK=true, da start-server.bat preveri izdaje GitHub samo za branje. Poročal bo o združljivi novejši različici Jarock, vendar je ne bo samodejno namestil. Ustavite strežnik, počakajte na SAFE TO CLOSE in zaženite scripts/update-jarock.bat. Privzeto je AUTO_UPDATE_CHECK=false. When a compatible newer release is found at startup, Jarock asks `Download and install it now? (y/N)`; choose y to install the verified Lite package, or N/Enter to continue with the current version. It never updates silently.
