# دليل خادم Fabric

ثبّت Java 25 ‏64-bit وشغّل `start-server.bat` واستخدم `parameter-manager.bat` لضبط الذاكرة وGUI أو `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) اقرأ `server/eula.txt` واجعل `eula=true` بعد قبول EULA فقط. استخدم Fabric وGeyser-Fabric وFloodgate-Fabric وأنشئ نسخاً احتياطية. لا يغيّر Jarock الراوتر أو firewall أو port forwarding.

See the [canonical English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.

> **ملاحظة تقنية: استخدم دائماً `start-server.bat` الموجود في جذر repository. لا تنقر نقراً مزدوجاً على `server.jar`؛ فقد يستخدم Windows Java 8 أو Java 21، بينما يتطلب Minecraft 26.2 إصدار Java 25+ ‏64-bit. راجع [الشرح الإنجليزي الكامل](../en/server-guide.md).**
