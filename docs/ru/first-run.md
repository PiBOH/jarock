# Первый запуск Jarock

## Выбор loader

Установите 64-разрядный JDK Java 25 или новее, включите JAVA_HOME в установщике Temurin и заново откройте терминал. Всегда запускайте корневой `start-server.bat` en `scripts/server-launch-settings.ini` и не открывайте `server/server.jar` напрямую.

## Установка и EULA

Запустите `start-server.bat` и выберите Fabric (рекомендуется), NeoForge (резервный вариант) или Forge (сейчас недоступен для Minecraft 26.2). В `parameter-manager.bat` настраиваются RAM, GUI/консоль, GC, `online-mode`, баннер и `AUTO_UPDATE_CHECK`. **Exit without saving** отменяет изменения без сохранения.

## Безопасная остановка

Jarock автоматически скачивает loader и закреплённые моды. Первый запуск создаёт `server/eula.txt` и обычно останавливается. Прочитайте Minecraft EULA и меняйте `eula=false` на `eula=true` только после согласия. Не используйте `online-mode=false` до первого успешного запуска.

## Безопасная остановка

Запустите снова, дождитесь мира, Geyser и Floodgate, введите `stop` и ждите `CLEAN SHUTDOWN COMPLETE` и `SAFE TO CLOSE`. При ошибке следуйте Suggested fix; при смешанных loader сделайте резервную копию и запустите `clean-server-runtime.bat`. До публичного доступа прочитайте `TODO.md`.

## Примечание по безопасности

Завершите первый запуск с `online-mode=true`, чтобы работала обычная аутентификация.

## Примечание по безопасности

Чтобы установить обновление, безопасно остановите сервер и запустите `scripts/update-jarock.bat`.
