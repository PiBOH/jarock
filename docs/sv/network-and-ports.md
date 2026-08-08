# Guide för nätverk, brandvägg och router

Installera 64-bitars Java 25, kör `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` och slutför `TODO.md` innan du öppnar portar. Tilldela en fast LAN IP, öppna TCP `25565` (Java) och UDP `19132` (Bedrock) i Windows brandvägg, konfigurera portvidarebefordran på routern eller använd en UDP-kompatibel tunnel som playit.gg. Kontrollera att `online-mode=true` och `white-list=true` är aktiverade och publicera aldrig `key.pem`. Använd en tunnel vid CGNAT. Se den [kanoniska engelska guiden](../en/network-and-ports.md).

> Använd alltid `start-server.bat`; dubbelklicka inte på `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Säker avstängning

> Skriv `stop` och låt fönstret vara öppet. Vänta på `CLEAN SHUTDOWN COMPLETE` och sedan `SAFE TO CLOSE` innan du stänger det. Om det andra meddelandet saknas, kontrollera loggen och kraschrapporten och återställ en säkerhetskopia vid behov.

<!-- jarock-updater -->


## Uppdatera Jarock

> Läs `scripts/version.txt`, stoppa servern och vänta på `SAFE TO CLOSE`; kör sedan `scripts/update-jarock.bat`. Den söker efter en nyare version i samma beta/stabila kanal, frågar efter bekräftelse och skapar en återställningskopia. Värld, runtime, moddar, bibliotek och lokala inställningar bevaras; beroenden repareras bara om de saknas eller är ogiltiga.

> Hela paketet och dess publicerade SHA-512-kontrollsumma verifieras före installationen.

<!-- jarock-auto-update-check -->

## Sök efter uppdateringar vid start

Startup update modes: AUTO_UPDATE_MODE=auto checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.
