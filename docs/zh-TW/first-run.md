> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

# Jarock 首次啟動

## 開始之前

安裝 64 位元 Java 25 或更新版本的 JDK，在 Temurin 安裝程式中啟用 JAVA_HOME，然後重新開啟終端機。請一律執行根目錄的 `start-server.bat`；本機設定儲存在 `scripts/server-launch-settings.ini`，不要直接開啟 `server/server.jar`。

## 選擇 loader

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## 安裝與 EULA

Jarock 會自動下載 loader 與固定版本的 mod。第一次執行會建立 `server/eula.txt` 並停止。閱讀 Minecraft EULA，只有同意後才能將 `eula=false` 改為 `eula=true`。第一次成功執行前不要使用 `online-mode=false`；第一次執行應使用 `online-mode=true`。

## 安全停止

再次執行並等待 world、Geyser 與 Floodgate 完成載入。輸入 `stop`，等到出現 `CLEAN SHUTDOWN COMPLETE` 和 `SAFE TO CLOSE` 後再關閉視窗。發生錯誤時依照 Suggested fix 操作；若 loader 混用，請備份並執行 `clean-server-runtime.bat`。安裝更新時執行 `scripts/update-jarock.bat`，公開伺服器前閱讀 `TODO.md`。

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-lan-addresses-zh-TW -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Windows 主控台關閉保護:** While Jarock is running, the classic Windows console may show a warning when X is clicked. 請輸入 stop 並等待 SAFE TO CLOSE。世界儲存時不要強制關閉。 Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
