# Як працює Jarock?

## Просте пояснення сервера

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Завантажувач:** Fabric
**Основна платформа:** Windows 10/11

Цей документ пояснює, що відбувається після завантаження Jarock.


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome Message 2.8 with its required Collective library is included as a verified server-side Minecraft 26.2 mod for Fabric and NeoForge; it sends configurable join messages.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Примітка з обслуговування:** засіб запуску тепер шукає сумісне 64-бітне Java 25+, а не довіряє лише першому `java.exe` в `PATH`. Він використовує `scripts/java-runtime.ps1`, зберігає вибраний виконуваний файл у `server/java-path.txt` і перевіряє його перед запуском. Java 8 можна залишити встановленою.

## 1. Коротко

Користувач встановлює 64-бітну Java, завантажує цей repository і запускає `start-server.bat`. Програма знаходить власну папку, перевіряє Java та шлях, за потреби просить увімкнути підтримку довгих шляхів Windows, завантажує закріплений Fabric installer і mods та перевіряє кожен файл за допомогою SHA-512.

Fabric створює runtime у `server/`. Перший запуск створює `server/eula.txt` зі значенням `eula=false` і зупиняється. Користувач має прочитати <https://www.minecraft.net/eula>, встановити `eula=true`, якщо погоджується, і запустити програму знову. Geyser перекладає трафік Bedrock, а Floodgate обробляє автентифікацію Bedrock.

Jarock **не** налаштовує router, firewall або port forwarding.

## 2. Файли та процес

Repository містить scripts, шаблони та manifest, але не містить світу або згенерованих файлів `.jar`:

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

> **Технічна примітка: Завжди використовуйте `start-server.bat` у корені репозиторію. Не запускайте `server.jar` подвійним клацанням: Windows може використати Java 8 або Java 21, тоді як Minecraft 26.2 потребує 64-бітної Java 25+. Дивіться [повний посібник англійською](../en/how-does-jarock-work.md).**

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> InvView 1.4.21 is a verified Minecraft 26.2 server-side Fabric mod. It requires Fabric API and lets authorized operators inspect and manage online or offline player inventories and ender chests; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> OfflineCommands 1.0.3 is a verified Minecraft 26.2 server-side Fabric mod for running commands on offline players. No compatible NeoForge 26.2 build is available, so NeoForge does not install it.

<!-- jarock-safe-shutdown -->

## Безпечне завершення

> Введіть `stop` і залиште вікно відкритим. Перед закриттям дочекайтеся `CLEAN SHUTDOWN COMPLETE`, а потім `SAFE TO CLOSE`. Якщо другого повідомлення немає, перевірте журнал і звіт про збій та за потреби відновіть резервну копію.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Оновлення Jarock

> Прочитайте `scripts/version.txt`, зупиніть сервер і дочекайтеся `SAFE TO CLOSE`; потім запустіть `scripts/update-jarock.bat`. Він шукає новішу версію в тому самому beta/стабільному каналі, просить підтвердження та створює резервну копію для відкату. Світ, runtime, моди, бібліотеки й локальні налаштування зберігаються; залежності виправляються лише за відсутності або пошкодження.

> Повний пакет і опублікована контрольна сума SHA-512 перевіряються перед встановленням.

<!-- jarock-auto-update-check -->

## Перевірка оновлень під час запуску

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Захист від закриття консолі Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Введіть stop і дочекайтеся SAFE TO CLOSE. Не завершуйте процес примусово під час збереження світу. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
