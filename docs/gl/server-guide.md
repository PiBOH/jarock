# Guía do servidor Fabric

Instala Java 25 de 64 bits, executa `start-server.bat` e usa `parameter-manager.bat` para configurar RAM e GUI ou `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Le `server/eula.txt`, acepta a EULA e pon `eula=true`; usa Fabric, Geyser-Fabric e Floodgate-Fabric e fai copias. Jarock non modifica router, firewall nin port forwarding.

Consulta a guía completa en inglés: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Nota técnica: Usa sempre o `start-server.bat` da raíz do repositorio. Non fagas dobre clic en `server.jar`; Windows pode usar Java 8 ou Java 21, mentres que Minecraft 26.2 require Java 25+ de 64 bits. Consulta a [guía completa en inglés](../en/server-guide.md).**
