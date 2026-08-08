# Посібник із мережі, брандмауера та маршрутизатора

Встановіть 64-бітну Java 25, запустіть `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` і завершіть `TODO.md` перед відкриттям портів. Призначте фіксовану LAN IP, відкрийте TCP `25565` (Java) і UDP `19132` (Bedrock) у брандмауері Windows, налаштуйте переадресацію портів на маршрутизаторі або використовуйте UDP-сумісний тунель, наприклад playit.gg. Переконайтеся, що `online-mode=true` і `white-list=true` увімкнено, і ніколи не публікуйте `key.pem`. Для CGNAT використовуйте тунель. Див. [канонічний посібник англійською](../en/network-and-ports.md).

> Завжди використовуйте `start-server.bat`; не запускайте `server.jar` подвійним клацанням.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Безпечне завершення

> Введіть `stop` і залиште вікно відкритим. Перед закриттям дочекайтеся `CLEAN SHUTDOWN COMPLETE`, а потім `SAFE TO CLOSE`. Якщо другого повідомлення немає, перевірте журнал і звіт про збій та за потреби відновіть резервну копію.

<!-- jarock-updater -->


## Оновлення Jarock

> Прочитайте `scripts/version.txt`, зупиніть сервер і дочекайтеся `SAFE TO CLOSE`; потім запустіть `scripts/update-jarock.bat`. Він шукає новішу версію в тому самому beta/стабільному каналі, просить підтвердження та створює резервну копію для відкату. Світ, runtime, моди, бібліотеки й локальні налаштування зберігаються; залежності виправляються лише за відсутності або пошкодження.

> Повний пакет і опублікована контрольна сума SHA-512 перевіряються перед встановленням.

<!-- jarock-auto-update-check -->

## Перевірка оновлень під час запуску

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.

<!-- jarock-console-close-protection -->

> **Захист від закриття консолі Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Введіть stop і дочекайтеся SAFE TO CLOSE. Не завершуйте процес примусово під час збереження світу. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
