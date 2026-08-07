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

اضبط AUTO_UPDATE_CHECK=true في parameter-manager.bat ليجري start-server.bat فحصًا للقراءة فقط عند بدء التشغيل. سيبلغ عن إصدار Jarock متوافق أحدث، ويطلب التأكيد قبل التثبيت. اختر y أو اكتب yes لتثبيت تحديث Lite أو N/Enter للمتابعة بالإصدار الحالي. القيمة الافتراضية AUTO_UPDATE_CHECK=false. When a compatible newer release is found at startup, Jarock asks `Download and install it now? (y/N)`; choose y to install the verified Lite package, or N/Enter to continue with the current version. It never updates silently.
