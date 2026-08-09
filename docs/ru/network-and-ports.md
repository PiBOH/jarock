# Руководство по сети, брандмауэру и роутеру

Установите 64-битную Java 25, запустите `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` и завершите `TODO.md` перед открытием портов. Назначьте фиксированный LAN IP, откройте TCP `25565` (Java) и UDP `19132` (Bedrock) в брандмауэре Windows, настройте проброс портов на роутере или используйте UDP-совместимый туннель, например playit.gg. Убедитесь, что `online-mode=true` и `white-list=true` включены и никогда не публикуйте `key.pem`. При CGNAT используйте туннель. См. [каноническое руководство на английском](../en/network-and-ports.md).

> Всегда используйте `start-server.bat`; не запускайте `server.jar` двойным щелчком.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Безопасная остановка

> Введите `stop` и оставьте окно открытым. Перед закрытием дождитесь `CLEAN SHUTDOWN COMPLETE`, затем `SAFE TO CLOSE`. Если второго сообщения нет, проверьте журнал и отчёт о сбое и при необходимости восстановите резервную копию.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Обновление Jarock

> Прочитайте `scripts/version.txt`, остановите сервер и дождитесь `SAFE TO CLOSE`; затем запустите `scripts/update-jarock.bat`. Скрипт ищет более новый выпуск в том же beta/стабильном канале, запрашивает подтверждение и создаёт резервную копию для отката. Мир, runtime, моды, библиотеки и локальные настройки сохраняются; зависимости исправляются только при отсутствии или повреждении.

> Полный пакет и опубликованная для него контрольная сумма SHA-512 проверяются перед установкой.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Проверка обновлений при запуске

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Защита от закрытия консоли Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Введите stop и дождитесь SAFE TO CLOSE. Не закрывайте принудительно во время сохранения мира. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
