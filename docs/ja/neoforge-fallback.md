# NeoForge フォールバックガイド

Fabric が適さない場合だけ NeoForge を最後の選択肢として使います。Forge と NeoForge は別の loader で、mod は NeoForge 対応でなければなりません。必要なら Geyser/Floodgate を追加し、最初にコピーでテストします。

英語の完全ガイドを参照: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## 安全な停止

> `stop` と入力し、ウィンドウを開いたままにしてください。閉じる前に `CLEAN SHUTDOWN COMPLETE`、続いて `SAFE TO CLOSE` を待ちます。2つ目の表示がなければログとクラッシュレポートを確認し、必要ならバックアップを復元してください。

<!-- jarock-updater -->


## Jarock の更新

> `version.txt` を確認し、サーバーを停止して `SAFE TO CLOSE` を待ってから `update-jarock.bat` を実行します。同じベータ/安定チャンネルの新しいリリースを探し、確認後にロールバック用バックアップを作成します。ワールド、ランタイム、MOD、ライブラリ、ローカル設定は保持され、依存関係は不足または無効な場合だけ修復されます。

> 完全パッケージと公開された SHA-512 チェックサムは、インストール前に検証されます。
