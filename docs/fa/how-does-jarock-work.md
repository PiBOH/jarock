# Jarock چگونه کار می‌کند؟

## توضیح سادهٔ سرور

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**لودر:** Fabric
**پلتفرم اصلی:** Windows 10/11

این سند توضیح می‌دهد پس از دانلود Jarock چه اتفاقی می‌افتد.


> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **یادداشت نگهداری:** اجراکننده اکنون به‌جای اعتماد به اولین `java.exe` در `PATH`، یک Java 25+ سازگار و 64 بیتی را پیدا می‌کند. از `scripts/java-runtime.ps1` استفاده می‌کند، فایل اجرایی انتخاب‌شده را در `server/java-path.txt` ذخیره می‌کند و پیش از اجرا آن را اعتبارسنجی می‌کند. Java 8 می‌تواند نصب‌شده باقی بماند.

## ۱. خلاصه

کاربر Java شصت‌وچهاربیتی را نصب می‌کند، این repository را دانلود می‌کند و `start-server.bat` را اجرا می‌کند. برنامه پوشهٔ خودش را پیدا می‌کند، Java و مسیر را بررسی می‌کند، در صورت نیاز فعال‌سازی مسیرهای طولانی Windows را درخواست می‌کند، سپس Fabric و mods نسخه‌بندی‌شده را دانلود کرده و هر فایل را با SHA-512 بررسی می‌کند.

Fabric محیط اجرا را در `server/` می‌سازد. اجرای اول `server/eula.txt` را با `eula=false` ایجاد و متوقف می‌شود. کاربر باید <https://www.minecraft.net/eula> را بخواند، در صورت موافقت آن را به `eula=true` تغییر دهد و دوباره اجرا کند. Geyser ترافیک Bedrock را ترجمه می‌کند و Floodgate احراز هویت Bedrock را انجام می‌دهد.

Jarock **روتر، فایروال یا port forwarding را تنظیم نمی‌کند**.

## ۲. فایل‌ها و روند اجرا

repository شامل scriptها، templateها و manifest است، اما world یا فایل‌های `.jar` تولیدشده را ندارد:

```text
start-server.bat
scripts/bootstrap-fabric.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
version.txt
CHANGELOG.md
TODO.md
```

محیط اجرا در `server/` ایجاد می‌شود. worldها، logها، کتابخانه‌ها، کلیدهای خصوصی و فهرست‌های محلی توسط Git نادیده گرفته می‌شوند.

`start-server.bat` از محل واقعی خودش استفاده می‌کند و به مسیر ثابتی مانند `C:\MinecraftServer` وابسته نیست. مسیرهای قابل‌دسترسی شامل فاصله، Unicode، `!` و پوشه‌های تو‌در‌تو پشتیبانی می‌شوند. برای مسیرهای طولانی این مقدار بررسی می‌شود:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

در صورت نیاز، script دسترسی administrator می‌خواهد و `scripts\enable-long-paths.ps1` را اجرا می‌کند. این تغییر برای کل سیستم است و ممکن است restart Windows لازم باشد.

## ۳. EULA، Geyser و خطاها

اجرای اول `server/eula.txt` را با `eula=false` می‌سازد و متوقف می‌شود. EULA را بخوانید، در صورت موافقت آن را به `eula=true` تغییر دهید و دوباره اجرا کنید.

Geyser پیکربندی کامل خود را هنگام اولین اجرای واقعی سرور ایجاد می‌کند. سپس script در:

```text
server\config\Geyser-Fabric\config.yml
```

این مقدار را قرار می‌دهد:

```yaml
auth-type: floodgate
```

Java معمولاً از TCP `25565` و Bedrock از UDP `19132` استفاده می‌کند. Jarock هیچ پورتی را باز نمی‌کند. `key.pem` خصوصی است و نباید منتشر شود.

پس از هر خطا، `ERROR:` یا `WARNING:` را بخوانید و `Suggested fix:` را انجام دهید. اگر Java متوقف شد، اولین `Caused by:` را در `server\logs\latest.log` یا `server\crash-reports\` بررسی کنید. کارهای باقی‌مانده در `TODO.md` هستند.

> **نکتهٔ فنی: همیشه از `start-server.bat` در ریشهٔ repository استفاده کنید. روی `server.jar` دوبار کلیک نکنید؛ Windows ممکن است Java 8 یا Java 21 را اجرا کند، در حالی که Minecraft 26.2 به Java 25+ شصت‌وچهاربیتی نیاز دارد. [راهنمای کامل انگلیسی](../en/how-does-jarock-work.md) را ببینید.**
