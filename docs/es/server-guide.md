# Guía del servidor Fabric

Instala Java 25 de 64 bits, ejecuta `start-server.bat` y usa `parameter-manager.bat` para RAM y GUI o `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Lee `server/eula.txt` y cambia a `eula=true` solo después de aceptar la EULA. Usa Fabric, Geyser-Fabric y Floodgate-Fabric y crea copias de seguridad. Jarock no modifica router, firewall ni port forwarding.

See the [English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Nota técnica: Usa siempre `start-server.bat` en la raíz del repositorio. No hagas doble clic en `server.jar`; Windows puede usar Java 8 o Java 21, mientras que Minecraft 26.2 requiere Java 25+ de 64 bits. Consulta la [guía completa en inglés](../en/server-guide.md).**
