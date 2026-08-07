# Gids voor netwerk, firewall en router

Installeer 64-bit Java 25, voer `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` uit en voltooi `TODO.md` voordat je poorten opent. Wijs een vast LAN IP toe, open TCP `25565` (Java) en UDP `19132` (Bedrock) in Windows Firewall, configureer port forwarding op de router of gebruik een UDP-compatibele tunnel zoals playit.gg. Zorg dat `online-mode=true` en `white-list=true` aan staan en publiceer `key.pem` nooit. Gebruik een tunnel bij CGNAT. Zie de [canonieke Engelse handleiding](../en/network-and-ports.md).

> Gebruik altijd `start-server.bat`; dubbelklik niet op `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Veilig afsluiten

> Typ `stop` en laat het venster open. Wacht vóór het sluiten op `CLEAN SHUTDOWN COMPLETE` en daarna `SAFE TO CLOSE`. Ontbreekt de tweede melding, controleer dan het log en crashrapport en herstel zo nodig een back-up.

<!-- jarock-updater -->


## Jarock bijwerken

> Lees `version.txt`, stop de server en wacht op `SAFE TO CLOSE`; voer daarna `update-jarock.bat` uit. Het zoekt een nieuwere release in hetzelfde beta/stabiele kanaal, vraagt bevestiging en maakt een rollback-back-up. Wereld, runtime, mods, bibliotheken en lokale instellingen blijven behouden; afhankelijkheden worden alleen hersteld als ze ontbreken of ongeldig zijn.

> Het volledige pakket en de gepubliceerde SHA-512-controlesom worden vóór de installatie gecontroleerd.
