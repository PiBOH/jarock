# Guia del servidor Fabric

Instal·la Java 25 de 64 bits, executa `start-server.bat` i usa `parameter-manager.bat` per a RAM i GUI o `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Llegeix `server/eula.txt` i posa `eula=true` només després d’acceptar la EULA. Usa Fabric, Geyser-Fabric i Floodgate-Fabric i fes còpies. Jarock no modifica router, firewall ni port forwarding.

See the [English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Nota tècnica: Utilitza sempre el `start-server.bat` de l’arrel del repositori. No facis doble clic a `server.jar`; Windows pot utilitzar Java 8 o Java 21, mentre que Minecraft 26.2 requereix Java 25+ de 64 bits. Consulta la [guia anglesa completa](../en/server-guide.md).**
