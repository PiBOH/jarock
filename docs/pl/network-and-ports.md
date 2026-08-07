# Przewodnik po sieci, zaporze i routerze

Zainstaluj 64-bitową Javę 25, uruchom `start-server.bat` i ukończ `TODO.md` przed otwarciem portów. Przypisz stałe IP LAN, otwórz TCP `25565` (Java) i UDP `19132` (Bedrock) w zaporze Windows, skonfiguruj przekierowanie portów na routerze lub użyj tunelu UDP, np. playit.gg. Upewnij się, że `online-mode=true` i `white-list=true` są włączone i nigdy nie publikuj `key.pem`. Dla CGNAT użyj tunelu. Zobacz [kanoniczny przewodnik po angielsku](../en/network-and-ports.md). (abilita Set JAVA_HOME nell’installer Temurin) (enable "Set JAVA_HOME variable" in the Temurin installer)

> Zawsze używaj `start-server.bat`; nie klikaj dwukrotnie `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.
