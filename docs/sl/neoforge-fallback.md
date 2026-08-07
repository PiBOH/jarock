# Rezervni vodnik NeoForge

NeoForge uporabite le kot zadnjo možnost, ko Fabric ni primeren. Forge in NeoForge sta različna loaderja, modi morajo ustrezati NeoForge; po potrebi dodajte Geyser/Floodgate in najprej preizkusite kopijo.

Oglejte si celoten angleški priročnik: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## Varna zaustavitev

> Vnesite `stop` in pustite okno odprto. Pred zaprtjem počakajte na `CLEAN SHUTDOWN COMPLETE` in nato `SAFE TO CLOSE`. Če drugega sporočila ni, preverite dnevnik in poročilo o sesutju ter po potrebi obnovite varnostno kopijo.

<!-- jarock-updater -->


## Posodobitev Jarock

> Preberite `scripts/version.txt`, ustavite strežnik in počakajte na `SAFE TO CLOSE`; nato zaženite `scripts/update-jarock.bat`. Poišče novejšo izdajo istega beta/stabilnega kanala, zahteva potrditev in ustvari varnostno kopijo za povrnitev. Svet, runtime, modifikacije, knjižnice in lokalne nastavitve ostanejo; odvisnosti se popravijo le, če manjkajo ali so neveljavne.

> Celoten paket in njegova objavljena kontrolna vsota SHA-512 se preverita pred namestitvijo.

<!-- jarock-auto-update-check -->

## Preverjanje posodobitev ob zagonu

V parameter-manager.bat nastavite AUTO_UPDATE_CHECK=true, da start-server.bat preveri izdaje GitHub samo za branje. Poročal bo o združljivi novejši različici Jarock, vendar je ne bo samodejno namestil. Ustavite strežnik, počakajte na SAFE TO CLOSE in zaženite scripts/update-jarock.bat. Privzeto je AUTO_UPDATE_CHECK=false. When a compatible newer release is found at startup, Jarock asks `Download and install it now? (y/N)`; choose y to install the verified Lite package, or N/Enter to continue with the current version. It never updates silently.
