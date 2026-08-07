# NeoForge-terugvalhandleiding

Gebruik NeoForge alleen als laatste optie wanneer Fabric niet werkt. Forge en NeoForge zijn verschillende loaders; mods moeten voor NeoForge zijn. Voeg Geyser/Floodgate toe indien nodig en test eerst een kopie.

See the [English NeoForge fallback guide](../en/neoforge-fallback.md) for the complete procedure. Verify every mod against the selected loader.

<!-- jarock-safe-shutdown -->

## Veilig afsluiten

> Typ `stop` en laat het venster open. Wacht vóór het sluiten op `CLEAN SHUTDOWN COMPLETE` en daarna `SAFE TO CLOSE`. Ontbreekt de tweede melding, controleer dan het log en crashrapport en herstel zo nodig een back-up.

<!-- jarock-updater -->


## Jarock bijwerken

> Lees `scripts/version.txt`, stop de server en wacht op `SAFE TO CLOSE`; voer daarna `scripts/update-jarock.bat` uit. Het zoekt een nieuwere release in hetzelfde beta/stabiele kanaal, vraagt bevestiging en maakt een rollback-back-up. Wereld, runtime, mods, bibliotheken en lokale instellingen blijven behouden; afhankelijkheden worden alleen hersteld als ze ontbreken of ongeldig zijn.

> Het volledige pakket en de gepubliceerde SHA-512-controlesom worden vóór de installatie gecontroleerd.

<!-- jarock-auto-update-check -->

## Updatecontrole bij het opstarten

Stel AUTO_UPDATE_CHECK=true in parameter-manager.bat in zodat start-server.bat GitHub bij het opstarten alleen-lezen controleert. Een compatibele nieuwere Jarock-versie wordt gemeld, maar niets wordt automatisch geïnstalleerd. Stop de server, wacht op SAFE TO CLOSE en voer scripts/update-jarock.bat uit. De standaardwaarde is AUTO_UPDATE_CHECK=false. When a compatible newer release is found at startup, Jarock asks `Download and install it now? (y/N)`; choose y to install the verified Lite package, or N/Enter to continue with the current version. It never updates silently.
