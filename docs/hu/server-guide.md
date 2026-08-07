# Fabric szerver útmutató

Telepítsen 64 bites Java 25-öt, futtassa a `start-server.bat` fájlt, és használja a `parameter-manager.bat` fájlt RAM-hoz, GUI-hoz vagy `nogui` módhoz. (enable "Set JAVA_HOME variable" in the Temurin installer) Olvassa el a `server/eula.txt` fájlt, fogadja el az EULA-t és állítsa `eula=true` értékre; használjon Fabricet, Geyser-Fabricet és Floodgate-Fabricet, és készítsen mentést. A Jarock nem módosít routert, tűzfalat vagy porttovábbítást.

Olvassa a teljes angol útmutatót: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> **Technikai megjegyzés: Mindig a repository gyökerében található `start-server.bat` fájlt használja. Ne kattintson duplán a `server.jar` fájlra; a Windows Java 8-at vagy Java 21-et használhat, miközben a Minecraft 26.2 64 bites Java 25+-t igényel. Lásd a [teljes angol útmutatót](../en/server-guide.md).**
