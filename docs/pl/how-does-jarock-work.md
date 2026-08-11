# Jak działa Jarock?

## Proste wyjaśnienie serwera

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Loader:** Fabric
**Główna platforma:** Windows 10/11

Ten dokument wyjaśnia, co dzieje się po pobraniu Jarock.


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome Message 2.8 with its required Collective library is included as a verified server-side Minecraft 26.2 mod for Fabric and NeoForge; it sends configurable join messages.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Uwaga dotycząca utrzymania:** launcher wyszukuje teraz zgodne 64-bitowe środowisko Java 25+, zamiast ufać tylko pierwszemu `java.exe` w `PATH`. Używa `scripts/java-runtime.ps1`, zapisuje wybrany plik wykonywalny w `server/java-path.txt` i sprawdza go przed uruchomieniem. Java 8 może pozostać zainstalowana.

## 1. W skrócie

Użytkownik instaluje 64-bitową Javę, pobiera ten repository i uruchamia `start-server.bat`. Program znajduje własny folder, sprawdza Javę i ścieżkę, w razie potrzeby prosi o włączenie długich ścieżek Windows, pobiera przypięty Fabric installer i mods oraz sprawdza każdy plik za pomocą SHA-512.

Fabric tworzy środowisko uruchomieniowe w `server/`. Pierwsze uruchomienie tworzy `server/eula.txt` z wartością `eula=false` i zatrzymuje się. Użytkownik musi przeczytać <https://www.minecraft.net/eula>, ustawić `eula=true`, jeśli się zgadza, i uruchomić ponownie. Geyser tłumaczy ruch Bedrock, a Floodgate obsługuje uwierzytelnianie Bedrock.

Jarock **nie** konfiguruje routera, firewalla ani port forwarding.

## 2. Pliki i przebieg

Repository zawiera scripts, szablony i manifest, ale nie zawiera świata ani wygenerowanych plików `.jar`:

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

Runtime jest tworzony w `server/`. Git ignoruje światy, logs, biblioteki, klucze prywatne i lokalne listy.

`start-server.bat` używa własnej lokalizacji zamiast stałej ścieżki, takiej jak `C:\MinecraftServer`, dlatego obsługuje dostępne ścieżki ze spacjami, znakami Unicode, `!` i zagnieżdżonymi folderami. Dla długich ścieżek sprawdza:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

W razie potrzeby prosi o uprawnienia administratora i uruchamia `scripts\enable-long-paths.ps1`. Zmiana jest systemowa i starsze programy mogą wymagać ponownego uruchomienia Windows.

## 3. EULA, Geyser i błędy

Pierwsze uruchomienie tworzy `server/eula.txt` z `eula=false` i zatrzymuje się. Przeczytaj EULA, zmień na `eula=true`, jeśli akceptujesz, i uruchom ponownie.

Geyser tworzy pełną konfigurację podczas pierwszego rzeczywistego uruchomienia serwera. Następnie skrypt w:

```text
server\config\Geyser-Fabric\config.yml
```

ustawia:

```yaml
auth-type: floodgate
```

Java zwykle korzysta z TCP `25565`, a Bedrock z UDP `19132`. Jarock nie otwiera portów. `key.pem` jest prywatny i nie wolno go publikować.

Po błędzie przeczytaj `ERROR:` lub `WARNING:` i wykonaj `Suggested fix:`. Jeśli Java się zakończy, znajdź pierwszy wpis `Caused by:` w `server\logs\latest.log` lub `server\crash-reports\`. Pozostałe zadania znajdują się w `TODO.md`.

> **Uwaga techniczna: Zawsze używaj pliku `start-server.bat` z katalogu głównego repozytorium. Nie klikaj dwukrotnie `server.jar`; Windows może użyć Javy 8 lub Javy 21, a Minecraft 26.2 wymaga 64-bitowej Javy 25+. Zobacz [pełną instrukcję po angielsku](../en/how-does-jarock-work.md).**

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> InvView 1.4.21 is a verified Minecraft 26.2 server-side Fabric mod. It requires Fabric API and lets authorized operators inspect and manage online or offline player inventories and ender chests; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> OfflineCommands 1.0.3 is a verified Minecraft 26.2 server-side Fabric mod for running commands on offline players. No compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

<!-- jarock-safe-shutdown -->

## Bezpieczne zatrzymanie

> Wpisz `stop` i pozostaw okno otwarte. Przed zamknięciem poczekaj na `CLEAN SHUTDOWN COMPLETE`, a następnie `SAFE TO CLOSE`. Jeśli drugiego komunikatu nie ma, sprawdź log i raport awarii oraz w razie potrzeby przywróć kopię.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Aktualizacja Jarock

> Odczytaj `scripts/version.txt`, zatrzymaj serwer i poczekaj na `SAFE TO CLOSE`; następnie uruchom `scripts/update-jarock.bat`. Wyszuka nowsze wydanie w tym samym kanale beta/stabilnym, poprosi o potwierdzenie i utworzy kopię do wycofania. Świat, runtime, mody, biblioteki i ustawienia lokalne zostają zachowane; zależności są naprawiane tylko gdy ich brakuje lub są nieprawidłowe.

> Pełny pakiet i opublikowana suma kontrolna SHA-512 są sprawdzane przed instalacją.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Sprawdzanie aktualizacji przy uruchamianiu

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Ochrona przed zamknięciem konsoli Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Wpisz stop i poczekaj na SAFE TO CLOSE. Nie wymuszaj zamknięcia podczas zapisywania świata. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
