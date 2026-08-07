# Fabric szerver útmutató

Telepítsen 64 bites Java 25-öt, futtassa a `start-server.bat` fájlt, és használja a `parameter-manager.bat` fájlt RAM-hoz, GUI-hoz vagy `nogui` módhoz. (enable "Set JAVA_HOME variable" in the Temurin installer) Olvassa el a `server/eula.txt` fájlt, fogadja el az EULA-t és állítsa `eula=true` értékre; használjon Fabricet, Geyser-Fabricet és Floodgate-Fabricet, és készítsen mentést. A Jarock nem módosít routert, tűzfalat vagy porttovábbítást.

Olvassa a teljes angol útmutatót: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Technikai megjegyzés: Mindig a repository gyökerében található `start-server.bat` fájlt használja. Ne kattintson duplán a `server.jar` fájlra; a Windows Java 8-at vagy Java 21-et használhat, miközben a Minecraft 26.2 64 bites Java 25+-t igényel. Lásd a [teljes angol útmutatót](../en/server-guide.md).**

<!-- jarock-safe-shutdown -->

## Biztonságos leállítás

> Írja be a `stop` parancsot, és hagyja nyitva az ablakot. Bezárás előtt várja meg a `CLEAN SHUTDOWN COMPLETE`, majd a `SAFE TO CLOSE` üzenetet. Ha a második üzenet hiányzik, ellenőrizze a naplót és a hibajelentést, szükség esetén állítsa vissza a mentést.

<!-- jarock-updater -->


## Jarock frissítése

> Olvassa el a `version.txt` fájlt, állítsa le a szervert, és várja meg a `SAFE TO CLOSE` üzenetet; ezután futtassa az `update-jarock.bat` fájlt. Azonos béta/stabil csatornán keres újabb verziót, megerősítést kér és visszaállítási mentést készít. A világ, a runtime, a modok, a könyvtárak és a helyi beállítások megmaradnak; a függőségeket csak hiány vagy érvénytelenség esetén javítja.

> A teljes csomag és a hozzá közzétett SHA-512 ellenőrzőösszeg telepítés előtt ellenőrzésre kerül.

<!-- jarock-auto-update-check -->

## Frissítések ellenőrzése indításkor

Állítsd AUTO_UPDATE_CHECK=true értékre a parameter-manager.bat fájlban, hogy a start-server.bat csak olvasási GitHub-ellenőrzést végezzen. Jelzi a kompatibilis újabb verziót, de nem telepít automatikusan. Állítsd le biztonságosan a szervert, várd meg a SAFE TO CLOSE üzenetet, majd futtasd az update-jarock.bat fájlt. Az alapérték AUTO_UPDATE_CHECK=false.
