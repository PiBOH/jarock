# Резервний посібник NeoForge

Використовуйте NeoForge лише як останній варіант, якщо Fabric не підходить. Forge і NeoForge — різні loader, mods мають відповідати NeoForge; за потреби додайте Geyser/Floodgate і спочатку тестуйте копію.

Перегляньте повний посібник англійською: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## Безпечне завершення

> Введіть `stop` і залиште вікно відкритим. Перед закриттям дочекайтеся `CLEAN SHUTDOWN COMPLETE`, а потім `SAFE TO CLOSE`. Якщо другого повідомлення немає, перевірте журнал і звіт про збій та за потреби відновіть резервну копію.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Оновлення Jarock

> Прочитайте `scripts/version.txt`, зупиніть сервер і дочекайтеся `SAFE TO CLOSE`; потім запустіть `scripts/update-jarock.bat`. Він шукає новішу версію в тому самому beta/стабільному каналі, просить підтвердження та створює резервну копію для відкату. Світ, runtime, моди, бібліотеки й локальні налаштування зберігаються; залежності виправляються лише за відсутності або пошкодження.

> Повний пакет і опублікована контрольна сума SHA-512 перевіряються перед встановленням.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Перевірка оновлень під час запуску

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Захист від закриття консолі Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Введіть stop і дочекайтеся SAFE TO CLOSE. Не завершуйте процес примусово під час збереження світу. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
