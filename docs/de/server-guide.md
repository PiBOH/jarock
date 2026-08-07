# Fabric-Serverhandbuch

Installieren Sie 64-Bit-Java 25, starten Sie `start-server.bat` und verwenden Sie `parameter-manager.bat` für RAM sowie GUI oder `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Lesen Sie `server/eula.txt`, akzeptieren Sie die EULA und setzen Sie `eula=true`; verwenden Sie Fabric, Geyser-Fabric und Floodgate-Fabric und erstellen Sie Backups. Jarock ändert Router, Firewall und Portweiterleitung nicht.

Lesen Sie die vollständige englische Anleitung: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Technischer Hinweis: Verwenden Sie immer `start-server.bat` im Stammverzeichnis des Repositorys. Doppelklicken Sie nicht auf `server.jar`; Windows kann Java 8 oder Java 21 verwenden, während Minecraft 26.2 64-Bit-Java 25+ benötigt. Siehe die [vollständige englische Anleitung](../en/server-guide.md).**
