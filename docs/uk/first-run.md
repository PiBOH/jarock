# Перший запуск Jarock

## Перед початком

Встановіть 64-розрядний JDK Java 25 або новіший, увімкніть JAVA_HOME в інсталяторі Temurin і знову відкрийте термінал. Завжди запускайте кореневий `start-server.bat`; локальні налаштування зберігаються в `scripts/server-launch-settings.ini`, а `server/server.jar` не відкривайте безпосередньо.

## Вибір loader

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.

## Встановлення та EULA

Jarock автоматично завантажує loader і закріплені моди. Перший запуск створює `server/eula.txt` і зупиняється. Прочитайте Minecraft EULA та змініть `eula=false` на `eula=true` лише після згоди. Не використовуйте `online-mode=false` до першого успішного запуску; перший запуск має завершитися з `online-mode=true`.

## Безпечна зупинка

Запустіть знову й дочекайтеся завершення завантаження world, Geyser і Floodgate. Введіть `stop` і не закривайте вікно до появи `CLEAN SHUTDOWN COMPLETE` та `SAFE TO CLOSE`. У разі помилки виконайте Suggested fix; якщо loader змішані, створіть резервну копію та запустіть `clean-server-runtime.bat`. Для оновлення запустіть `scripts/update-jarock.bat`, а перед публічним доступом прочитайте `TODO.md`.

<!-- jarock-lan-addresses-uk -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Захист від закриття консолі Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Введіть stop і дочекайтеся SAFE TO CLOSE. Не завершуйте процес примусово під час збереження світу. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
