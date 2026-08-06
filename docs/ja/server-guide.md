# Fabric サーバーガイド

64 ビット Java 25 をインストールし、`start-server.bat` を実行して `parameter-manager.bat` で RAM と GUI または `nogui` を設定します。`server/eula.txt` を読み、EULA に同意して `eula=true` にし、Fabric、Geyser-Fabric、Floodgate-Fabric を使い、バックアップを作成してください。Jarock はルーター、ファイアウォール、port forwarding を変更しません。 (enable "Set JAVA_HOME variable" in the Temurin installer)

英語の完全ガイドを参照: [../en/server-guide.md](../en/server-guide.md)


> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **技術メモ: 必ずリポジトリのルートにある `start-server.bat` を使用してください。`server.jar` をダブルクリックしないでください。Windows が Java 8 または Java 21 を使う可能性がありますが、Minecraft 26.2 には 64 ビット Java 25 以降が必要です。[英語の完全ガイド](../en/server-guide.md)を参照してください。**
