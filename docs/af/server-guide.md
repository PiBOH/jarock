# Fabric-bedienergids

Installeer ondersteunde 64-bis Java 25, voer `start-server.bat` uit en gebruik `parameter-manager.bat` vir RAM en GUI of `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Lees `server/eula.txt` en stel `eula=true` slegs ná EULA-aanvaarding. Fabric, Geyser-Fabric en Floodgate-Fabric word gebruik; maak rugsteune. Jarock verander nie router, firewall of port forwarding nie.

See the [English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Tegniese nota: Gebruik altyd die `start-server.bat` in die wortel van die repository. Moenie op `server.jar` dubbelklik nie; Windows kan Java 8 of Java 21 gebruik, terwyl Minecraft 26.2 64-bis Java 25+ vereis. Sien die [volledige Engelse gids](../en/server-guide.md).**
