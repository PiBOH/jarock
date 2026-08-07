# NeoForge 備用指南

只有 Fabric 不適合時才使用 NeoForge。Forge 與 NeoForge 是不同 loader，mods 必須符合 NeoForge。需要時加入 Geyser/Floodgate，先測試備份。

See the [English NeoForge fallback guide](../en/neoforge-fallback.md) for the complete procedure. Verify every mod against the selected loader.

<!-- jarock-safe-shutdown -->

## 安全停止

> 輸入 `stop` 並保持視窗開啟。關閉前等待 `CLEAN SHUTDOWN COMPLETE`，再等待 `SAFE TO CLOSE`。如果沒有第二則訊息，請檢查記錄和崩潰報告，必要時還原備份。

<!-- jarock-updater -->


## 更新 Jarock

> 讀取 `version.txt`，停止伺服器並等待 `SAFE TO CLOSE`；然後執行 `update-jarock.bat`。它會在相同的 beta/穩定頻道尋找更新，要求確認並建立回復備份。世界、runtime、模組、程式庫和本機設定都會保留；只有相依項目遺失或無效時才會修復。

> 完整套件及其公開的 SHA-512 雜湊值會在安裝前驗證。

<!-- jarock-auto-update-check -->

## 啟動時檢查更新

在 parameter-manager.bat 中將 AUTO_UPDATE_CHECK=true，讓 start-server.bat 以唯讀方式檢查 GitHub 發行版本。它會回報相容的新版本 Jarock，但不會自動安裝。請停止伺服器，等待 SAFE TO CLOSE，然後執行 update-jarock.bat。預設值為 AUTO_UPDATE_CHECK=false。
