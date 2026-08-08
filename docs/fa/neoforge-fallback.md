# راهنمای پشتیبان NeoForge

NeoForge آخرین گزینه پس از ناسازگاری Fabric است. Forge و NeoForge loaderهای جدا هستند و mods باید مخصوص NeoForge باشند. در صورت نیاز Geyser/Floodgate را اضافه و ابتدا روی کپی آزمایش کنید.

See the [English NeoForge fallback guide](../en/neoforge-fallback.md) for the complete procedure. Verify every mod against the selected loader.

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
