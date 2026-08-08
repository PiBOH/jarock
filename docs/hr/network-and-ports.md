# Vodič za mrežu, vatrozid i usmjerivač

Instalirajte 64-bitni Java 25, pokrenite `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` i dovršite `TODO.md` prije otvaranja portova. Dodijelite fiksni LAN IP, otvorite TCP `25565` (Java) i UDP `19132` (Bedrock) u Windows vatrozidu, konfigurirajte prosljeđivanje portova na usmjerivaču ili koristite UDP tunel poput playit.gg. Provjerite `online-mode=true` i `white-list=true` i nikada ne objavljujte `key.pem`. Za CGNAT koristite tunel. Pogledajte [kanonski engleski vodič](../en/network-and-ports.md).

> Uvijek koristite `start-server.bat`; ne dvoklikajte `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Sigurno gašenje

> Upišite `stop` i ostavite prozor otvoren. Prije zatvaranja pričekajte `CLEAN SHUTDOWN COMPLETE`, a zatim `SAFE TO CLOSE`. Ako druga poruka nedostaje, provjerite zapisnik i izvještaj o padu te po potrebi vratite sigurnosnu kopiju.

<!-- jarock-updater -->


## Ažuriranje Jarocka

> Pročitajte `scripts/version.txt`, zaustavite poslužitelj i pričekajte `SAFE TO CLOSE`; zatim pokrenite `scripts/update-jarock.bat`. Traži noviju verziju istog beta/stabilnog kanala, traži potvrdu i stvara pričuvnu kopiju za povratak. Svijet, runtime, modovi, biblioteke i lokalne postavke ostaju sačuvani; ovisnosti se obnavljaju samo ako nedostaju ili nisu valjane.

> Potpuni paket i njegov objavljeni kontrolni zbroj SHA-512 provjeravaju se prije instalacije.

<!-- jarock-auto-update-check -->

## Provjera ažuriranja pri pokretanju

Startup update modes: AUTO_UPDATE_MODE=auto checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.
