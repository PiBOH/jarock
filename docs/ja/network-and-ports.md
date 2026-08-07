# ネットワーク、ファイアウォール、ルーターガイド

64ビットJava 25をインストールし、`start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat`を実行してポートを開放する前に`TODO.md`を完了してください。固定LAN IPを設定し、WindowsファイアウォールでTCP `25565`（Java）とUDP `19132`（Bedrock）を開放して、ルーターでポート転送を設定するか、playit.ggのようなUDP対応トンネルを使用します。`online-mode=true`と`white-list=true`が有効であること、`key.pem`を絶対に公開しないことを確認してください。CGNATの場合はトンネルを使用してください。[英語版ガイド](../en/network-and-ports.md)を参照。

> 常に`start-server.bat`を使用し、`server.jar`をダブルクリックしないでください。

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## 安全な停止

> `stop` と入力し、ウィンドウを開いたままにしてください。閉じる前に `CLEAN SHUTDOWN COMPLETE`、続いて `SAFE TO CLOSE` を待ちます。2つ目の表示がなければログとクラッシュレポートを確認し、必要ならバックアップを復元してください。

<!-- jarock-updater -->


## Jarock の更新

> `version.txt` を確認し、サーバーを停止して `SAFE TO CLOSE` を待ってから `update-jarock.bat` を実行します。同じベータ/安定チャンネルの新しいリリースを探し、確認後にロールバック用バックアップを作成します。ワールド、ランタイム、MOD、ライブラリ、ローカル設定は保持され、依存関係は不足または無効な場合だけ修復されます。

> 完全パッケージと公開された SHA-512 チェックサムは、インストール前に検証されます。
