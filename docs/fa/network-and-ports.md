# راهنمای شبکه، فایروال و روتر

Java 25 ۶۴بیتی را نصب کنید، `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` را اجرا و `TODO.md` را پیش از بازکردن پورت‌ها تکمیل نمایید. یک IP ثابت LAN تنظیم کرده، TCP `25565` (جاوا) و UDP `19132` (بدراک) را در فایروال ویندوز باز کنید، ارسال پورت را روی روتر پیکربندی کنید یا از تونل UDP مانند playit.gg استفاده کنید. مطمئن شوید `online-mode=true` و `white-list=true` فعال است و هرگز `key.pem` را منتشر نکنید. برای CGNAT از تونل استفاده کنید. [راهنمای انگلیسی](../en/network-and-ports.md) را ببینید.

> همیشه از `start-server.bat` استفاده کنید؛ روی `server.jar` دابل‌کلیک نکنید.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.
