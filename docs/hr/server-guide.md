# Vodič za Fabric poslužitelj

Instaliraj 64-bitnu Javu 25, pokreni `start-server.bat` i koristi `parameter-manager.bat` za RAM te GUI ili `nogui`. Pročitaj `server/eula.txt` i postavi `eula=true` tek nakon prihvaćanja EULA-e. Koristi Fabric, Geyser-Fabric i Floodgate-Fabric te izradi backup. Jarock ne mijenja router, firewall ni port forwarding.

See the [English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> **Tehnička napomena: Uvijek koristite `start-server.bat` iz korijena repozitorija. (enable "Set JAVA_HOME variable" in the Temurin installer) Nemojte dvaput kliknuti `server.jar`; Windows može koristiti Java 8 ili Java 21, dok Minecraft 26.2 zahtijeva 64-bitnu Javu 25+. Pogledajte [potpuni vodič na engleskom](../en/server-guide.md).**
