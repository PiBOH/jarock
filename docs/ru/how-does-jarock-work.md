# Как работает Jarock?

## Простое объяснение сервера

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Загрузчик:** Fabric
**Основная платформа:** Windows 10/11

Этот документ объясняет, что происходит после загрузки Jarock.


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome Message 2.8 with its required Collective library is included as a verified server-side Minecraft 26.2 mod for Fabric and NeoForge; it sends configurable join messages.

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
scripts/bootstrap-server.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
scripts/version.txt
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

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> InvView 1.4.21 is a verified Minecraft 26.2 server-side Fabric mod. It requires Fabric API and lets authorized operators inspect and manage online or offline player inventories and ender chests; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> OfflineCommands 1.0.3 is a verified Minecraft 26.2 server-side Fabric mod for running commands on offline players. No compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

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

> **Защита от закрытия консоли Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Введите stop и дождитесь SAFE TO CLOSE. Не закрывайте принудительно во время сохранения мира. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
