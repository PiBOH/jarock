# Jarock 如何運作？

## 伺服器運作方式簡介

**Minecraft：** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**載入器：** Fabric
**主要平台：** Windows 10/11

本文件說明下載 Jarock 後實際會發生什麼事。


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome Message 2.8 with its required Collective library is included as a verified server-side Minecraft 26.2 mod for Fabric and NeoForge; it sends configurable join messages.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **維護說明：** 啟動器現在會尋找相容的 64 位元 Java 25+ 執行環境，而不是只信任 `PATH` 中第一個 `java.exe`。它使用 `scripts/java-runtime.ps1`，將選取的執行檔儲存到 `server/java-path.txt`，並在啟動前再次驗證。Java 8 可以繼續安裝。

## 1. 簡要流程

使用者安裝 64 位元 Java，下載這個 repository，然後執行 `start-server.bat`。程式會找到自己的資料夾，檢查 Java 與路徑；需要時會要求啟用 Windows 長路徑支援；接著下載固定版本的 Fabric 安裝器與 mods，並使用 SHA-512 驗證每個檔案。

Fabric 會在 `server/` 建立執行環境。第一次執行會建立 `server/eula.txt`，內容為 `eula=false`，然後停止。使用者必須閱讀 <https://www.minecraft.net/eula>，同意後改成 `eula=true`，再執行一次。Geyser 轉換 Bedrock 流量，Floodgate 處理 Bedrock 驗證。

Jarock **不會**設定路由器、防火牆或 port forwarding。

## 2. 檔案與目錄

repository 包含 scripts、範本與 manifest，不包含世界或產生的 `.jar`：

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

執行環境會建立在 `server/`。世界、logs、函式庫、私密金鑰與本機清單會被 Git 忽略。

`start-server.bat` 使用自己的位置，不依賴 `C:\MinecraftServer` 之類的固定路徑，因此支援包含空格、Unicode、`!` 和巢狀資料夾的可存取路徑。深層路徑會檢查：

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

必要時會要求系統管理員權限並執行 `scripts\enable-long-paths.ps1`。這是系統層級變更，舊程式可能需要重新啟動 Windows。

## 3. EULA、Geyser 與錯誤

第一次執行建立 `server/eula.txt` 後會停止。閱讀 EULA，若同意就將 `eula=false` 改為 `eula=true`，再重新執行。

Geyser 會在第一次真正啟動伺服器時建立完整設定。建立以下檔案後：

```text
server\config\Geyser-Fabric\config.yml
```

腳本會設定：

```yaml
auth-type: floodgate
```

Java 通常使用 TCP `25565`，Bedrock 通常使用 UDP `19132`。Jarock 不會開啟或轉送這些連接埠。`key.pem` 是私密檔案，絕不能公開。

發生錯誤後，讀取 `ERROR:` 或 `WARNING:` 並依照 `Suggested fix:` 操作。如果 Java 結束，檢查 `server\logs\latest.log` 與 `server\crash-reports\` 中最早的 `Caused by:`。公開前仍需完成的工作在 `TODO.md`。

> **技術說明：請一律使用儲存庫根目錄的 `start-server.bat`。不要雙擊 `server.jar`；Windows 可能使用 Java 8 或 Java 21，而 Minecraft 26.2 需要 64 位元 Java 25+。請參閱[完整英文指南](../en/how-does-jarock-work.md)。**

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> InvView 1.4.21 is a verified Minecraft 26.2 server-side Fabric mod. It requires Fabric API and lets authorized operators inspect and manage online or offline player inventories and ender chests; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> OfflineCommands 1.0.3 is a verified Minecraft 26.2 server-side Fabric mod for running commands on offline players. No compatible NeoForge 26.2 build is available, so NeoForge does not install it.

<!-- jarock-safe-shutdown -->

## 安全停止

> 輸入 `stop` 並保持視窗開啟。關閉前等待 `CLEAN SHUTDOWN COMPLETE`，再等待 `SAFE TO CLOSE`。如果沒有第二則訊息，請檢查記錄和崩潰報告，必要時還原備份。
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## 更新 Jarock

> 讀取 `scripts/version.txt`，停止伺服器並等待 `SAFE TO CLOSE`；然後執行 `scripts/update-jarock.bat`。它會在相同的 beta/穩定頻道尋找更新，要求確認並建立回復備份。世界、runtime、模組、程式庫和本機設定都會保留；只有相依項目遺失或無效時才會修復。

> 完整套件及其公開的 SHA-512 雜湊值會在安裝前驗證。

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to run the same check without starting the server. If a verified compatible Lite package is available, the updater asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## 啟動時檢查更新

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows 主控台關閉保護:** While Jarock is running, the classic Windows console may show a warning when X is clicked. 請輸入 stop 並等待 SAFE TO CLOSE。世界儲存時不要強制關閉。 This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
