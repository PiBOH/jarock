# Перший запуск Jarock

## Перед початком

Встановіть 64-розрядний JDK Java 25 або новіший, увімкніть JAVA_HOME в інсталяторі Temurin і знову відкрийте термінал. Завжди запускайте кореневий `start-server.bat`; локальні налаштування зберігаються в `scripts/server-launch-settings.ini`, а `server/server.jar` не відкривайте безпосередньо.

## Вибір loader

Запустіть `start-server.bat` і виберіть Fabric (рекомендовано), NeoForge (запасний варіант) або Forge (зараз недоступний для Minecraft 26.2). У `parameter-manager.bat` можна налаштувати RAM, GUI/console, GC, `online-mode`, банер і `AUTO_UPDATE_CHECK`. **Exit without saving** скасовує зміни без збереження.

## Встановлення та EULA

Jarock автоматично завантажує loader і закріплені моди. Перший запуск створює `server/eula.txt` і зупиняється. Прочитайте Minecraft EULA та змініть `eula=false` на `eula=true` лише після згоди. Не використовуйте `online-mode=false` до першого успішного запуску; перший запуск має завершитися з `online-mode=true`.

## Безпечна зупинка

Запустіть знову й дочекайтеся завершення завантаження world, Geyser і Floodgate. Введіть `stop` і не закривайте вікно до появи `CLEAN SHUTDOWN COMPLETE` та `SAFE TO CLOSE`. У разі помилки виконайте Suggested fix; якщо loader змішані, створіть резервну копію та запустіть `clean-server-runtime.bat`. Для оновлення запустіть `scripts/update-jarock.bat`, а перед публічним доступом прочитайте `TODO.md`.
