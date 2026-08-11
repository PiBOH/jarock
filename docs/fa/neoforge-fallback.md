# راهنمای پشتیبان NeoForge

NeoForge آخرین گزینه پس از ناسازگاری Fabric است. Forge و NeoForge loaderهای جدا هستند و mods باید مخصوص NeoForge باشند. در صورت نیاز Geyser/Floodgate را اضافه و ابتدا روی کپی آزمایش کنید.

See the [English NeoForge fallback guide](../en/neoforge-fallback.md) for the complete procedure. Verify every mod against the selected loader.

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

<!-- jarock-safe-shutdown -->

## خاموش کردن ایمن

> `stop` را وارد کنید و پنجره را باز بگذارید. پیش از بستن، منتظر `CLEAN SHUTDOWN COMPLETE` و سپس `SAFE TO CLOSE` بمانید. اگر پیام دوم ظاهر نشد، گزارش و لاگ را بررسی و در صورت نیاز نسخه پشتیبان را بازیابی کنید.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## به‌روزرسانی Jarock

> `scripts/version.txt` را بخوانید، سرور را متوقف کنید و منتظر `SAFE TO CLOSE` بمانید؛ سپس `scripts/update-jarock.bat` را اجرا کنید. نسخه جدیدتر همان کانال بتا/پایدار را پیدا می‌کند، تأیید می‌گیرد و نسخه بازگشت می‌سازد. دنیا، runtime، modها، کتابخانه‌ها و تنظیمات محلی حفظ می‌شوند؛ وابستگی‌ها فقط در صورت مفقود یا نامعتبر بودن اصلاح می‌شوند.

> بسته کامل و چک‌سام SHA-512 منتشرشده آن پیش از نصب بررسی می‌شوند.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## بررسی به‌روزرسانی هنگام شروع

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified package matching scripts/jarock-edition.ini automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **محافظت در برابر بستن کنسول ویندوز:** While Jarock is running, the classic Windows console may show a warning when X is clicked. stop را وارد کنید و منتظر SAFE TO CLOSE بمانید. هنگام ذخیره جهان اجباری نبندید. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
