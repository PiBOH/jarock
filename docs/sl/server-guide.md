# Vodnik za strežnik Fabric

Namestite 64-bitno Javo 25, zaženite `start-server.bat` in uporabite `parameter-manager.bat` za RAM ter GUI ali `nogui`. Preberite `server/eula.txt`, sprejmite EULA in nastavite `eula=true`; uporabite Fabric, Geyser-Fabric in Floodgate-Fabric, naredite varnostne kopije, Jarock pa ne spreminja usmerjevalnika, požarnega zidu ali port forwarding.

Oglejte si celoten angleški priročnik: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> **Tehnična opomba: Vedno uporabite `start-server.bat` v korenu repozitorija. (enable "Set JAVA_HOME variable" in the Temurin installer) Ne dvokliknite `server.jar`; Windows lahko uporabi Java 8 ali Java 21, Minecraft 26.2 pa zahteva 64-bitno Javo 25+. Glejte [celoten angleški priročnik](../en/server-guide.md).**
