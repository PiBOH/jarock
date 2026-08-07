# 網路、防火牆和路由器指南

安裝64位元Java 25，執行`start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat`，完成`TODO.md`後再開放連接埠。設定固定LAN IP，在Windows防火牆中開放TCP `25565`（Java）和UDP `19132`（Bedrock），在路由器上設定連接埠轉發，或使用相容UDP的隧道如playit.gg。確保`online-mode=true`和`white-list=true`，絕不要公開`key.pem`。CGNAT請使用隧道。參見[英文原版指南](../en/network-and-ports.md)。

> 始終使用`start-server.bat`；不要雙擊`server.jar`。

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.
