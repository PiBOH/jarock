# Rezervni vodnik NeoForge

NeoForge uporabite le kot zadnjo možnost, ko Fabric ni primeren. Forge in NeoForge sta različna loaderja, modi morajo ustrezati NeoForge; po potrebi dodajte Geyser/Floodgate in najprej preizkusite kopijo.

Oglejte si celoten angleški priročnik: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## Varna zaustavitev

> Vnesite `stop` in pustite okno odprto. Pred zaprtjem počakajte na `CLEAN SHUTDOWN COMPLETE` in nato `SAFE TO CLOSE`. Če drugega sporočila ni, preverite dnevnik in poročilo o sesutju ter po potrebi obnovite varnostno kopijo.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Posodobitev Jarock

> Preberite `scripts/version.txt`, ustavite strežnik in počakajte na `SAFE TO CLOSE`; nato zaženite `scripts/update-jarock.bat`. Poišče novejšo izdajo istega beta/stabilnega kanala, zahteva potrditev in ustvari varnostno kopijo za povrnitev. Svet, runtime, modifikacije, knjižnice in lokalne nastavitve ostanejo; odvisnosti se popravijo le, če manjkajo ali so neveljavne.

> Celoten paket in njegova objavljena kontrolna vsota SHA-512 se preverita pred namestitvijo.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Preverjanje posodobitev ob zagonu

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Zaščita pred zapiranjem konzole Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Vnesite stop in počakajte na SAFE TO CLOSE. Med shranjevanjem sveta ne zapirajte prisilno. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
