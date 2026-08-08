# Pierwsze uruchomienie Jarock

## Wybór loadera

Zainstaluj 64-bitowy JDK Java 25 lub nowszy, w instalatorze Temurin włącz JAVA_HOME i ponownie otwórz terminal. Zawsze uruchamiaj główny `start-server.bat` en `scripts/server-launch-settings.ini`; nie otwieraj bezpośrednio `server/server.jar`.

## Instalacja i EULA

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.

## Bezpieczne zatrzymanie

Jarock automatycznie pobiera loader i przypięte mody. Pierwsze uruchomienie tworzy `server/eula.txt` i zwykle się zatrzymuje. Przeczytaj Minecraft EULA i zmień `eula=false` na `eula=true` tylko po akceptacji. Nie używaj `online-mode=false` przed pierwszym udanym uruchomieniem.

## Bezpieczne zatrzymanie

Uruchom ponownie, poczekaj na świat, Geyser i Floodgate, wpisz `stop` i czekaj na `CLEAN SHUTDOWN COMPLETE` oraz `SAFE TO CLOSE`. Przy błędzie użyj Suggested fix; przy mieszaniu loaderów wykonaj kopię i uruchom `clean-server-runtime.bat`. Przed publicznym dostępem przeczytaj `TODO.md`.

## Uwaga dotycząca bezpieczeństwa

Pierwsze uruchomienie zakończ z `online-mode=true`, aby działało normalne uwierzytelnianie.

## Uwaga dotycząca bezpieczeństwa

Aby zainstalować aktualizację, bezpiecznie zatrzymaj serwer i uruchom `scripts/update-jarock.bat`.

<!-- jarock-lan-addresses-pl -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.
