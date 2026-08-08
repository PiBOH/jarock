# Gids voor netwerk, firewall en router

Installeer 64-bit Java 25, voer `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` uit en voltooi `TODO.md` voordat je poorten opent. Wijs een vast LAN IP toe, open TCP `25565` (Java) en UDP `19132` (Bedrock) in Windows Firewall, configureer port forwarding op de router of gebruik een UDP-compatibele tunnel zoals playit.gg. Zorg dat `online-mode=true` en `white-list=true` aan staan en publiceer `key.pem` nooit. Gebruik een tunnel bij CGNAT. Zie de [canonieke Engelse handleiding](../en/network-and-ports.md).

> Gebruik altijd `start-server.bat`; dubbelklik niet op `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Veilig afsluiten

> Typ `stop` en laat het venster open. Wacht vóór het sluiten op `CLEAN SHUTDOWN COMPLETE` en daarna `SAFE TO CLOSE`. Ontbreekt de tweede melding, controleer dan het log en crashrapport en herstel zo nodig een back-up.

<!-- jarock-updater -->


## Jarock bijwerken

> Lees `scripts/version.txt`, stop de server en wacht op `SAFE TO CLOSE`; voer daarna `scripts/update-jarock.bat` uit. Het zoekt een nieuwere release in hetzelfde beta/stabiele kanaal, vraagt bevestiging en maakt een rollback-back-up. Wereld, runtime, mods, bibliotheken en lokale instellingen blijven behouden; afhankelijkheden worden alleen hersteld als ze ontbreken of ongeldig zijn.

> Het volledige pakket en de gepubliceerde SHA-512-controlesom worden vóór de installatie gecontroleerd.

<!-- jarock-auto-update-check -->

## Updatecontrole bij het opstarten

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Bescherming tegen het sluiten van de Windows-console:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Typ stop en wacht op SAFE TO CLOSE. Forceer nooit het sluiten tijdens het opslaan van de wereld. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
