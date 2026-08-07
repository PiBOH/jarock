# Gids vir netwerk, firewall en router

Installeer 64-bis Java 25, voer `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` uit en voltooi `TODO.md` voordat jy poorte oopmaak. Ken 'n vaste LAN IP toe, maak TCP `25565` (Java) en UDP `19132` (Bedrock) in Windows Defender Firewall oop, stel poort-aanstuur op die router op of gebruik 'n UDP-versoenbare tonnel soos playit.gg. Maak seker `online-mode=true` en `white-list=true` is aan en publiseer nooit `key.pem` nie. Gebruik 'n tonnel vir CGNAT. Sien die [kanonieke Engelse gids](../en/network-and-ports.md).

> Gebruik altyd `start-server.bat`; moenie op `server.jar` dubbelklik nie.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.
