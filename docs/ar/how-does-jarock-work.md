# كيف يعمل Jarock؟

## شرح مبسط للخادم

**الإصدار الحالي:** `0.0.4-alpha`
**Minecraft:** Java Edition `26.2`
**المحمّل:** Fabric
**المنصة الرئيسية:** Windows 10/11

يشرح هذا المستند ما يحدث بعد تنزيل Jarock.

> **ملاحظة صيانة:** يبحث المشغّل الآن عن Java 25 أو أحدث بإصدار 64-bit بدلاً من الاعتماد على أول `java.exe` في `PATH`. يستخدم `scripts/java-runtime.ps1` ويحفظ المسار المختار في `server/java-path.txt` ويتحقق منه قبل التشغيل. يمكن أن تبقى Java 8 مثبتة.

## 1. الملخص

يثبّت المستخدم Java بنسخة 64-bit، ثم ينزّل هذا repository ويشغّل `start-server.bat`. يحدد البرنامج مجلده تلقائياً، ويتحقق من Java والمسار، ويطلب تفعيل المسارات الطويلة في Windows عند الحاجة، ثم ينزّل Fabric والـ mods المثبتة ويتحقق من كل ملف باستخدام SHA-512.

ينشئ Fabric بيئة التشغيل داخل `server/`. في التشغيل الأول يتم إنشاء `server/eula.txt` بالقيمة `eula=false` ثم يتوقف البرنامج. يجب قراءة <https://www.minecraft.net/eula> وتغييرها إلى `eula=true` عند الموافقة، ثم تشغيل الملف مرة أخرى. يترجم Geyser حركة Bedrock ويتولى Floodgate مصادقة لاعبي Bedrock.

Jarock **لا** يضبط router أو firewall أو port forwarding.

## 2. الملفات والتدفق

يحتوي repository على scripts وقوالب وmanifest، لكنه لا يحتوي العالم أو ملفات `.jar` الناتجة:

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