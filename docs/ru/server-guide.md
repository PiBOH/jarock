# Руководство сервера Fabric

Установите 64-разрядную Java 25, запустите `start-server.bat` и настройте RAM и GUI или `nogui` через `parameter-manager.bat`. (enable "Set JAVA_HOME variable" in the Temurin installer) Прочитайте `server/eula.txt`, примите EULA и установите `eula=true`; используйте Fabric, Geyser-Fabric и Floodgate-Fabric, делайте backup, а Jarock не изменяет роутер, firewall или port forwarding.

Читайте полное руководство на английском: [../en/server-guide.md](../en/server-guide.md)

> **Техническое примечание: Всегда используйте `start-server.bat` в корне репозитория. Не запускайте `server.jar` двойным щелчком: Windows может выбрать Java 8 или Java 21, а Minecraft 26.2 требует 64-разрядную Java 25+. См. [полное руководство на английском](../en/server-guide.md).**
