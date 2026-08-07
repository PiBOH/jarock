# Vodič za mrežu, vatrozid i usmjerivač

Instalirajte 64-bitni Java 25, pokrenite `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` i dovršite `TODO.md` prije otvaranja portova. Dodijelite fiksni LAN IP, otvorite TCP `25565` (Java) i UDP `19132` (Bedrock) u Windows vatrozidu, konfigurirajte prosljeđivanje portova na usmjerivaču ili koristite UDP tunel poput playit.gg. Provjerite `online-mode=true` i `white-list=true` i nikada ne objavljujte `key.pem`. Za CGNAT koristite tunel. Pogledajte [kanonski engleski vodič](../en/network-and-ports.md).

> Uvijek koristite `start-server.bat`; ne dvoklikajte `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.
