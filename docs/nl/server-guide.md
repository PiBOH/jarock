# Fabric-serverhandleiding

Installeer 64-bits Java 25, start `start-server.bat` en gebruik `parameter-manager.bat` voor RAM en GUI of `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Lees `server/eula.txt` en zet pas na akkoord met de EULA `eula=true`. Gebruik Fabric, Geyser-Fabric en Floodgate-Fabric en maak backups. Jarock wijzigt router, firewall en port forwarding niet.

See the [canonical English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.

> **Technische opmerking: Gebruik altijd `start-server.bat` in de hoofdmap van de repository. Dubbelklik niet op `server.jar`; Windows kan Java 8 of Java 21 gebruiken, terwijl Minecraft 26.2 64-bits Java 25+ vereist. Zie de [volledige Engelse handleiding](../en/server-guide.md).**
