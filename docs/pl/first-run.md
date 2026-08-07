# Pierwsze uruchomienie Jarock

## Wybór loadera

Zainstaluj 64-bitowy JDK Java 25 lub nowszy, w instalatorze Temurin włącz JAVA_HOME i ponownie otwórz terminal. Zawsze uruchamiaj główny `start-server.bat` en `scripts/server-launch-settings.ini`; nie otwieraj bezpośrednio `server/server.jar`.

## Instalacja i EULA

Uruchom `start-server.bat` i wybierz Fabric (zalecany), NeoForge (awaryjny) lub Forge (obecnie niedostępny dla Minecraft 26.2). `parameter-manager.bat` ustawia RAM, GUI/konsolę, GC, `online-mode`, baner i `AUTO_UPDATE_CHECK`. **Exit without saving** anuluje bez zapisywania.

## Bezpieczne zatrzymanie

Jarock automatycznie pobiera loader i przypięte mody. Pierwsze uruchomienie tworzy `server/eula.txt` i zwykle się zatrzymuje. Przeczytaj Minecraft EULA i zmień `eula=false` na `eula=true` tylko po akceptacji. Nie używaj `online-mode=false` przed pierwszym udanym uruchomieniem.

## Bezpieczne zatrzymanie

Uruchom ponownie, poczekaj na świat, Geyser i Floodgate, wpisz `stop` i czekaj na `CLEAN SHUTDOWN COMPLETE` oraz `SAFE TO CLOSE`. Przy błędzie użyj Suggested fix; przy mieszaniu loaderów wykonaj kopię i uruchom `clean-server-runtime.bat`. Przed publicznym dostępem przeczytaj `TODO.md`.

## Uwaga dotycząca bezpieczeństwa

Pierwsze uruchomienie zakończ z `online-mode=true`, aby działało normalne uwierzytelnianie.

## Uwaga dotycząca bezpieczeństwa

Aby zainstalować aktualizację, bezpiecznie zatrzymaj serwer i uruchom `scripts/update-jarock.bat`.
