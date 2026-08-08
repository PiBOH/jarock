# NeoForge フォールバックガイド

Fabric が適さない場合だけ NeoForge を最後の選択肢として使います。Forge と NeoForge は別の loader で、mod は NeoForge 対応でなければなりません。必要なら Geyser/Floodgate を追加し、最初にコピーでテストします。

英語の完全ガイドを参照: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## 安全な停止

> `stop` と入力し、ウィンドウを開いたままにしてください。閉じる前に `CLEAN SHUTDOWN COMPLETE`、続いて `SAFE TO CLOSE` を待ちます。2つ目の表示がなければログとクラッシュレポートを確認し、必要ならバックアップを復元してください。

<!-- jarock-updater -->


## Jarock の更新

> `scripts/version.txt` を確認し、サーバーを停止して `SAFE TO CLOSE` を待ってから `scripts/update-jarock.bat` を実行します。同じベータ/安定チャンネルの新しいリリースを探し、確認後にロールバック用バックアップを作成します。ワールド、ランタイム、MOD、ライブラリ、ローカル設定は保持され、依存関係は不足または無効な場合だけ修復されます。

> 完全パッケージと公開された SHA-512 チェックサムは、インストール前に検証されます。

<!-- jarock-auto-update-check -->

## 起動時の更新確認

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.

<!-- jarock-console-close-protection -->

> **Windows コンソールの終了保護:** While Jarock is running, the classic Windows console may show a warning when X is clicked. stop と入力して SAFE TO CLOSE を待ってください。ワールド保存中に強制終了しないでください。 This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
