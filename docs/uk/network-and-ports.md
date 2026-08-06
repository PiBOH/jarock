# Посібник із мережі, брандмауера та маршрутизатора

Встановіть 64-бітну Java 25, запустіть `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` і завершіть `TODO.md` перед відкриттям портів. Призначте фіксовану LAN IP, відкрийте TCP `25565` (Java) і UDP `19132` (Bedrock) у брандмауері Windows, налаштуйте переадресацію портів на маршрутизаторі або використовуйте UDP-сумісний тунель, наприклад playit.gg. Переконайтеся, що `online-mode=true` і `white-list=true` увімкнено, і ніколи не публікуйте `key.pem`. Для CGNAT використовуйте тунель. Див. [канонічний посібник англійською](../en/network-and-ports.md).

> Завжди використовуйте `start-server.bat`; не запускайте `server.jar` подвійним клацанням.
