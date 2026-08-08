# راهنمای سرور Fabric

Java 25 شصت‌وچهاربیتی را نصب کنید، `start-server.bat` را اجرا کنید و با `parameter-manager.bat` حافظه و GUI یا `nogui` را تنظیم کنید. (enable "Set JAVA_HOME variable" in the Temurin installer) `server/eula.txt` را بخوانید و بعد از پذیرش EULA مقدار `eula=true` را بگذارید. از Fabric، Geyser-Fabric و Floodgate-Fabric استفاده و backup تهیه کنید. Jarock روتر، firewall یا port forwarding را تغییر نمی‌دهد.

See the [English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


Jarock never moves, renames, deletes or replaces an existing world automatically. If Minecraft reports a world-integrity or generation error, stop safely, inspect the logs and crash report, and restore the world from a known-good backup. A fresh world is generated only after you deliberately delete the existing `world`, `world_nether` and `world_the_end` folders yourself. If only some of `world`, `world_nether` and `world_the_end` exist, Jarock refuses to start to prevent mixing old and new dimensions; restore all three from a backup or deliberately delete all three to create a new world. Java stores the Nether and End inside the configured `level-name` folder as `DIM-1` and `DIM1`. If that configured folder exists, Jarock leaves it untouched and lets Minecraft load it or report its integrity error. A new world is possible only when the configured folder is absent and no other possible old world folder remains; after a `level-name` change, Jarock refuses to start instead of silently replacing an existing world.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Show ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **نکتهٔ فنی: همیشه از `start-server.bat` در ریشهٔ repository استفاده کنید. روی `server.jar` دوبار کلیک نکنید؛ Windows ممکن است Java 8 یا Java 21 را اجرا کند، در حالی که Minecraft 26.2 به Java 25+ شصت‌وچهاربیتی نیاز دارد. [راهنمای کامل انگلیسی](../en/server-guide.md) را ببینید.**



<!-- jarock-lan-addresses-fa -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-safe-shutdown -->

## خاموش کردن ایمن

> `stop` را وارد کنید و پنجره را باز بگذارید. پیش از بستن، منتظر `CLEAN SHUTDOWN COMPLETE` و سپس `SAFE TO CLOSE` بمانید. اگر پیام دوم ظاهر نشد، گزارش و لاگ را بررسی و در صورت نیاز نسخه پشتیبان را بازیابی کنید.

<!-- jarock-updater -->


## به‌روزرسانی Jarock

> `scripts/version.txt` را بخوانید، سرور را متوقف کنید و منتظر `SAFE TO CLOSE` بمانید؛ سپس `scripts/update-jarock.bat` را اجرا کنید. نسخه جدیدتر همان کانال بتا/پایدار را پیدا می‌کند، تأیید می‌گیرد و نسخه بازگشت می‌سازد. دنیا، runtime، modها، کتابخانه‌ها و تنظیمات محلی حفظ می‌شوند؛ وابستگی‌ها فقط در صورت مفقود یا نامعتبر بودن اصلاح می‌شوند.

> بسته کامل و چک‌سام SHA-512 منتشرشده آن پیش از نصب بررسی می‌شوند.

<!-- jarock-auto-update-check -->

## بررسی به‌روزرسانی هنگام شروع

Startup update modes: AUTO_UPDATE_MODE=auto checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.
