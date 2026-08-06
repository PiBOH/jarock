# ネットワーク、ファイアウォール、ルーターガイド

64ビットJava 25をインストールし、`start-server.bat`を実行してポートを開放する前に`TODO.md`を完了してください。固定LAN IPを設定し、WindowsファイアウォールでTCP `25565`（Java）とUDP `19132`（Bedrock）を開放して、ルーターでポート転送を設定するか、playit.ggのようなUDP対応トンネルを使用します。`online-mode=true`と`white-list=true`が有効であること、`key.pem`を絶対に公開しないことを確認してください。CGNATの場合はトンネルを使用してください。[英語版ガイド](../en/network-and-ports.md)を参照。

> 常に`start-server.bat`を使用し、`server.jar`をダブルクリックしないでください。
