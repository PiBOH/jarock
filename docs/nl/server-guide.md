# Fabric-serverhandleiding

Installeer 64-bits Java 25, start `start-server.bat` en gebruik `parameter-manager.bat` voor RAM en GUI of `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Lees `server/eula.txt` en zet pas na akkoord met de EULA `eula=true`. Gebruik Fabric, Geyser-Fabric en Floodgate-Fabric en maak backups. Jarock wijzigt router, firewall en port forwarding niet.

See the [English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Technische opmerking: Gebruik altijd `start-server.bat` in de hoofdmap van de repository. Dubbelklik niet op `server.jar`; Windows kan Java 8 of Java 21 gebruiken, terwijl Minecraft 26.2 64-bits Java 25+ vereist. Zie de [volledige Engelse handleiding](../en/server-guide.md).**
