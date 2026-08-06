# دليل الشبكة وجدار الحماية والموجّه

ثبّت Java 25 64-bit وشغّل `start-server.bat` وأكمل `TODO.md` قبل فتح المنافذ. عيّن IP LAN ثابتاً وافتح TCP `25565` لـ Java وUDP `19132` لـ Bedrock في جدار حماية Windows واضبط توجيه المنافذ في الموجّه أو استخدم نفقاً UDP مثل playit.gg. تأكد من `online-mode=true` و`white-list=true` ولا تنشر `key.pem` أبداً. استخدم نفقاً لـ CGNAT. راجع [الدليل الإنجليزي](../en/network-and-ports.md).

> استخدم دائماً `start-server.bat` ولا تنقر نقراً مزدوجاً على `server.jar`.
