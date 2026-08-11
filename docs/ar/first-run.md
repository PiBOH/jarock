> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

# التشغيل الأول لـ Jarock

## قبل البدء

يوضح هذا الدليل ما يحدث عند استخدام مستودع Jarock لأول مرة. استخدم دائمًا `start-server.bat` الموجود في الجذر، ولا تفتح `server/server.jar` مباشرة. ثبّت JDK ‏64 بت بإصدار Java 25 أو أحدث، وفعّل **Set JAVA_HOME variable** في مثبت Temurin ثم أعد فتح الطرفية.

## اختيار محمّل الخادم

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## التثبيت وقبول EULA

ينزّل Jarock الـ loader والـ mods المثبتة تلقائيًا. ينشئ التشغيل الأول `server/eula.txt` ويتوقف عادةً. اقرأ Minecraft EULA، وإذا وافقت فقط غيّر `eula=false` إلى `eula=true`. لا تضبط `online-mode=false` قبل أول تشغيل ناجح؛ أكمل أول تشغيل باستخدام `online-mode=true`.

## الإيقاف الآمن

شغّل `start-server.bat` مرة أخرى ودع إنشاء العالم وGeyser وFloodgate يكتمل. للإيقاف اكتب `stop` في وحدة التحكم ولا تغلق النافذة. انتظر `CLEAN SHUTDOWN COMPLETE` ثم `SAFE TO CLOSE`؛ عندها فقط أغلقها.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## بعد التشغيل الأول

إذا لم توجد Java، ثبّت Java 25 ذات 64 بت وأعد فتح الطرفية. عند فشل التنزيل اقرأ Suggested fix وأعد المحاولة. إذا اختلط Fabric وNeoForge، خذ نسخة احتياطية وشغّل `clean-server-runtime.bat`. أبقِ `online-mode=true` واقرأ `TODO.md` قبل النشر العام.

## ملاحظة أمان

لتثبيت تحديث، أوقف الخادم بأمان وشغّل `scripts/update-jarock.bat`.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-ar -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **حماية إغلاق وحدة تحكم Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. اكتب stop وانتظر SAFE TO CLOSE. لا تغلق بالقوة أثناء حفظ العالم. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
