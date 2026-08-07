# Fabric 服务器指南

安装 64 位 Java 25，运行 `start-server.bat`，使用 `parameter-manager.bat` 设置内存和 GUI 或 `nogui`。阅读 `server/eula.txt`，同意 EULA 后才设置 `eula=true`。使用 Fabric、Geyser-Fabric 和 Floodgate-Fabric，并先备份。Jarock 不修改路由器、防火墙或 port forwarding。 (enable "Set JAVA_HOME variable" in the Temurin installer)

See the [English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **技术说明：始终使用仓库根目录中的 `start-server.bat`。不要双击 `server.jar`；Windows 可能会使用 Java 8 或 Java 21，而 Minecraft 26.2 需要 64 位 Java 25+。请参阅[完整英文指南](../en/server-guide.md)。**
