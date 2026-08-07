# راهنمای شبکه، فایروال و روتر

Java 25 ۶۴بیتی را نصب کنید، `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` را اجرا و `TODO.md` را پیش از بازکردن پورت‌ها تکمیل نمایید. یک IP ثابت LAN تنظیم کرده، TCP `25565` (جاوا) و UDP `19132` (بدراک) را در فایروال ویندوز باز کنید، ارسال پورت را روی روتر پیکربندی کنید یا از تونل UDP مانند playit.gg استفاده کنید. مطمئن شوید `online-mode=true` و `white-list=true` فعال است و هرگز `key.pem` را منتشر نکنید. برای CGNAT از تونل استفاده کنید. [راهنمای انگلیسی](../en/network-and-ports.md) را ببینید.

> همیشه از `start-server.bat` استفاده کنید؛ روی `server.jar` دابل‌کلیک نکنید.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

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
