> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

# Pierwsze uruchomienie Jarock

## Wybór loadera

Zainstaluj 64-bitowy JDK Java 25 lub nowszy, w instalatorze Temurin włącz JAVA_HOME i ponownie otwórz terminal. Zawsze uruchamiaj główny `start-server.bat` en `scripts/server-launch-settings.ini`; nie otwieraj bezpośrednio `server/server.jar`.

## Instalacja i EULA

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified package matching scripts/jarock-edition.ini automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## Bezpieczne zatrzymanie

Jarock automatycznie pobiera loader i przypięte mody. Pierwsze uruchomienie tworzy `server/eula.txt` i zwykle się zatrzymuje. Przeczytaj Minecraft EULA i zmień `eula=false` na `eula=true` tylko po akceptacji. Nie używaj `online-mode=false` przed pierwszym udanym uruchomieniem.

## Bezpieczne zatrzymanie

Uruchom ponownie, poczekaj na świat, Geyser i Floodgate, wpisz `stop` i czekaj na `CLEAN SHUTDOWN COMPLETE` oraz `SAFE TO CLOSE`. Przy błędzie użyj Suggested fix; przy mieszaniu loaderów wykonaj kopię i uruchom `clean-server-runtime.bat`. Przed publicznym dostępem przeczytaj `TODO.md`.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## Uwaga dotycząca bezpieczeństwa

Pierwsze uruchomienie zakończ z `online-mode=true`, aby działało normalne uwierzytelnianie.

## Uwaga dotycząca bezpieczeństwa

Aby zainstalować aktualizację, bezpiecznie zatrzymaj serwer i uruchom `scripts/update-jarock.bat`.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-pl -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Ochrona przed zamknięciem konsoli Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Wpisz stop i poczekaj na SAFE TO CLOSE. Nie wymuszaj zamknięcia podczas zapisywania świata. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
