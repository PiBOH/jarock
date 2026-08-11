# NeoForge-terugvalhandleiding

Gebruik NeoForge alleen als laatste optie wanneer Fabric niet werkt. Forge en NeoForge zijn verschillende loaders; mods moeten voor NeoForge zijn. Voeg Geyser/Floodgate toe indien nodig en test eerst een kopie.

See the [English NeoForge fallback guide](../en/neoforge-fallback.md) for the complete procedure. Verify every mod against the selected loader.

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

<!-- jarock-safe-shutdown -->

## Veilig afsluiten

> Typ `stop` en laat het venster open. Wacht vóór het sluiten op `CLEAN SHUTDOWN COMPLETE` en daarna `SAFE TO CLOSE`. Ontbreekt de tweede melding, controleer dan het log en crashrapport en herstel zo nodig een back-up.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Jarock bijwerken

> Lees `scripts/version.txt`, stop de server en wacht op `SAFE TO CLOSE`; voer daarna `scripts/update-jarock.bat` uit. Het zoekt een nieuwere release in hetzelfde beta/stabiele kanaal, vraagt bevestiging en maakt een rollback-back-up. Wereld, runtime, mods, bibliotheken en lokale instellingen blijven behouden; afhankelijkheden worden alleen hersteld als ze ontbreken of ongeldig zijn.

> Het volledige pakket en de gepubliceerde SHA-512-controlesom worden vóór de installatie gecontroleerd.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Updatecontrole bij het opstarten

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified package matching scripts/jarock-edition.ini automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Bescherming tegen het sluiten van de Windows-console:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Typ stop en wacht op SAFE TO CLOSE. Forceer nooit het sluiten tijdens het opslaan van de wereld. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
