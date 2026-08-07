# Руководство сервера Fabric

Установите 64-разрядную Java 25, запустите `start-server.bat` и настройте RAM и GUI или `nogui` через `parameter-manager.bat`. (enable "Set JAVA_HOME variable" in the Temurin installer) Прочитайте `server/eula.txt`, примите EULA и установите `eula=true`; используйте Fabric, Geyser-Fabric и Floodgate-Fabric, делайте backup, а Jarock не изменяет роутер, firewall или port forwarding.

Читайте полное руководство на английском: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Show ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Техническое примечание: Всегда используйте `start-server.bat` в корне репозитория. Не запускайте `server.jar` двойным щелчком: Windows может выбрать Java 8 или Java 21, а Minecraft 26.2 требует 64-разрядную Java 25+. См. [полное руководство на английском](../en/server-guide.md).**

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
