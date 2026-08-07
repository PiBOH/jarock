# التشغيل الأول لـ Jarock

## قبل البدء

يوضح هذا الدليل ما يحدث عند استخدام مستودع Jarock لأول مرة. استخدم دائمًا `start-server.bat` الموجود في الجذر، ولا تفتح `server/server.jar` مباشرة. ثبّت JDK ‏64 بت بإصدار Java 25 أو أحدث، وفعّل **Set JAVA_HOME variable** في مثبت Temurin ثم أعد فتح الطرفية.

## اختيار محمّل الخادم

شغّل `start-server.bat`. سيفحص Jarock Java والمسارات و`‏scripts/server-launch-settings.ini`، وينقل إعدادات الجذر القديمة تلقائيًا. اختر Fabric (موصى به)، أو NeoForge (بديل)، أو Forge (غير متاح حاليًا لـ Minecraft 26.2). يتيح `parameter-manager.bat` ضبط الذاكرة وGUI/console وGC و`online-mode` واللافتة و`AUTO_UPDATE_CHECK`. خيار **Exit without saving** يلغي دون حفظ.

## التثبيت وقبول EULA

ينزّل Jarock الـ loader والـ mods المثبتة تلقائيًا. ينشئ التشغيل الأول `server/eula.txt` ويتوقف عادةً. اقرأ Minecraft EULA، وإذا وافقت فقط غيّر `eula=false` إلى `eula=true`. لا تضبط `online-mode=false` قبل أول تشغيل ناجح؛ أكمل أول تشغيل باستخدام `online-mode=true`.

## الإيقاف الآمن

شغّل `start-server.bat` مرة أخرى ودع إنشاء العالم وGeyser وFloodgate يكتمل. للإيقاف اكتب `stop` في وحدة التحكم ولا تغلق النافذة. انتظر `CLEAN SHUTDOWN COMPLETE` ثم `SAFE TO CLOSE`؛ عندها فقط أغلقها.

## بعد التشغيل الأول

إذا لم توجد Java، ثبّت Java 25 ذات 64 بت وأعد فتح الطرفية. عند فشل التنزيل اقرأ Suggested fix وأعد المحاولة. إذا اختلط Fabric وNeoForge، خذ نسخة احتياطية وشغّل `clean-server-runtime.bat`. أبقِ `online-mode=true` واقرأ `TODO.md` قبل النشر العام.

## ملاحظة أمان

لتثبيت تحديث، أوقف الخادم بأمان وشغّل `scripts/update-jarock.bat`.
