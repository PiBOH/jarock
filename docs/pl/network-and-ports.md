# Przewodnik po sieci, zaporze i routerze

Zainstaluj 64-bitową Javę 25, uruchom `start-server.bat` i ukończ `TODO.md` przed otwarciem portów. Przypisz stałe IP LAN, otwórz TCP `25565` (Java) i UDP `19132` (Bedrock) w zaporze Windows, skonfiguruj przekierowanie portów na routerze lub użyj tunelu UDP, np. playit.gg. Upewnij się, że `online-mode=true` i `white-list=true` są włączone i nigdy nie publikuj `key.pem`. Dla CGNAT użyj tunelu. Zobacz [kanoniczny przewodnik po angielsku](../en/network-and-ports.md). (abilita Set JAVA_HOME nell’installer Temurin) (enable "Set JAVA_HOME variable" in the Temurin installer)

> Zawsze używaj `start-server.bat`; nie klikaj dwukrotnie `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Bezpieczne zatrzymanie

> Wpisz `stop` i pozostaw okno otwarte. Przed zamknięciem poczekaj na `CLEAN SHUTDOWN COMPLETE`, a następnie `SAFE TO CLOSE`. Jeśli drugiego komunikatu nie ma, sprawdź log i raport awarii oraz w razie potrzeby przywróć kopię.

<!-- jarock-updater -->


## Aktualizacja Jarock

> Odczytaj `scripts/version.txt`, zatrzymaj serwer i poczekaj na `SAFE TO CLOSE`; następnie uruchom `scripts/update-jarock.bat`. Wyszuka nowsze wydanie w tym samym kanale beta/stabilnym, poprosi o potwierdzenie i utworzy kopię do wycofania. Świat, runtime, mody, biblioteki i ustawienia lokalne zostają zachowane; zależności są naprawiane tylko gdy ich brakuje lub są nieprawidłowe.

> Pełny pakiet i opublikowana suma kontrolna SHA-512 są sprawdzane przed instalacją.

<!-- jarock-auto-update-check -->

## Sprawdzanie aktualizacji przy uruchamianiu

Ustaw AUTO_UPDATE_CHECK=true w parameter-manager.bat, aby start-server.bat sprawdzał wydania GitHub tylko do odczytu. Zgłosi zgodną nowszą wersję Jarock, ale niczego nie zainstaluje automatycznie. Zatrzymaj serwer, zaczekaj na SAFE TO CLOSE i uruchom scripts/update-jarock.bat. Wartość domyślna to AUTO_UPDATE_CHECK=false.
