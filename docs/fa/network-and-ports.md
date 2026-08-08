# راهنمای شبکه، فایروال و روتر

Java 25 ۶۴بیتی را نصب کنید، `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` را اجرا و `TODO.md` را پیش از بازکردن پورت‌ها تکمیل نمایید. یک IP ثابت LAN تنظیم کرده، TCP `25565` (جاوا) و UDP `19132` (بدراک) را در فایروال ویندوز باز کنید، ارسال پورت را روی روتر پیکربندی کنید یا از تونل UDP مانند playit.gg استفاده کنید. مطمئن شوید `online-mode=true` و `white-list=true` فعال است و هرگز `key.pem` را منتشر نکنید. برای CGNAT از تونل استفاده کنید. [راهنمای انگلیسی](../en/network-and-ports.md) را ببینید.

> همیشه از `start-server.bat` استفاده کنید؛ روی `server.jar` دابل‌کلیک نکنید.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## خاموش کردن ایمن

> `stop` را وارد کنید و پنجره را باز بگذارید. پیش از بستن، منتظر `CLEAN SHUTDOWN COMPLETE` و سپس `SAFE TO CLOSE` بمانید. اگر پیام دوم ظاهر نشد، گزارش و لاگ را بررسی و در صورت نیاز نسخه پشتیبان را بازیابی کنید.

<!-- jarock-updater -->


## به‌روزرسانی Jarock

> `scripts/version.txt` را بخوانید، سرور را متوقف کنید و منتظر `SAFE TO CLOSE` بمانید؛ سپس `scripts/update-jarock.bat` را اجرا کنید. نسخه جدیدتر همان کانال بتا/پایدار را پیدا می‌کند، تأیید می‌گیرد و نسخه بازگشت می‌سازد. دنیا، runtime، modها، کتابخانه‌ها و تنظیمات محلی حفظ می‌شوند؛ وابستگی‌ها فقط در صورت مفقود یا نامعتبر بودن اصلاح می‌شوند.

> بسته کامل و چک‌سام SHA-512 منتشرشده آن پیش از نصب بررسی می‌شوند.

<!-- jarock-auto-update-check -->

## بررسی به‌روزرسانی هنگام شروع

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.

<!-- jarock-console-close-protection -->

> **محافظت در برابر بستن کنسول ویندوز:** While Jarock is running, the classic Windows console may show a warning when X is clicked. stop را وارد کنید و منتظر SAFE TO CLOSE بمانید. هنگام ذخیره جهان اجباری نبندید. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
