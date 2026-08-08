# Fabric サーバーガイド

64 ビット Java 25 をインストールし、`start-server.bat` を実行して `parameter-manager.bat` で RAM と GUI または `nogui` を設定します。`server/eula.txt` を読み、EULA に同意して `eula=true` にし、Fabric、Geyser-Fabric、Floodgate-Fabric を使い、バックアップを作成してください。Jarock はルーター、ファイアウォール、port forwarding を変更しません。 (enable "Set JAVA_HOME variable" in the Temurin installer)

英語の完全ガイドを参照: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Show ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **技術メモ: 必ずリポジトリのルートにある `start-server.bat` を使用してください。`server.jar` をダブルクリックしないでください。Windows が Java 8 または Java 21 を使う可能性がありますが、Minecraft 26.2 には 64 ビット Java 25 以降が必要です。[英語の完全ガイド](../en/server-guide.md)を参照してください。**



<!-- jarock-lan-addresses-ja -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-safe-shutdown -->

## 安全な停止

> `stop` と入力し、ウィンドウを開いたままにしてください。閉じる前に `CLEAN SHUTDOWN COMPLETE`、続いて `SAFE TO CLOSE` を待ちます。2つ目の表示がなければログとクラッシュレポートを確認し、必要ならバックアップを復元してください。

<!-- jarock-updater -->


## Jarock の更新

> `scripts/version.txt` を確認し、サーバーを停止して `SAFE TO CLOSE` を待ってから `scripts/update-jarock.bat` を実行します。同じベータ/安定チャンネルの新しいリリースを探し、確認後にロールバック用バックアップを作成します。ワールド、ランタイム、MOD、ライブラリ、ローカル設定は保持され、依存関係は不足または無効な場合だけ修復されます。

> 完全パッケージと公開された SHA-512 チェックサムは、インストール前に検証されます。

<!-- jarock-auto-update-check -->

## 起動時の更新確認

Startup update modes: AUTO_UPDATE_MODE=auto checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.
