# Посібник сервера Fabric

Встановіть 64-бітну Java 25, запустіть `start-server.bat` і налаштуйте RAM та GUI або `nogui` через `parameter-manager.bat`. (enable "Set JAVA_HOME variable" in the Temurin installer) Прочитайте `server/eula.txt`, прийміть EULA і встановіть `eula=true`; використовуйте Fabric, Geyser-Fabric і Floodgate-Fabric, робіть backup, а Jarock не змінює роутер, firewall чи port forwarding.

Перегляньте повний посібник англійською: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Технічна примітка: Завжди використовуйте `start-server.bat` у корені репозиторію. Не запускайте `server.jar` подвійним клацанням: Windows може використати Java 8 або Java 21, тоді як Minecraft 26.2 потребує 64-бітної Java 25+. Дивіться [повний посібник англійською](../en/server-guide.md).**

<!-- jarock-safe-shutdown -->

## Безпечне завершення

> Введіть `stop` і залиште вікно відкритим. Перед закриттям дочекайтеся `CLEAN SHUTDOWN COMPLETE`, а потім `SAFE TO CLOSE`. Якщо другого повідомлення немає, перевірте журнал і звіт про збій та за потреби відновіть резервну копію.

<!-- jarock-updater -->


## Оновлення Jarock

> Прочитайте `scripts/version.txt`, зупиніть сервер і дочекайтеся `SAFE TO CLOSE`; потім запустіть `scripts/update-jarock.bat`. Він шукає новішу версію в тому самому beta/стабільному каналі, просить підтвердження та створює резервну копію для відкату. Світ, runtime, моди, бібліотеки й локальні налаштування зберігаються; залежності виправляються лише за відсутності або пошкодження.

> Повний пакет і опублікована контрольна сума SHA-512 перевіряються перед встановленням.

<!-- jarock-auto-update-check -->

## Перевірка оновлень під час запуску

Встановіть AUTO_UPDATE_CHECK=true у parameter-manager.bat, щоб start-server.bat перевіряв релізи GitHub лише для читання. Буде повідомлено про сумісну новішу версію Jarock, але автоматичного встановлення не буде. Зупиніть сервер, дочекайтеся SAFE TO CLOSE і запустіть scripts/update-jarock.bat. Значення за замовчуванням AUTO_UPDATE_CHECK=false.
