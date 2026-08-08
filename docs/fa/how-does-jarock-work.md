# Jarock چگونه کار می‌کند؟

## توضیح سادهٔ سرور

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**لودر:** Fabric
**پلتفرم اصلی:** Windows 10/11

این سند توضیح می‌دهد پس از دانلود Jarock چه اتفاقی می‌افتد.


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome Message 2.8 with its required Collective library is included as a verified server-side Minecraft 26.2 mod for Fabric and NeoForge; it sends configurable join messages.

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
scripts/bootstrap-server.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
scripts/version.txt
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

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> InvView 1.4.21 is a verified Minecraft 26.2 server-side Fabric mod. It requires Fabric API and lets authorized operators inspect and manage online or offline player inventories and ender chests; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> OfflineCommands 1.0.3 is a verified Minecraft 26.2 server-side Fabric mod for running commands on offline players. No compatible NeoForge 26.2 build is available, so NeoForge does not install it.

<!-- jarock-safe-shutdown -->

## خاموش کردن ایمن

> `stop` را وارد کنید و پنجره را باز بگذارید. پیش از بستن، منتظر `CLEAN SHUTDOWN COMPLETE` و سپس `SAFE TO CLOSE` بمانید. اگر پیام دوم ظاهر نشد، گزارش و لاگ را بررسی و در صورت نیاز نسخه پشتیبان را بازیابی کنید.

<!-- jarock-updater -->


## به‌روزرسانی Jarock

> `scripts/version.txt` را بخوانید، سرور را متوقف کنید و منتظر `SAFE TO CLOSE` بمانید؛ سپس `scripts/update-jarock.bat` را اجرا کنید. نسخه جدیدتر همان کانال بتا/پایدار را پیدا می‌کند، تأیید می‌گیرد و نسخه بازگشت می‌سازد. دنیا، runtime، modها، کتابخانه‌ها و تنظیمات محلی حفظ می‌شوند؛ وابستگی‌ها فقط در صورت مفقود یا نامعتبر بودن اصلاح می‌شوند.

> بسته کامل و چک‌سام SHA-512 منتشرشده آن پیش از نصب بررسی می‌شوند.

<!-- jarock-auto-update-check -->

## بررسی به‌روزرسانی هنگام شروع

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **محافظت در برابر بستن کنسول ویندوز:** While Jarock is running, the classic Windows console may show a warning when X is clicked. stop را وارد کنید و منتظر SAFE TO CLOSE بمانید. هنگام ذخیره جهان اجباری نبندید. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
