# راهنمای سرور Fabric

Java 25 شصت‌وچهاربیتی را نصب کنید، `start-server.bat` را اجرا کنید و با `parameter-manager.bat` حافظه و GUI یا `nogui` را تنظیم کنید. (enable "Set JAVA_HOME variable" in the Temurin installer) `server/eula.txt` را بخوانید و بعد از پذیرش EULA مقدار `eula=true` را بگذارید. از Fabric، Geyser-Fabric و Floodgate-Fabric استفاده و backup تهیه کنید. Jarock روتر، firewall یا port forwarding را تغییر نمی‌دهد.

See the [English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **نکتهٔ فنی: همیشه از `start-server.bat` در ریشهٔ repository استفاده کنید. روی `server.jar` دوبار کلیک نکنید؛ Windows ممکن است Java 8 یا Java 21 را اجرا کند، در حالی که Minecraft 26.2 به Java 25+ شصت‌وچهاربیتی نیاز دارد. [راهنمای کامل انگلیسی](../en/server-guide.md) را ببینید.**

<!-- jarock-safe-shutdown -->

## خاموش کردن ایمن

> `stop` را وارد کنید و پنجره را باز بگذارید. پیش از بستن، منتظر `CLEAN SHUTDOWN COMPLETE` و سپس `SAFE TO CLOSE` بمانید. اگر پیام دوم ظاهر نشد، گزارش و لاگ را بررسی و در صورت نیاز نسخه پشتیبان را بازیابی کنید.

<!-- jarock-updater -->


## به‌روزرسانی Jarock

> `version.txt` را بخوانید، سرور را متوقف کنید و منتظر `SAFE TO CLOSE` بمانید؛ سپس `update-jarock.bat` را اجرا کنید. نسخه جدیدتر همان کانال بتا/پایدار را پیدا می‌کند، تأیید می‌گیرد و نسخه بازگشت می‌سازد. دنیا، runtime، modها، کتابخانه‌ها و تنظیمات محلی حفظ می‌شوند؛ وابستگی‌ها فقط در صورت مفقود یا نامعتبر بودن اصلاح می‌شوند.

> بسته کامل و چک‌سام SHA-512 منتشرشده آن پیش از نصب بررسی می‌شوند.

<!-- jarock-auto-update-check -->

## بررسی به‌روزرسانی هنگام شروع

در parameter-manager.bat مقدار AUTO_UPDATE_CHECK=true را تنظیم کنید تا start-server.bat انتشارهای GitHub را فقط خواندنی بررسی کند. نسخه سازگار جدیدتر را گزارش می‌کند، اما خودکار چیزی نصب نمی‌کند. سرور را ایمن متوقف کنید، منتظر SAFE TO CLOSE بمانید و update-jarock.bat را اجرا کنید. مقدار پیش‌فرض AUTO_UPDATE_CHECK=false است.
