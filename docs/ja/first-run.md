# Jarock の初回起動

## loader の選択

64 ビット版 Java 25 以降の JDK をインストールし、Temurin のインストーラーで JAVA_HOME を有効にして、ターミナルを再起動してください。必ずルートの `start-server.bat` en `scripts/server-launch-settings.ini` を実行し、`server/server.jar` を直接開かないでください。

## インストールと EULA

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## 安全な停止

Jarock は loader と固定された mod を自動でダウンロードします。初回実行では `server/eula.txt` が作成され、通常停止します。Minecraft EULA を読み、同意する場合だけ `eula=false` を `eula=true` に変更してください。初回成功前に `online-mode=false` を設定しないでください。

## 安全な停止

もう一度起動し、world、Geyser、Floodgate の読み込みを待ちます。停止するには `stop` と入力し、`CLEAN SHUTDOWN COMPLETE` と `SAFE TO CLOSE` が表示されるまでウィンドウを閉じないでください。エラー時は Suggested fix に従い、loader が混在したらバックアップ後 `clean-server-runtime.bat` を実行し、公開前に `TODO.md` を読んでください。
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## 安全に関する注意

通常の認証を使用するため、初回実行は `online-mode=true` で完了してください。

## 安全に関する注意

更新をインストールするには、サーバーを安全に停止して `scripts/update-jarock.bat` を実行してください。

<!-- jarock-lan-addresses-ja -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Windows コンソールの終了保護:** While Jarock is running, the classic Windows console may show a warning when X is clicked. stop と入力して SAFE TO CLOSE を待ってください。ワールド保存中に強制終了しないでください。 This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
