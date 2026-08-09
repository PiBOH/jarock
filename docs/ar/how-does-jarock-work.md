# كيف يعمل Jarock؟

## شرح مبسط للخادم

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**المحمّل:** Fabric
**المنصة الرئيسية:** Windows 10/11

يشرح هذا المستند ما يحدث بعد تنزيل Jarock.


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome Message 2.8 with its required Collective library is included as a verified server-side Minecraft 26.2 mod for Fabric and NeoForge; it sends configurable join messages.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **ملاحظة صيانة:** يبحث المشغّل الآن عن Java 25 أو أحدث بإصدار 64-bit بدلاً من الاعتماد على أول `java.exe` في `PATH`. يستخدم `scripts/java-runtime.ps1` ويحفظ المسار المختار في `server/java-path.txt` ويتحقق منه قبل التشغيل. يمكن أن تبقى Java 8 مثبتة.

## 1. الملخص

يثبّت المستخدم Java بنسخة 64-bit، ثم ينزّل هذا repository ويشغّل `start-server.bat`. يحدد البرنامج مجلده تلقائياً، ويتحقق من Java والمسار، ويطلب تفعيل المسارات الطويلة في Windows عند الحاجة، ثم ينزّل Fabric والـ mods المثبتة ويتحقق من كل ملف باستخدام SHA-512.

ينشئ Fabric بيئة التشغيل داخل `server/`. في التشغيل الأول يتم إنشاء `server/eula.txt` بالقيمة `eula=false` ثم يتوقف البرنامج. يجب قراءة <https://www.minecraft.net/eula> وتغييرها إلى `eula=true` عند الموافقة، ثم تشغيل الملف مرة أخرى. يترجم Geyser حركة Bedrock ويتولى Floodgate مصادقة لاعبي Bedrock.

Jarock **لا** يضبط router أو firewall أو port forwarding.

## 2. الملفات والتدفق

يحتوي repository على scripts وقوالب وmanifest، لكنه لا يحتوي العالم أو ملفات `.jar` الناتجة:

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

يتم إنشاء بيئة التشغيل في `server/`، بينما يتم تجاهل العوالم وlogs والمكتبات والمفاتيح الخاصة والقوائم المحلية بواسطة Git.

يستخدم `start-server.bat` موقعه الفعلي بدلاً من مسار ثابت مثل `C:\MinecraftServer`، لذلك يدعم المسارات المتاحة التي تحتوي مسافات أو Unicode أو `!`. للمسارات العميقة يتحقق من:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

إذا لزم الأمر يطلب صلاحيات administrator ويشغّل `scripts\enable-long-paths.ps1`. هذا تغيير عام على الجهاز وقد يتطلب إعادة التشغيل.

بعد ذلك يتحقق من `java -version` و`server\mods-manifest.ps1` وFabric 26.2 مع Loader `0.19.3` وجميع SHA-512. لا يستبدل الإعدادات المحلية الموجودة.

## 3. EULA وGeyser والأخطاء

ينشئ التشغيل الأول `server/eula.txt` بالقيمة `eula=false`. اقرأ اتفاقية EULA وغيّرها إلى `eula=true` إذا وافقت، ثم شغّل الملف مرة ثانية.

ينشئ Geyser ملف الإعداد الكامل أثناء أول تشغيل حقيقي. بعد إنشاء:

```text
server\config\Geyser-Fabric\config.yml
```

يضع السكربت:

```yaml
auth-type: floodgate
```

عادةً تستخدم Java المنفذ TCP `25565` وBedrock المنفذ UDP `19132`. لا يفتح Jarock أي منفذ. الملف `key.pem` سري ولا يجوز نشره.

بعد أي خطأ اقرأ `ERROR:` أو `WARNING:` واتبع `Suggested fix:`. إذا توقف Java، ابحث عن أول `Caused by:` في `server\logs\latest.log` أو `server\crash-reports\`. المهام المتبقية قبل النشر موجودة في `TODO.md`.

> **ملاحظة تقنية: استخدم دائماً `start-server.bat` الموجود في جذر repository. لا تنقر نقراً مزدوجاً على `server.jar`؛ فقد يستخدم Windows Java 8 أو Java 21، بينما يتطلب Minecraft 26.2 إصدار Java 25+ ‏64-bit. راجع [الشرح الإنجليزي الكامل](../en/how-does-jarock-work.md).**

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> InvView 1.4.21 is a verified Minecraft 26.2 server-side Fabric mod. It requires Fabric API and lets authorized operators inspect and manage online or offline player inventories and ender chests; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> OfflineCommands 1.0.3 is a verified Minecraft 26.2 server-side Fabric mod for running commands on offline players. No compatible NeoForge 26.2 build is available, so NeoForge does not install it.

<!-- jarock-safe-shutdown -->

## إيقاف التشغيل الآمن

> اكتب `stop` في وحدة التحكم واترك النافذة مفتوحة. انتظر `CLEAN SHUTDOWN COMPLETE` ثم `SAFE TO CLOSE` قبل إغلاقها. إذا غابت الرسالة الثانية، افحص السجل وتقرير التعطل واستعد نسخة احتياطية عند الحاجة.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## تحديث Jarock

> اقرأ `scripts/version.txt`، أوقف الخادم وانتظر `SAFE TO CLOSE`، ثم شغّل `scripts/update-jarock.bat`. يبحث عن إصدار أحدث في القناة نفسها، يطلب التأكيد وينشئ نسخة للتراجع. تبقى العوالم وملفات التشغيل والإضافات والمكتبات والإعدادات المحلية محفوظة؛ تُصلح التبعيات فقط عند فقدانها أو عدم صلاحيتها.

> يتم التحقق من الحزمة الكاملة ومجموع التحقق SHA-512 المنشور قبل التثبيت.

<!-- jarock-auto-update-check -->

## فحص التحديثات عند بدء التشغيل

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **حماية إغلاق وحدة تحكم Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. اكتب stop وانتظر SAFE TO CLOSE. لا تغلق بالقوة أثناء حفظ العالم. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
