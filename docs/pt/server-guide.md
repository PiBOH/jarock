# Guia do servidor Fabric

Instale Java 25 de 64 bits, execute `start-server.bat` e use `parameter-manager.bat` para RAM e GUI ou `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Leia `server/eula.txt`, aceite a EULA e defina `eula=true`; use Fabric, Geyser-Fabric e Floodgate-Fabric, faça cópias e lembre-se de que o Jarock não altera router, firewall ou port forwarding.

Consulte o guia completo em inglês: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Nota técnica: Use sempre `start-server.bat` na raiz do repositório. Não clique duas vezes em `server.jar`; o Windows pode usar Java 8 ou Java 21, enquanto o Minecraft 26.2 exige Java 25+ de 64 bits. Consulte o [guia completo em inglês](../en/server-guide.md).**
