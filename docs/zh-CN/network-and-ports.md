# 网络、防火墙和路由器指南

安装64位Java 25，运行`start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat`，完成`TODO.md`后再开放端口。设置固定LAN IP，在Windows防火墙中开放TCP `25565`（Java）和UDP `19132`（Bedrock），在路由器上配置端口转发，或使用兼容UDP的隧道如playit.gg。确保`online-mode=true`和`white-list=true`，绝不要公开`key.pem`。CGNAT请使用隧道。参见[英文原版指南](../en/network-and-ports.md)。

> 始终使用`start-server.bat`；不要双击`server.jar`。

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.
