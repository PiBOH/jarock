# Резервное руководство NeoForge

Используйте NeoForge только как последний вариант, если Fabric не подходит. Forge и NeoForge — разные loader, mods должны соответствовать NeoForge; при необходимости добавьте Geyser/Floodgate и сначала тестируйте копию.

Читайте полное руководство на английском: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## Безопасная остановка

> Введите `stop` и оставьте окно открытым. Перед закрытием дождитесь `CLEAN SHUTDOWN COMPLETE`, затем `SAFE TO CLOSE`. Если второго сообщения нет, проверьте журнал и отчёт о сбое и при необходимости восстановите резервную копию.

<!-- jarock-updater -->


## Обновление Jarock

> Прочитайте `scripts/version.txt`, остановите сервер и дождитесь `SAFE TO CLOSE`; затем запустите `scripts/update-jarock.bat`. Скрипт ищет более новый выпуск в том же beta/стабильном канале, запрашивает подтверждение и создаёт резервную копию для отката. Мир, runtime, моды, библиотеки и локальные настройки сохраняются; зависимости исправляются только при отсутствии или повреждении.

> Полный пакет и опубликованная для него контрольная сумма SHA-512 проверяются перед установкой.

<!-- jarock-auto-update-check -->

## Проверка обновлений при запуске

Установите AUTO_UPDATE_CHECK=true в parameter-manager.bat, чтобы start-server.bat проверял релизы GitHub только для чтения. Совместимая новая версия Jarock будет показана, но автоматически ничего не устанавливается. Остановите сервер, дождитесь SAFE TO CLOSE и запустите scripts/update-jarock.bat. По умолчанию AUTO_UPDATE_CHECK=false. When a compatible newer release is found at startup, Jarock asks `Download and install it now? (y/N)`; choose y to install the verified Lite package, or N/Enter to continue with the current version. It never updates silently.
