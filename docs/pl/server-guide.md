# Poradnik serwera Fabric

Zainstaluj 64-bitową Javę 25, uruchom `start-server.bat` i użyj `parameter-manager.bat` do RAM oraz GUI lub `nogui`. Przeczytaj `server/eula.txt`, zaakceptuj EULA i ustaw `eula=true`; używaj Fabric, Geyser-Fabric i Floodgate-Fabric, twórz kopie, a Jarock nie zmienia routera, zapory ani port forwarding.

Zobacz pełny poradnik po angielsku: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Uwaga techniczna: Zawsze używaj pliku `start-server.bat` z katalogu głównego repozytorium. Nie klikaj dwukrotnie `server.jar`; Windows może użyć Javy 8 lub Javy 21, a Minecraft 26.2 wymaga 64-bitowej Javy 25+. Zobacz [pełną instrukcję po angielsku](../en/server-guide.md).**

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
