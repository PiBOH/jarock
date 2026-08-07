# دليل خادم Fabric

ثبّت Java 25 ‏64-bit وشغّل `start-server.bat` واستخدم `parameter-manager.bat` لضبط الذاكرة وGUI أو `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) اقرأ `server/eula.txt` واجعل `eula=true` بعد قبول EULA فقط. استخدم Fabric وGeyser-Fabric وFloodgate-Fabric وأنشئ نسخاً احتياطية. لا يغيّر Jarock الراوتر أو firewall أو port forwarding.

See the [English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **ملاحظة تقنية: استخدم دائماً `start-server.bat` الموجود في جذر repository. لا تنقر نقراً مزدوجاً على `server.jar`؛ فقد يستخدم Windows Java 8 أو Java 21، بينما يتطلب Minecraft 26.2 إصدار Java 25+ ‏64-bit. راجع [الشرح الإنجليزي الكامل](../en/server-guide.md).**
