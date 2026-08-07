# Fabric servera rokasgrāmata

Instalējiet 64 bitu Java 25, palaidiet `start-server.bat` un ar `parameter-manager.bat` iestatiet RAM un GUI vai `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Izlasiet `server/eula.txt`, pieņemiet EULA un iestatiet `eula=true`; izmantojiet Fabric, Geyser-Fabric un Floodgate-Fabric un veidojiet dublējumus. Jarock nemaina maršrutētāju, ugunsmūri vai port forwarding.

Skatiet pilno angļu rokasgrāmatu: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Tehniska piezīme: Vienmēr izmantojiet repozitorija saknes mapē esošo `start-server.bat`. Neveiciet dubultklikšķi uz `server.jar`; Windows var izmantot Java 8 vai Java 21, bet Minecraft 26.2 nepieciešama 64 bitu Java 25+. Skatiet [pilno rokasgrāmatu angļu valodā](../en/server-guide.md).**
