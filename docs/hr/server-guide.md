# Vodič za Fabric poslužitelj

Instaliraj 64-bitnu Javu 25, pokreni `start-server.bat` i koristi `parameter-manager.bat` za RAM te GUI ili `nogui`. Pročitaj `server/eula.txt` i postavi `eula=true` tek nakon prihvaćanja EULA-e. Koristi Fabric, Geyser-Fabric i Floodgate-Fabric te izradi backup. Jarock ne mijenja router, firewall ni port forwarding.

See the [English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Tehnička napomena: Uvijek koristite `start-server.bat` iz korijena repozitorija. (enable "Set JAVA_HOME variable" in the Temurin installer) Nemojte dvaput kliknuti `server.jar`; Windows može koristiti Java 8 ili Java 21, dok Minecraft 26.2 zahtijeva 64-bitnu Javu 25+. Pogledajte [potpuni vodič na engleskom](../en/server-guide.md).**

<!-- jarock-safe-shutdown -->

## Sigurno gašenje

> Upišite `stop` i ostavite prozor otvoren. Prije zatvaranja pričekajte `CLEAN SHUTDOWN COMPLETE`, a zatim `SAFE TO CLOSE`. Ako druga poruka nedostaje, provjerite zapisnik i izvještaj o padu te po potrebi vratite sigurnosnu kopiju.

<!-- jarock-updater -->


## Ažuriranje Jarocka

> Pročitajte `version.txt`, zaustavite poslužitelj i pričekajte `SAFE TO CLOSE`; zatim pokrenite `update-jarock.bat`. Traži noviju verziju istog beta/stabilnog kanala, traži potvrdu i stvara pričuvnu kopiju za povratak. Svijet, runtime, modovi, biblioteke i lokalne postavke ostaju sačuvani; ovisnosti se obnavljaju samo ako nedostaju ili nisu valjane.

> Potpuni paket i njegov objavljeni kontrolni zbroj SHA-512 provjeravaju se prije instalacije.
