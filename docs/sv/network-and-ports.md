# Guide för nätverk, brandvägg och router

Installera 64-bitars Java 25, kör `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` och slutför `TODO.md` innan du öppnar portar. Tilldela en fast LAN IP, öppna TCP `25565` (Java) och UDP `19132` (Bedrock) i Windows brandvägg, konfigurera portvidarebefordran på routern eller använd en UDP-kompatibel tunnel som playit.gg. Kontrollera att `online-mode=true` och `white-list=true` är aktiverade och publicera aldrig `key.pem`. Använd en tunnel vid CGNAT. Se den [kanoniska engelska guiden](../en/network-and-ports.md).

> Använd alltid `start-server.bat`; dubbelklicka inte på `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.
