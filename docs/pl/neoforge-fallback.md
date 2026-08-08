# Poradnik awaryjny NeoForge

NeoForge wybierz tylko jako ostatnią opcję, gdy Fabric nie pasuje. Forge i NeoForge to różne loadery, a mody muszą pasować do NeoForge; w razie potrzeby dodaj Geyser/Floodgate i najpierw testuj kopię.

Zobacz pełny poradnik po angielsku: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## Bezpieczne zatrzymanie

> Wpisz `stop` i pozostaw okno otwarte. Przed zamknięciem poczekaj na `CLEAN SHUTDOWN COMPLETE`, a następnie `SAFE TO CLOSE`. Jeśli drugiego komunikatu nie ma, sprawdź log i raport awarii oraz w razie potrzeby przywróć kopię.

<!-- jarock-updater -->


## Aktualizacja Jarock

> Odczytaj `scripts/version.txt`, zatrzymaj serwer i poczekaj na `SAFE TO CLOSE`; następnie uruchom `scripts/update-jarock.bat`. Wyszuka nowsze wydanie w tym samym kanale beta/stabilnym, poprosi o potwierdzenie i utworzy kopię do wycofania. Świat, runtime, mody, biblioteki i ustawienia lokalne zostają zachowane; zależności są naprawiane tylko gdy ich brakuje lub są nieprawidłowe.

> Pełny pakiet i opublikowana suma kontrolna SHA-512 są sprawdzane przed instalacją.

<!-- jarock-auto-update-check -->

## Sprawdzanie aktualizacji przy uruchamianiu

Startup update modes: AUTO_UPDATE_MODE=auto checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.
