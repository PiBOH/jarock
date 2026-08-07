# Jarock 首次啟動

## 開始之前

安裝 64 位元 Java 25 或更新版本的 JDK，在 Temurin 安裝程式中啟用 JAVA_HOME，然後重新開啟終端機。請一律執行根目錄的 `start-server.bat`；本機設定儲存在 `scripts/server-launch-settings.ini`，不要直接開啟 `server/server.jar`。

## 選擇 loader

執行 `start-server.bat`，選擇 Fabric（推薦）、NeoForge（備用）或 Forge（目前不適用於 Minecraft 26.2）。使用 `parameter-manager.bat` 設定 RAM、GUI/console、GC、`online-mode`、橫幅與 `AUTO_UPDATE_CHECK`。**Exit without saving** 會不儲存並取消。

## 安裝與 EULA

Jarock 會自動下載 loader 與固定版本的 mod。第一次執行會建立 `server/eula.txt` 並停止。閱讀 Minecraft EULA，只有同意後才能將 `eula=false` 改為 `eula=true`。第一次成功執行前不要使用 `online-mode=false`；第一次執行應使用 `online-mode=true`。

## 安全停止

再次執行並等待 world、Geyser 與 Floodgate 完成載入。輸入 `stop`，等到出現 `CLEAN SHUTDOWN COMPLETE` 和 `SAFE TO CLOSE` 後再關閉視窗。發生錯誤時依照 Suggested fix 操作；若 loader 混用，請備份並執行 `clean-server-runtime.bat`。安裝更新時執行 `scripts/update-jarock.bat`，公開伺服器前閱讀 `TODO.md`。

<!-- jarock-lan-addresses-zh-TW -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.
