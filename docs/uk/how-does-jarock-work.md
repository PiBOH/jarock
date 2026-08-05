# Як працює Jarock?

## Просте пояснення сервера

**Поточна версія:** `0.0.2-alpha`  
**Minecraft:** Java Edition `26.2`  
**Завантажувач:** Fabric  
**Основна платформа:** Windows 10/11

Цей документ пояснює, що відбувається після завантаження Jarock.

## 1. Коротко

Користувач встановлює 64-бітну Java, завантажує цей repository і запускає `start-server.bat`. Програма знаходить власну папку, перевіряє Java та шлях, за потреби просить увімкнути підтримку довгих шляхів Windows, завантажує закріплений Fabric installer і mods та перевіряє кожен файл за допомогою SHA-512.

Fabric створює runtime у `server/`. Перший запуск створює `server/eula.txt` зі значенням `eula=false` і зупиняється. Користувач має прочитати <https://www.minecraft.net/eula>, встановити `eula=true`, якщо погоджується, і запустити програму знову. Geyser перекладає трафік Bedrock, а Floodgate обробляє автентифікацію Bedrock.

Jarock **не** налаштовує router, firewall або port forwarding.

## 2. Файли та процес

Repository містить scripts, шаблони та manifest, але не містить світу або згенерованих файлів `.jar`:

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

Runtime створюється у `server/`. Git ігнорує світи, logs, бібліотеки, приватні ключі та локальні списки.

`start-server.bat` використовує власне розташування, а не фіксований шлях на кшталт `C:\MinecraftServer`, тому підтримує доступні шляхи з пробілами, Unicode, `!` та вкладеними папками. Для довгих шляхів перевіряється:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

За потреби скрипт просить права адміністратора та запускає `scripts\enable-long-paths.ps1`. Зміна є системною, і старим програмам може знадобитися перезапуск Windows.

## 3. EULA, Geyser і помилки

Перший запуск створює `server/eula.txt` з `eula=false` і зупиняється. Прочитайте EULA, змініть значення на `eula=true`, якщо погоджуєтеся, і запустіть знову.

Geyser створює повну конфігурацію під час першого справжнього запуску сервера. Після створення:

```text
server\config\Geyser-Fabric\config.yml
```

скрипт встановлює:

```yaml
auth-type: floodgate
```

Java зазвичай використовує TCP `25565`, а Bedrock — UDP `19132`. Jarock не відкриває порти. `key.pem` є приватним і не може публікуватися.

Після помилки прочитайте `ERROR:` або `WARNING:` та виконайте `Suggested fix:`. Якщо Java завершила роботу, знайдіть перший `Caused by:` у `server\logs\latest.log` або `server\crash-reports\`. Решта завдань наведена в `TODO.md`.