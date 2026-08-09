# 網路、防火牆和路由器指南

安裝64位元Java 25，執行`start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat`，完成`TODO.md`後再開放連接埠。設定固定LAN IP，在Windows防火牆中開放TCP `25565`（Java）和UDP `19132`（Bedrock），在路由器上設定連接埠轉發，或使用相容UDP的隧道如playit.gg。確保`online-mode=true`和`white-list=true`，絕不要公開`key.pem`。CGNAT請使用隧道。參見[英文原版指南](../en/network-and-ports.md)。

> 始終使用`start-server.bat`；不要雙擊`server.jar`。

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## 安全停止

> 輸入 `stop` 並保持視窗開啟。關閉前等待 `CLEAN SHUTDOWN COMPLETE`，再等待 `SAFE TO CLOSE`。如果沒有第二則訊息，請檢查記錄和崩潰報告，必要時還原備份。
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## 更新 Jarock

> 讀取 `scripts/version.txt`，停止伺服器並等待 `SAFE TO CLOSE`；然後執行 `scripts/update-jarock.bat`。它會在相同的 beta/穩定頻道尋找更新，要求確認並建立回復備份。世界、runtime、模組、程式庫和本機設定都會保留；只有相依項目遺失或無效時才會修復。

> 完整套件及其公開的 SHA-512 雜湊值會在安裝前驗證。

<!-- jarock-auto-update-check -->

## 啟動時檢查更新

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows 主控台關閉保護:** While Jarock is running, the classic Windows console may show a warning when X is clicked. 請輸入 stop 並等待 SAFE TO CLOSE。世界儲存時不要強制關閉。 This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
