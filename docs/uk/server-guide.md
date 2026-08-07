# Посібник сервера Fabric

Встановіть 64-бітну Java 25, запустіть `start-server.bat` і налаштуйте RAM та GUI або `nogui` через `parameter-manager.bat`. (enable "Set JAVA_HOME variable" in the Temurin installer) Прочитайте `server/eula.txt`, прийміть EULA і встановіть `eula=true`; використовуйте Fabric, Geyser-Fabric і Floodgate-Fabric, робіть backup, а Jarock не змінює роутер, firewall чи port forwarding.

Перегляньте повний посібник англійською: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Технічна примітка: Завжди використовуйте `start-server.bat` у корені репозиторію. Не запускайте `server.jar` подвійним клацанням: Windows може використати Java 8 або Java 21, тоді як Minecraft 26.2 потребує 64-бітної Java 25+. Дивіться [повний посібник англійською](../en/server-guide.md).**
