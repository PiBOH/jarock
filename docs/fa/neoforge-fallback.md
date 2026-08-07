# راهنمای پشتیبان NeoForge

NeoForge آخرین گزینه پس از ناسازگاری Fabric است. Forge و NeoForge loaderهای جدا هستند و mods باید مخصوص NeoForge باشند. در صورت نیاز Geyser/Floodgate را اضافه و ابتدا روی کپی آزمایش کنید.

See the [English NeoForge fallback guide](../en/neoforge-fallback.md) for the complete procedure. Verify every mod against the selected loader.

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
