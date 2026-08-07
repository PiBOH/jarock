# Hálózati, tűzfal és router útmutató

Telepítsen 64 bites Java 25-öt, futtassa a `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` fájlt és fejezze be a `TODO.md`-t a portok megnyitása előtt. Rendeljen fix LAN IP-t, nyissa meg a TCP `25565` (Java) és UDP `19132` (Bedrock) portokat a Windows tűzfalban, konfigurálja a porttovábbítást a routeren, vagy használjon UDP-kompatibilis alagutat mint a playit.gg. Ellenőrizze, hogy `online-mode=true` és `white-list=true`, és soha ne tegye közzé a `key.pem` fájlt. CGNAT esetén használjon alagutat. Lásd a [hivatalos angol útmutatót](../en/network-and-ports.md).

> Mindig a `start-server.bat` fájlt használja; ne kattintson duplán a `server.jar`-ra.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.
