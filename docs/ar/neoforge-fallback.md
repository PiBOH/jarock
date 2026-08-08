# دليل NeoForge الاحتياطي

استخدم NeoForge كخيار أخير إذا لم يناسب Fabric. Forge وNeoForge محمّلان مختلفان؛ يجب أن تطابق mods NeoForge. أضف Geyser/Floodgate عند الحاجة واختبر نسخة احتياطية.

See the [English NeoForge fallback guide](../en/neoforge-fallback.md) for the complete procedure. Verify every mod against the selected loader.

<!-- jarock-safe-shutdown -->

## إيقاف التشغيل الآمن

> اكتب `stop` في وحدة التحكم واترك النافذة مفتوحة. انتظر `CLEAN SHUTDOWN COMPLETE` ثم `SAFE TO CLOSE` قبل إغلاقها. إذا غابت الرسالة الثانية، افحص السجل وتقرير التعطل واستعد نسخة احتياطية عند الحاجة.

<!-- jarock-updater -->


## تحديث Jarock

> اقرأ `scripts/version.txt`، أوقف الخادم وانتظر `SAFE TO CLOSE`، ثم شغّل `scripts/update-jarock.bat`. يبحث عن إصدار أحدث في القناة نفسها، يطلب التأكيد وينشئ نسخة للتراجع. تبقى العوالم وملفات التشغيل والإضافات والمكتبات والإعدادات المحلية محفوظة؛ تُصلح التبعيات فقط عند فقدانها أو عدم صلاحيتها.

> يتم التحقق من الحزمة الكاملة ومجموع التحقق SHA-512 المنشور قبل التثبيت.

<!-- jarock-auto-update-check -->

## فحص التحديثات عند بدء التشغيل

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **حماية إغلاق وحدة تحكم Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. اكتب stop وانتظر SAFE TO CLOSE. لا تغلق بالقوة أثناء حفظ العالم. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
