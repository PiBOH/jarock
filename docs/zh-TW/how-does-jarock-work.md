# Jarock 如何運作？

## 伺服器運作方式簡介

**Minecraft：** Java Edition `26.2`
**載入器：** Fabric
**主要平台：** Windows 10/11

本文件說明下載 Jarock 後實際會發生什麼事。

> **維護說明：** 啟動器現在會尋找相容的 64 位元 Java 25+ 執行環境，而不是只信任 `PATH` 中第一個 `java.exe`。它使用 `scripts/java-runtime.ps1`，將選取的執行檔儲存到 `server/java-path.txt`，並在啟動前再次驗證。Java 8 可以繼續安裝。

## 1. 簡要流程

使用者安裝 64 位元 Java，下載這個 repository，然後執行 `start-server.bat`。程式會找到自己的資料夾，檢查 Java 與路徑；需要時會要求啟用 Windows 長路徑支援；接著下載固定版本的 Fabric 安裝器與 mods，並使用 SHA-512 驗證每個檔案。

Fabric 會在 `server/` 建立執行環境。第一次執行會建立 `server/eula.txt`，內容為 `eula=false`，然後停止。使用者必須閱讀 <https://www.minecraft.net/eula>，同意後改成 `eula=true`，再執行一次。Geyser 轉換 Bedrock 流量，Floodgate 處理 Bedrock 驗證。

Jarock **不會**設定路由器、防火牆或 port forwarding。

## 2. 檔案與目錄

repository 包含 scripts、範本與 manifest，不包含世界或產生的 `.jar`：

```text
start-server.bat
scripts/bootstrap-fabric.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
version.txt
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
