# 网络、防火墙和路由器指南

安装64位Java 25，运行`start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat`，完成`TODO.md`后再开放端口。设置固定LAN IP，在Windows防火墙中开放TCP `25565`（Java）和UDP `19132`（Bedrock），在路由器上配置端口转发，或使用兼容UDP的隧道如playit.gg。确保`online-mode=true`和`white-list=true`，绝不要公开`key.pem`。CGNAT请使用隧道。参见[英文原版指南](../en/network-and-ports.md)。

> 始终使用`start-server.bat`；不要双击`server.jar`。

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## 安全停止

> 输入 `stop` 并保持窗口打开。关闭前等待 `CLEAN SHUTDOWN COMPLETE`，然后等待 `SAFE TO CLOSE`。如果没有第二条消息，请检查日志和崩溃报告，必要时恢复备份。

<!-- jarock-updater -->


## 更新 Jarock

> 读取 `scripts/version.txt`，停止服务器并等待 `SAFE TO CLOSE`；然后运行 `scripts/update-jarock.bat`。它会在相同的 beta/稳定频道中寻找更新，请求确认并创建回滚备份。世界、运行时、模组、库和本地设置都会保留；只有依赖缺失或无效时才会修复。

> 完整软件包及其发布的 SHA-512 校验和会在安装前进行验证。

<!-- jarock-auto-update-check -->

## 启动时检查更新

Startup update modes: AUTO_UPDATE_MODE=auto checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.
