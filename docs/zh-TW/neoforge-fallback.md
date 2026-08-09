# NeoForge 備用指南

只有 Fabric 不適合時才使用 NeoForge。Forge 與 NeoForge 是不同 loader，mods 必須符合 NeoForge。需要時加入 Geyser/Floodgate，先測試備份。

See the [English NeoForge fallback guide](../en/neoforge-fallback.md) for the complete procedure. Verify every mod against the selected loader.

<!-- jarock-safe-shutdown -->

## 安全停止

> 輸入 `stop` 並保持視窗開啟。關閉前等待 `CLEAN SHUTDOWN COMPLETE`，再等待 `SAFE TO CLOSE`。如果沒有第二則訊息，請檢查記錄和崩潰報告，必要時還原備份。
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## 更新 Jarock

> 讀取 `scripts/version.txt`，停止伺服器並等待 `SAFE TO CLOSE`；然後執行 `scripts/update-jarock.bat`。它會在相同的 beta/穩定頻道尋找更新，要求確認並建立回復備份。世界、runtime、模組、程式庫和本機設定都會保留；只有相依項目遺失或無效時才會修復。

> 完整套件及其公開的 SHA-512 雜湊值會在安裝前驗證。

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## 啟動時檢查更新

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows 主控台關閉保護:** While Jarock is running, the classic Windows console may show a warning when X is clicked. 請輸入 stop 並等待 SAFE TO CLOSE。世界儲存時不要強制關閉。 This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
