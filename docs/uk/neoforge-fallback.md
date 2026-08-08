# Резервний посібник NeoForge

Використовуйте NeoForge лише як останній варіант, якщо Fabric не підходить. Forge і NeoForge — різні loader, mods мають відповідати NeoForge; за потреби додайте Geyser/Floodgate і спочатку тестуйте копію.

Перегляньте повний посібник англійською: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## Безпечне завершення

> Введіть `stop` і залиште вікно відкритим. Перед закриттям дочекайтеся `CLEAN SHUTDOWN COMPLETE`, а потім `SAFE TO CLOSE`. Якщо другого повідомлення немає, перевірте журнал і звіт про збій та за потреби відновіть резервну копію.

<!-- jarock-updater -->


## Оновлення Jarock

> Прочитайте `scripts/version.txt`, зупиніть сервер і дочекайтеся `SAFE TO CLOSE`; потім запустіть `scripts/update-jarock.bat`. Він шукає новішу версію в тому самому beta/стабільному каналі, просить підтвердження та створює резервну копію для відкату. Світ, runtime, моди, бібліотеки й локальні налаштування зберігаються; залежності виправляються лише за відсутності або пошкодження.

> Повний пакет і опублікована контрольна сума SHA-512 перевіряються перед встановленням.

<!-- jarock-auto-update-check -->

## Перевірка оновлень під час запуску

Startup update modes: AUTO_UPDATE_MODE=auto checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.
