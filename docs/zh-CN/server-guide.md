# Fabric 服务器指南

安装 64 位 Java 25，运行 `start-server.bat`，使用 `parameter-manager.bat` 设置内存和 GUI 或 `nogui`。阅读 `server/eula.txt`，同意 EULA 后才设置 `eula=true`。使用 Fabric、Geyser-Fabric 和 Floodgate-Fabric，并先备份。Jarock 不修改路由器、防火墙或 port forwarding。 (enable "Set JAVA_HOME variable" in the Temurin installer)

See the [English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **技术说明：始终使用仓库根目录中的 `start-server.bat`。不要双击 `server.jar`；Windows 可能会使用 Java 8 或 Java 21，而 Minecraft 26.2 需要 64 位 Java 25+。请参阅[完整英文指南](../en/server-guide.md)。**

<!-- jarock-safe-shutdown -->

## 安全停止

> 输入 `stop` 并保持窗口打开。关闭前等待 `CLEAN SHUTDOWN COMPLETE`，然后等待 `SAFE TO CLOSE`。如果没有第二条消息，请检查日志和崩溃报告，必要时恢复备份。

<!-- jarock-updater -->


## 更新 Jarock

> 读取 `scripts/version.txt`，停止服务器并等待 `SAFE TO CLOSE`；然后运行 `scripts/update-jarock.bat`。它会在相同的 beta/稳定频道中寻找更新，请求确认并创建回滚备份。世界、运行时、模组、库和本地设置都会保留；只有依赖缺失或无效时才会修复。

> 完整软件包及其发布的 SHA-512 校验和会在安装前进行验证。

<!-- jarock-auto-update-check -->

## 启动时检查更新

在 parameter-manager.bat 中将 AUTO_UPDATE_CHECK=true，可让 start-server.bat 以只读方式检查 GitHub 发布版本。它会报告兼容的新版本 Jarock，但不会自动安装。请停止服务器，等待 SAFE TO CLOSE，然后运行 scripts/update-jarock.bat。默认值为 AUTO_UPDATE_CHECK=false。
