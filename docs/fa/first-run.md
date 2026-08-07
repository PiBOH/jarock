# اجرای نخست Jarock

## پیش از شروع

این راهنما اولین اجرای مخزن تازه Jarock را توضیح می‌دهد. همیشه `start-server.bat` ریشه را اجرا کنید و `server/server.jar` را مستقیم باز نکنید. JDK شصت‌وچهار بیتی Java 25 یا جدیدتر نصب کنید، گزینه **Set JAVA_HOME variable** را در نصب‌کننده Temurin فعال کنید و ترمینال را دوباره باز کنید.

## انتخاب loader

اجرای `start-server.bat` Java، مسیرها و `scripts/server-launch-settings.ini` را بررسی می‌کند و تنظیمات قدیمی ریشه را منتقل می‌کند. Fabric (پیشنهادی)، NeoForge (جایگزین) یا Forge (فعلاً برای Minecraft 26.2 موجود نیست) را انتخاب کنید. `parameter-manager.bat` برای RAM، GUI، GC، `online-mode`، بنر و `AUTO_UPDATE_CHECK` است؛ **Exit without saving** بدون ذخیره لغو می‌کند.

## نصب و EULA

loader و modهای ثابت خودکار دانلود می‌شوند. اجرای نخست `server/eula.txt` را ایجاد و معمولاً متوقف می‌شود. EULA ماینکرفت را بخوانید و فقط در صورت موافقت `eula=false` را به `eula=true` تغییر دهید. قبل از نخستین اجرای موفق `online-mode=false` نگذارید؛ ابتدا با `online-mode=true` اجرا کنید.

## خاموش‌کردن امن

دوباره `start-server.bat` را اجرا کنید و منتظر پایان ساخت world، Geyser و Floodgate بمانید. برای توقف `stop` را وارد کنید و منتظر `CLEAN SHUTDOWN COMPLETE` و `SAFE TO CLOSE` بمانید.

## پس از اجرای نخست

در نبود Java، Java 25 شصت‌وچهار بیتی نصب کنید. برای خطاها Suggested fix را اجرا کنید. در صورت ترکیب loaderها نسخه پشتیبان بگیرید و `clean-server-runtime.bat` را اجرا کنید. پیش از عمومی‌کردن `TODO.md` را بخوانید.

## یادداشت ایمنی

برای نصب به‌روزرسانی، سرور را ایمن متوقف کنید و `scripts/update-jarock.bat` را اجرا کنید.
