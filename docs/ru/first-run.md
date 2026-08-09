# Первый запуск Jarock

## Выбор loader

Установите 64-разрядный JDK Java 25 или новее, включите JAVA_HOME в установщике Temurin и заново откройте терминал. Всегда запускайте корневой `start-server.bat` en `scripts/server-launch-settings.ini` и не открывайте `server/server.jar` напрямую.

## Установка и EULA

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## Безопасная остановка

Jarock автоматически скачивает loader и закреплённые моды. Первый запуск создаёт `server/eula.txt` и обычно останавливается. Прочитайте Minecraft EULA и меняйте `eula=false` на `eula=true` только после согласия. Не используйте `online-mode=false` до первого успешного запуска.

## Безопасная остановка

Запустите снова, дождитесь мира, Geyser и Floodgate, введите `stop` и ждите `CLEAN SHUTDOWN COMPLETE` и `SAFE TO CLOSE`. При ошибке следуйте Suggested fix; при смешанных loader сделайте резервную копию и запустите `clean-server-runtime.bat`. До публичного доступа прочитайте `TODO.md`.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## Примечание по безопасности

Завершите первый запуск с `online-mode=true`, чтобы работала обычная аутентификация.

## Примечание по безопасности

Чтобы установить обновление, безопасно остановите сервер и запустите `scripts/update-jarock.bat`.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-ru -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Защита от закрытия консоли Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Введите stop и дождитесь SAFE TO CLOSE. Не закрывайте принудительно во время сохранения мира. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
