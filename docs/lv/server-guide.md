# Fabric servera rokasgrāmata

Instalējiet 64 bitu Java 25, palaidiet `start-server.bat` un ar `parameter-manager.bat` iestatiet RAM un GUI vai `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Izlasiet `server/eula.txt`, pieņemiet EULA un iestatiet `eula=true`; izmantojiet Fabric, Geyser-Fabric un Floodgate-Fabric un veidojiet dublējumus. Jarock nemaina maršrutētāju, ugunsmūri vai port forwarding.

Skatiet pilno angļu rokasgrāmatu: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Tehniska piezīme: Vienmēr izmantojiet repozitorija saknes mapē esošo `start-server.bat`. Neveiciet dubultklikšķi uz `server.jar`; Windows var izmantot Java 8 vai Java 21, bet Minecraft 26.2 nepieciešama 64 bitu Java 25+. Skatiet [pilno rokasgrāmatu angļu valodā](../en/server-guide.md).**
