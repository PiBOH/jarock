# راهنمای سرور Fabric

Java 25 شصت‌وچهاربیتی را نصب کنید، `start-server.bat` را اجرا کنید و با `parameter-manager.bat` حافظه و GUI یا `nogui` را تنظیم کنید. (enable "Set JAVA_HOME variable" in the Temurin installer) `server/eula.txt` را بخوانید و بعد از پذیرش EULA مقدار `eula=true` را بگذارید. از Fabric، Geyser-Fabric و Floodgate-Fabric استفاده و backup تهیه کنید. Jarock روتر، firewall یا port forwarding را تغییر نمی‌دهد.

See the [English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **نکتهٔ فنی: همیشه از `start-server.bat` در ریشهٔ repository استفاده کنید. روی `server.jar` دوبار کلیک نکنید؛ Windows ممکن است Java 8 یا Java 21 را اجرا کند، در حالی که Minecraft 26.2 به Java 25+ شصت‌وچهاربیتی نیاز دارد. [راهنمای کامل انگلیسی](../en/server-guide.md) را ببینید.**
