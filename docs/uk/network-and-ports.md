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

Встановіть AUTO_UPDATE_CHECK=true у parameter-manager.bat, щоб start-server.bat перевіряв релізи GitHub лише для читання. Буде повідомлено про сумісну новішу версію Jarock, але автоматичного встановлення не буде. Зупиніть сервер, дочекайтеся SAFE TO CLOSE і запустіть scripts/update-jarock.bat. Значення за замовчуванням AUTO_UPDATE_CHECK=false. When a compatible newer release is found at startup, Jarock asks `Download and install it now? (y/N)`; choose y to install the verified Lite package, or N/Enter to continue with the current version. It never updates silently.
