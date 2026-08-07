# Fabric 伺服器指南

安裝 64 位元 Java 25，執行 `start-server.bat`，使用 `parameter-manager.bat` 設定記憶體與 GUI 或 `nogui`。閱讀 `server/eula.txt`，接受 EULA 後才設為 `eula=true`。使用 Fabric、Geyser-Fabric、Floodgate-Fabric 並先備份。Jarock 不修改路由器、防火牆或 port forwarding。 (enable "Set JAVA_HOME variable" in the Temurin installer)

See the [English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **技術說明：請一律使用儲存庫根目錄的 `start-server.bat`。不要雙擊 `server.jar`；Windows 可能使用 Java 8 或 Java 21，而 Minecraft 26.2 需要 64 位元 Java 25+。請參閱[完整英文指南](../en/server-guide.md)。**

<!-- jarock-safe-shutdown -->

## 安全停止

> 輸入 `stop` 並保持視窗開啟。關閉前等待 `CLEAN SHUTDOWN COMPLETE`，再等待 `SAFE TO CLOSE`。如果沒有第二則訊息，請檢查記錄和崩潰報告，必要時還原備份。

<!-- jarock-updater -->


## 更新 Jarock

> 讀取 `scripts/version.txt`，停止伺服器並等待 `SAFE TO CLOSE`；然後執行 `scripts/update-jarock.bat`。它會在相同的 beta/穩定頻道尋找更新，要求確認並建立回復備份。世界、runtime、模組、程式庫和本機設定都會保留；只有相依項目遺失或無效時才會修復。

> 完整套件及其公開的 SHA-512 雜湊值會在安裝前驗證。

<!-- jarock-auto-update-check -->

## 啟動時檢查更新

在 parameter-manager.bat 中將 AUTO_UPDATE_CHECK=true，讓 start-server.bat 以唯讀方式檢查 GitHub 發行版本。它會回報相容的新版本 Jarock，但不會自動安裝。請停止伺服器，等待 SAFE TO CLOSE，然後執行 scripts/update-jarock.bat。預設值為 AUTO_UPDATE_CHECK=false。
