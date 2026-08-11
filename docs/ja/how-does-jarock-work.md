# Jarock はどのように動作しますか？

## サーバーの仕組みを簡単に説明

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**ローダー:** Fabric
**主なプラットフォーム:** Windows 10/11

このドキュメントでは、Jarock をダウンロードした後に実際に何が起きるかを説明します。


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome Message 2.8 with its required Collective library is included as a verified server-side Minecraft 26.2 mod for Fabric and NeoForge; it sends configurable join messages.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **メンテナンスメモ:** ランチャーは `PATH` の最初の `java.exe` だけに依存せず、互換性のある 64 ビット Java 25 以降を探します。`scripts/java-runtime.ps1` を使用し、選択した実行ファイルを `server/java-path.txt` に保存して起動前に検証します。Java 8 はインストールしたままでも構いません。

## 1. 概要

ユーザーは対応する 64 ビット Java をインストールし、この repository をダウンロードして `start-server.bat` を実行します。プログラムは自分自身のフォルダーを見つけ、Java とパスを確認し、必要なら Windows の長いパスを有効にするよう求め、固定された Fabric installer と mods をダウンロードし、各ファイルを SHA-512 で検証します。

Fabric は `server/` に runtime を作成します。初回実行では `server/eula.txt` が `eula=false` で作成され、停止します。ユーザーは <https://www.minecraft.net/eula> を読み、同意する場合は `eula=true` に変更して、もう一度実行します。Geyser は Bedrock の通信を変換し、Floodgate は Bedrock の認証を処理します。

Jarock は router、firewall、port forwarding を**設定しません**。

## 2. ファイルと流れ

repository には scripts、テンプレート、manifest が含まれますが、ワールドや生成された `.jar` ファイルは含まれません。

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

runtime は `server/` に作られます。ワールド、logs、ライブラリ、秘密鍵、ローカルリストは Git から除外されます。

`start-server.bat` は `C:\MinecraftServer` のような固定パスではなく、自分の場所を使用します。そのため、スペース、Unicode、`!`、入れ子のフォルダーを含むアクセス可能なパスに対応します。長いパスの場合は次を確認します。

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

必要なら管理者権限を要求し、`scripts\enable-long-paths.ps1` を実行します。この変更はコンピューター全体に適用され、古いアプリケーションでは Windows の再起動が必要になる場合があります。

## 3. EULA、Geyser、エラー

初回実行では `server/eula.txt` が `eula=false` で作成されて停止します。EULA を読み、同意する場合は `eula=true` に変更して再実行します。

Geyser は最初の実際のサーバー起動時に完全な設定を生成します。その後、次のファイルに対してスクリプトが設定します。

```text
server\config\Geyser-Fabric\config.yml
```

```yaml
auth-type: floodgate
```

Java は通常 TCP `25565`、Bedrock は UDP `19132` を使用します。Jarock はポートを開きません。`key.pem` は秘密情報なので公開しないでください。

エラーが発生したら `ERROR:` または `WARNING:` を読み、`Suggested fix:` に従ってください。Java が終了した場合は `server\logs\latest.log` または `server\crash-reports\` の最初の `Caused by:` を確認します。残りの作業は `TODO.md` にあります。

> **技術メモ: 必ずリポジトリのルートにある `start-server.bat` を使用してください。`server.jar` をダブルクリックしないでください。Windows が Java 8 または Java 21 を使う可能性がありますが、Minecraft 26.2 には 64 ビット Java 25 以降が必要です。[英語の完全ガイド](../en/how-does-jarock-work.md)を参照してください。**

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> InvView 1.4.21 is a verified Minecraft 26.2 server-side Fabric mod. It requires Fabric API and lets authorized operators inspect and manage online or offline player inventories and ender chests; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> OfflineCommands 1.0.3 is a verified Minecraft 26.2 server-side Fabric mod for running commands on offline players. No compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

<!-- jarock-safe-shutdown -->

## 安全な停止

> `stop` と入力し、ウィンドウを開いたままにしてください。閉じる前に `CLEAN SHUTDOWN COMPLETE`、続いて `SAFE TO CLOSE` を待ちます。2つ目の表示がなければログとクラッシュレポートを確認し、必要ならバックアップを復元してください。
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Jarock の更新

> `scripts/version.txt` を確認し、サーバーを停止して `SAFE TO CLOSE` を待ってから `scripts/update-jarock.bat` を実行します。同じベータ/安定チャンネルの新しいリリースを探し、確認後にロールバック用バックアップを作成します。ワールド、ランタイム、MOD、ライブラリ、ローカル設定は保持され、依存関係は不足または無効な場合だけ修復されます。

> 完全パッケージと公開された SHA-512 チェックサムは、インストール前に検証されます。

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## 起動時の更新確認

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified package matching scripts/jarock-edition.ini automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows コンソールの終了保護:** While Jarock is running, the classic Windows console may show a warning when X is clicked. stop と入力して SAFE TO CLOSE を待ってください。ワールド保存中に強制終了しないでください。 Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
