# Hálózati, tűzfal és router útmutató

Telepítsen 64 bites Java 25-öt, futtassa a `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` fájlt és fejezze be a `TODO.md`-t a portok megnyitása előtt. Rendeljen fix LAN IP-t, nyissa meg a TCP `25565` (Java) és UDP `19132` (Bedrock) portokat a Windows tűzfalban, konfigurálja a porttovábbítást a routeren, vagy használjon UDP-kompatibilis alagutat mint a playit.gg. Ellenőrizze, hogy `online-mode=true` és `white-list=true`, és soha ne tegye közzé a `key.pem` fájlt. CGNAT esetén használjon alagutat. Lásd a [hivatalos angol útmutatót](../en/network-and-ports.md).

> Mindig a `start-server.bat` fájlt használja; ne kattintson duplán a `server.jar`-ra.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Biztonságos leállítás

> Írja be a `stop` parancsot, és hagyja nyitva az ablakot. Bezárás előtt várja meg a `CLEAN SHUTDOWN COMPLETE`, majd a `SAFE TO CLOSE` üzenetet. Ha a második üzenet hiányzik, ellenőrizze a naplót és a hibajelentést, szükség esetén állítsa vissza a mentést.

<!-- jarock-updater -->


## Jarock frissítése

> Olvassa el a `scripts/version.txt` fájlt, állítsa le a szervert, és várja meg a `SAFE TO CLOSE` üzenetet; ezután futtassa az `scripts/update-jarock.bat` fájlt. Azonos béta/stabil csatornán keres újabb verziót, megerősítést kér és visszaállítási mentést készít. A világ, a runtime, a modok, a könyvtárak és a helyi beállítások megmaradnak; a függőségeket csak hiány vagy érvénytelenség esetén javítja.

> A teljes csomag és a hozzá közzétett SHA-512 ellenőrzőösszeg telepítés előtt ellenőrzésre kerül.

<!-- jarock-auto-update-check -->

## Frissítések ellenőrzése indításkor

Állítsd AUTO_UPDATE_CHECK=true értékre a parameter-manager.bat fájlban, hogy a start-server.bat csak olvasási GitHub-ellenőrzést végezzen. Jelzi a kompatibilis újabb verziót, de nem telepít automatikusan. Állítsd le biztonságosan a szervert, várd meg a SAFE TO CLOSE üzenetet, majd futtasd az scripts/update-jarock.bat fájlt. Az alapérték AUTO_UPDATE_CHECK=false.
