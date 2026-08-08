# اجرای نخست Jarock

## پیش از شروع

این راهنما اولین اجرای مخزن تازه Jarock را توضیح می‌دهد. همیشه `start-server.bat` ریشه را اجرا کنید و `server/server.jar` را مستقیم باز نکنید. JDK شصت‌وچهار بیتی Java 25 یا جدیدتر نصب کنید، گزینه **Set JAVA_HOME variable** را در نصب‌کننده Temurin فعال کنید و ترمینال را دوباره باز کنید.

## انتخاب loader

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.

## نصب و EULA

loader و modهای ثابت خودکار دانلود می‌شوند. اجرای نخست `server/eula.txt` را ایجاد و معمولاً متوقف می‌شود. EULA ماینکرفت را بخوانید و فقط در صورت موافقت `eula=false` را به `eula=true` تغییر دهید. قبل از نخستین اجرای موفق `online-mode=false` نگذارید؛ ابتدا با `online-mode=true` اجرا کنید.

## خاموش‌کردن امن

دوباره `start-server.bat` را اجرا کنید و منتظر پایان ساخت world، Geyser و Floodgate بمانید. برای توقف `stop` را وارد کنید و منتظر `CLEAN SHUTDOWN COMPLETE` و `SAFE TO CLOSE` بمانید.

## پس از اجرای نخست

در نبود Java، Java 25 شصت‌وچهار بیتی نصب کنید. برای خطاها Suggested fix را اجرا کنید. در صورت ترکیب loaderها نسخه پشتیبان بگیرید و `clean-server-runtime.bat` را اجرا کنید. پیش از عمومی‌کردن `TODO.md` را بخوانید.

## یادداشت ایمنی

برای نصب به‌روزرسانی، سرور را ایمن متوقف کنید و `scripts/update-jarock.bat` را اجرا کنید.

<!-- jarock-lan-addresses-fa -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.
