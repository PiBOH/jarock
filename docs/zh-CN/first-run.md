# Jarock 首次启动

## 开始之前

安装 64 位 Java 25 或更高版本的 JDK，在 Temurin 安装程序中启用 JAVA_HOME，然后重新打开终端。始终运行根目录中的 `start-server.bat`；本地设置保存在 `scripts/server-launch-settings.ini` 中，不要直接打开 `server/server.jar`。

## 选择 loader

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## 安装与 EULA

Jarock 会自动下载 loader 和固定版本的 mod。首次运行会创建 `server/eula.txt` 并停止。阅读 Minecraft EULA，只有同意后才能将 `eula=false` 改为 `eula=true`。首次成功运行之前不要使用 `online-mode=false`；首次运行应使用 `online-mode=true`。

## 安全停止

再次运行并等待 world、Geyser 和 Floodgate 完成加载。输入 `stop`，等待出现 `CLEAN SHUTDOWN COMPLETE` 和 `SAFE TO CLOSE` 后再关闭窗口。出现错误时按照 Suggested fix 操作；如果 loader 混用，请备份并运行 `clean-server-runtime.bat`。安装更新时运行 `scripts/update-jarock.bat`，公开服务器前阅读 `TODO.md`。

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-lan-addresses-zh-CN -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Windows 控制台关闭保护:** While Jarock is running, the classic Windows console may show a warning when X is clicked. 请输入 stop 并等待 SAFE TO CLOSE。世界保存时不要强制关闭。 This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
