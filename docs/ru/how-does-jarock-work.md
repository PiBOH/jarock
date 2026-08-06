# Как работает Jarock?

## Простое объяснение сервера

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Загрузчик:** Fabric
**Основная платформа:** Windows 10/11

Этот документ объясняет, что происходит после загрузки Jarock.


> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Примечание по сопровождению:** средство запуска теперь ищет совместимую 64-разрядную Java 25+, а не доверяет только первому `java.exe` в `PATH`. Оно использует `scripts/java-runtime.ps1`, сохраняет выбранный исполняемый файл в `server/java-path.txt` и проверяет его перед запуском. Java 8 можно оставить установленной.

## 1. Кратко

Пользователь устанавливает 64-битную Java, скачивает этот repository и запускает `start-server.bat`. Программа находит собственную папку, проверяет Java и путь, при необходимости запрашивает включение длинных путей Windows, скачивает закреплённые Fabric installer и mods и проверяет каждый файл с помощью SHA-512.

Fabric создаёт runtime в `server/`. При первом запуске создаётся `server/eula.txt` со значением `eula=false`, после чего программа останавливается. Пользователь должен прочитать <https://www.minecraft.net/eula>, установить `eula=true`, если он согласен, и запустить снова. Geyser переводит трафик Bedrock, а Floodgate обрабатывает аутентификацию Bedrock.

Jarock **не** настраивает router, firewall или port forwarding.

## 2. Файлы и процесс

Repository содержит scripts, шаблоны и manifest, но не содержит мир или сгенерированные `.jar`-файлы:

```text
start-server.bat
scripts/bootstrap-fabric.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
version.txt
CHANGELOG.md
TODO.md
```

Runtime создаётся в `server/`. Git игнорирует миры, logs, библиотеки, приватные ключи и локальные списки.

`start-server.bat` использует собственное расположение, а не фиксированный путь вроде `C:\MinecraftServer`, поэтому поддерживает доступные пути с пробелами, Unicode, `!` и вложенными папками. Для длинных путей проверяется:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

При необходимости скрипт запрашивает права администратора и запускает `scripts\enable-long-paths.ps1`. Это системное изменение; старым приложениям может потребоваться перезапуск Windows.

## 3. EULA, Geyser и ошибки

Первый запуск создаёт `server/eula.txt` с `eula=false` и останавливается. Прочитайте EULA, измените значение на `eula=true`, если согласны, и запустите снова.

Geyser создаёт полную конфигурацию во время первого настоящего запуска сервера. После создания файла:

```text
server\config\Geyser-Fabric\config.yml
```

скрипт устанавливает:

```yaml
auth-type: floodgate
```

Java обычно использует TCP `25565`, а Bedrock — UDP `19132`. Jarock не открывает порты. `key.pem` является секретным файлом и не должен публиковаться.

После ошибки прочитайте `ERROR:` или `WARNING:` и выполните `Suggested fix:`. Если Java завершилась, найдите первый `Caused by:` в `server\logs\latest.log` или `server\crash-reports\`. Оставшиеся задачи перечислены в `TODO.md`.

> **Техническое примечание: Всегда используйте `start-server.bat` в корне репозитория. Не запускайте `server.jar` двойным щелчком: Windows может выбрать Java 8 или Java 21, а Minecraft 26.2 требует 64-разрядную Java 25+. См. [полное руководство на английском](../en/how-does-jarock-work.md).**
