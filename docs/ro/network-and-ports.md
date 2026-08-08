# Ghid de rețea, firewall și router

Instalați Java 25 pe 64 de biți, rulați `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` și finalizați `TODO.md` înainte de a deschide porturile. Atribuiți un IP LAN fix, deschideți TCP `25565` (Java) și UDP `19132` (Bedrock) în firewall-ul Windows, configurați redirecționarea porturilor pe router sau folosiți un tunel UDP ca playit.gg. Asigurați-vă că `online-mode=true` și `white-list=true` sunt activate și nu publicați niciodată `key.pem`. Pentru CGNAT, folosiți un tunel. Consultați [ghidul în engleză](../en/network-and-ports.md).

> Folosiți întotdeauna `start-server.bat`; nu faceți dublu clic pe `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Oprire sigură

> Scrieți `stop` și lăsați fereastra deschisă. Înainte de închidere așteptați `CLEAN SHUTDOWN COMPLETE`, apoi `SAFE TO CLOSE`. Dacă al doilea mesaj lipsește, verificați jurnalul și raportul de eroare și restaurați o copie dacă este necesar.

<!-- jarock-updater -->


## Actualizarea Jarock

> Citiți `scripts/version.txt`, opriți serverul și așteptați `SAFE TO CLOSE`; apoi rulați `scripts/update-jarock.bat`. Caută o versiune mai nouă în același canal beta/stabil, cere confirmare și creează o copie pentru revenire. Lumea, runtime-ul, modurile, bibliotecile și setările locale sunt păstrate; dependențele sunt reparate doar dacă lipsesc sau sunt invalide.

> Pachetul complet și suma de verificare SHA-512 publicată sunt verificate înainte de instalare.

<!-- jarock-auto-update-check -->

## Verificarea actualizărilor la pornire

Startup update modes: AUTO_UPDATE_MODE=auto checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.
