# دليل الشبكة وجدار الحماية والموجّه

ثبّت Java 25 64-bit وشغّل `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` وأكمل `TODO.md` قبل فتح المنافذ. عيّن IP LAN ثابتاً وافتح TCP `25565` لـ Java وUDP `19132` لـ Bedrock في جدار حماية Windows واضبط توجيه المنافذ في الموجّه أو استخدم نفقاً UDP مثل playit.gg. تأكد من `online-mode=true` و`white-list=true` ولا تنشر `key.pem` أبداً. استخدم نفقاً لـ CGNAT. راجع [الدليل الإنجليزي](../en/network-and-ports.md).

> استخدم دائماً `start-server.bat` ولا تنقر نقراً مزدوجاً على `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## إيقاف التشغيل الآمن

> اكتب `stop` في وحدة التحكم واترك النافذة مفتوحة. انتظر `CLEAN SHUTDOWN COMPLETE` ثم `SAFE TO CLOSE` قبل إغلاقها. إذا غابت الرسالة الثانية، افحص السجل وتقرير التعطل واستعد نسخة احتياطية عند الحاجة.

<!-- jarock-updater -->


## تحديث Jarock

> اقرأ `version.txt`، أوقف الخادم وانتظر `SAFE TO CLOSE`، ثم شغّل `update-jarock.bat`. يبحث عن إصدار أحدث في القناة نفسها، يطلب التأكيد وينشئ نسخة للتراجع. تبقى العوالم وملفات التشغيل والإضافات والمكتبات والإعدادات المحلية محفوظة؛ تُصلح التبعيات فقط عند فقدانها أو عدم صلاحيتها.

> يتم التحقق من الحزمة الكاملة ومجموع التحقق SHA-512 المنشور قبل التثبيت.
