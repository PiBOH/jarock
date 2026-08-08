# Vodnik za omrežje, požarni zid in usmerjevalnik

Namestite 64-bitno Javo 25, zaženite `start-server.bat` in dokončajte `TODO.md` pred odpiranjem vrat. Dodelite fiksni LAN IP, odprite TCP `25565` (Java) in UDP `19132` (Bedrock) v požarnem zidu Windows, konfigurirajte posredovanje vrat na usmerjevalniku ali uporabite UDP združljiv tunel, kot je playit.gg. Preverite `online-mode=true` in `white-list=true` in nikoli ne objavite `key.pem`. Za CGNAT uporabite tunel. Glejte [kanonični angleški vodnik](../en/network-and-ports.md). (abilita Set JAVA_HOME nell’installer Temurin) (enable "Set JAVA_HOME variable" in the Temurin installer)

> Vedno uporabite `start-server.bat`; ne dvokliknite `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Varna zaustavitev

> Vnesite `stop` in pustite okno odprto. Pred zaprtjem počakajte na `CLEAN SHUTDOWN COMPLETE` in nato `SAFE TO CLOSE`. Če drugega sporočila ni, preverite dnevnik in poročilo o sesutju ter po potrebi obnovite varnostno kopijo.

<!-- jarock-updater -->


## Posodobitev Jarock

> Preberite `scripts/version.txt`, ustavite strežnik in počakajte na `SAFE TO CLOSE`; nato zaženite `scripts/update-jarock.bat`. Poišče novejšo izdajo istega beta/stabilnega kanala, zahteva potrditev in ustvari varnostno kopijo za povrnitev. Svet, runtime, modifikacije, knjižnice in lokalne nastavitve ostanejo; odvisnosti se popravijo le, če manjkajo ali so neveljavne.

> Celoten paket in njegova objavljena kontrolna vsota SHA-512 se preverita pred namestitvijo.

<!-- jarock-auto-update-check -->

## Preverjanje posodobitev ob zagonu

Startup update modes: AUTO_UPDATE_MODE=auto checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.
