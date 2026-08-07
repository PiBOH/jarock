# Jarock はどのように動作しますか？

## サーバーの仕組みを簡単に説明

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**ローダー:** Fabric
**主なプラットフォーム:** Windows 10/11

このドキュメントでは、Jarock をダウンロードした後に実際に何が起きるかを説明します。


> DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512.

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
