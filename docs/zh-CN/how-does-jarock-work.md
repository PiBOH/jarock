# Jarock 是如何工作的？

## 服务器工作原理简介

**Minecraft：** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**加载器：** Fabric
**主要平台：** Windows 10/11

本文说明下载 Jarock 后服务器实际会做什么。


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome Message 2.8 with its required Collective library is included as a verified server-side Minecraft 26.2 mod for Fabric and NeoForge; it sends configurable join messages.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **维护说明：** 启动器现在会寻找兼容的 64 位 Java 25+ 运行时，而不是只信任 `PATH` 中第一个 `java.exe`。它使用 `scripts/java-runtime.ps1`，将选中的可执行文件保存到 `server/java-path.txt`，并在启动前再次验证。Java 8 可以继续安装。

## 1. 简要流程

用户安装 64 位 Java，下载本 repository，然后运行 `start-server.bat`。程序会自动找到自己的目录，检查 Java 和路径；如果需要，会请求启用 Windows 长路径支持；随后下载固定版本的 Fabric 安装器和 mods，并使用 SHA-512 校验每个文件。

Fabric 会在 `server/` 中创建运行环境。第一次运行会创建 `server/eula.txt`，其中为 `eula=false`，然后停止。用户需要阅读 <https://www.minecraft.net/eula>，同意后将其改为 `eula=true`，再运行一次。Geyser 负责转换 Bedrock 流量，Floodgate 负责 Bedrock 身份验证。

Jarock **不会**配置路由器、防火墙或 port forwarding。

## 2. 文件和目录

repository 中保存脚本、模板和 manifest，不保存世界或生成的 `.jar` 文件：

```text
start-server.bat
scripts/bootstrap-server.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
scripts/version.txt
CHANGELOG.md
TODO.md
```

运行时文件会放在 `server/`。世界、logs、库文件、私钥和本地列表会被 Git 忽略。

`start-server.bat` 使用自身所在的位置，不依赖 `C:\MinecraftServer` 这样的固定路径，因此支持包含空格、Unicode、`!` 和多层目录的可访问路径。深路径会检查：

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

必要时会请求管理员权限并运行 `scripts\enable-long-paths.ps1`。这是系统级修改，旧程序可能需要重启 Windows。

## 3. EULA、Geyser 和错误

第一次运行创建 `server/eula.txt` 后停止。阅读 EULA 并将 `eula=false` 改为 `eula=true` 后再次启动。

Geyser 在第一次真正启动服务器时生成完整配置。创建以下文件后：

```text
server\config\Geyser-Fabric\config.yml
```

脚本会设置：

```yaml
auth-type: floodgate
```

Java 通常使用 TCP `25565`，Bedrock 通常使用 UDP `19132`。Jarock 不会打开或转发这些端口。`key.pem` 是私密文件，绝不能公开。

发生错误后，读取 `ERROR:` 或 `WARNING:`，按照 `Suggested fix:` 操作。如果 Java 退出，检查 `server\logs\latest.log` 和 `server\crash-reports\` 中最早的 `Caused by:`。发布前仍需完成的事项在 `TODO.md` 中。

> **技术说明：始终使用仓库根目录中的 `start-server.bat`。不要双击 `server.jar`；Windows 可能会使用 Java 8 或 Java 21，而 Minecraft 26.2 需要 64 位 Java 25+。请参阅[完整英文指南](../en/how-does-jarock-work.md)。**

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> InvView 1.4.21 is a verified Minecraft 26.2 server-side Fabric mod. It requires Fabric API and lets authorized operators inspect and manage online or offline player inventories and ender chests; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> OfflineCommands 1.0.3 is a verified Minecraft 26.2 server-side Fabric mod for running commands on offline players. No compatible NeoForge 26.2 build is available, so NeoForge does not install it.

<!-- jarock-safe-shutdown -->

## 安全停止

> 输入 `stop` 并保持窗口打开。关闭前等待 `CLEAN SHUTDOWN COMPLETE`，然后等待 `SAFE TO CLOSE`。如果没有第二条消息，请检查日志和崩溃报告，必要时恢复备份。
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## 更新 Jarock

> 读取 `scripts/version.txt`，停止服务器并等待 `SAFE TO CLOSE`；然后运行 `scripts/update-jarock.bat`。它会在相同的 beta/稳定频道中寻找更新，请求确认并创建回滚备份。世界、运行时、模组、库和本地设置都会保留；只有依赖缺失或无效时才会修复。

> 完整软件包及其发布的 SHA-512 校验和会在安装前进行验证。

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to run the same check without starting the server. If a verified compatible Lite package is available, the updater asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## 启动时检查更新

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows 控制台关闭保护:** While Jarock is running, the classic Windows console may show a warning when X is clicked. 请输入 stop 并等待 SAFE TO CLOSE。世界保存时不要强制关闭。 This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
