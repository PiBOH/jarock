# Fabric-bedienergids

Installeer ondersteunde 64-bis Java 25, voer `start-server.bat` uit en gebruik `parameter-manager.bat` vir RAM en GUI of `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Lees `server/eula.txt` en stel `eula=true` slegs ná EULA-aanvaarding. Fabric, Geyser-Fabric en Floodgate-Fabric word gebruik; maak rugsteune. Jarock verander nie router, firewall of port forwarding nie.

See the [canonical English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Tegniese nota: Gebruik altyd die `start-server.bat` in die wortel van die repository. Moenie op `server.jar` dubbelklik nie; Windows kan Java 8 of Java 21 gebruik, terwyl Minecraft 26.2 64-bis Java 25+ vereis. Sien die [volledige Engelse gids](../en/server-guide.md).**
