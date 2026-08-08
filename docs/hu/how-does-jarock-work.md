# Hogyan működik a Jarock?

## A szerver egyszerű magyarázata

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Betöltő:** Fabric
**Fő platform:** Windows 10/11

Ez a dokumentum bemutatja, mi történik a Jarock letöltése után.


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Karbantartási megjegyzés:** Az indító most kompatibilis, 64 bites Java 25+ futtatókörnyezetet keres, ahelyett hogy csak a `PATH` első `java.exe` fájljára hagyatkozna. A `scripts/java-runtime.ps1` fájlt használja, a kiválasztott végrehajtható fájlt a `server/java-path.txt` fájlba menti, és indítás előtt ellenőrzi. A Java 8 telepítve maradhat.

## 1. Röviden

A felhasználó telepít egy támogatott 64 bites Java runtime-ot, letölti ezt a repository-t, majd elindítja a `start-server.bat` fájlt. A program megtalálja a saját mappáját, ellenőrzi a Java-t és az elérési utat, szükség esetén engedélyezi a Windows hosszú elérési útjait, letölti a rögzített Fabric telepítőt és a modokat, majd SHA-512 segítségével ellenőrzi a fájlokat.

A Fabric a futtatási környezetet a `server/` mappában hozza létre. Az első indítás létrehozza a `server/eula.txt` fájlt `eula=false` értékkel, majd leáll. A felhasználónak el kell olvasnia a <https://www.minecraft.net/eula> oldalt, elfogadás esetén `eula=true` értékre kell állítania, majd újra kell indítania. A Geyser fordítja a Bedrock-forgalmat, a Floodgate pedig kezeli a Bedrock-hitelesítést.

A Jarock **nem** állít be routert, tűzfalat vagy port forwardingot.

## 2. Fájlok és folyamat

A repository szkripteket, sablonokat és manifestet tartalmaz, de a világot és a generált `.jar` fájlokat nem:

```text
start-server.bat
scripts/bootstrap-server.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
scripts/version.txt
CHANGELOG.md
TODO.md
```

A runtime a `server/` mappában jön létre. A Git figyelmen kívül hagyja a világokat, logokat, könyvtárakat, privát kulcsokat és helyi listákat.

A `start-server.bat` a saját helyét használja, nem egy rögzített útvonalat, például `C:\MinecraftServer`. Ezért támogatja az elérhető, szóközt, Unicode karaktereket, `!` jelet vagy beágyazott mappákat tartalmazó útvonalakat. Hosszú útvonalaknál ezt ellenőrzi:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

Szükség esetén rendszergazdai engedélyt kér, majd futtatja a `scripts\enable-long-paths.ps1` fájlt. A változás gépszintű, és régebbi programoknál újraindításra lehet szükség.

## 3. EULA, Geyser és hibák

Az első futtatás létrehozza a `server/eula.txt` fájlt `eula=false` értékkel, majd leáll. Olvasd el az EULA-t, elfogadás esetén állítsd `eula=true` értékre, majd indítsd újra.

A Geyser a teljes konfigurációt az első valódi szerverindítás során hozza létre. Ezután a szkript ebben a fájlban:

```text
server\config\Geyser-Fabric\config.yml
```

beállítja:

```yaml
auth-type: floodgate
```

A Java általában TCP `25565`, a Bedrock pedig UDP `19132` portot használ. A Jarock nem nyit portokat. A `key.pem` privát fájl, közzétenni tilos.

Hiba után olvasd el az `ERROR:` vagy `WARNING:` sort, és kövesd a `Suggested fix:` javaslatot. Ha a Java leáll, keresd meg az első `Caused by:` sort a `server\logs\latest.log` vagy a `server\crash-reports\` fájlban. A fennmaradó feladatok a `TODO.md` fájlban vannak.

> **Technikai megjegyzés: Mindig a repository gyökerében található `start-server.bat` fájlt használja. Ne kattintson duplán a `server.jar` fájlra; a Windows Java 8-at vagy Java 21-et használhat, miközben a Minecraft 26.2 64 bites Java 25+-t igényel. Lásd a [teljes angol útmutatót](../en/how-does-jarock-work.md).**

<!-- jarock-safe-shutdown -->

## Biztonságos leállítás

> Írja be a `stop` parancsot, és hagyja nyitva az ablakot. Bezárás előtt várja meg a `CLEAN SHUTDOWN COMPLETE`, majd a `SAFE TO CLOSE` üzenetet. Ha a második üzenet hiányzik, ellenőrizze a naplót és a hibajelentést, szükség esetén állítsa vissza a mentést.

<!-- jarock-updater -->


## Jarock frissítése

> Olvassa el a `scripts/version.txt` fájlt, állítsa le a szervert, és várja meg a `SAFE TO CLOSE` üzenetet; ezután futtassa az `scripts/update-jarock.bat` fájlt. Azonos béta/stabil csatornán keres újabb verziót, megerősítést kér és visszaállítási mentést készít. A világ, a runtime, a modok, a könyvtárak és a helyi beállítások megmaradnak; a függőségeket csak hiány vagy érvénytelenség esetén javítja.

> A teljes csomag és a hozzá közzétett SHA-512 ellenőrzőösszeg telepítés előtt ellenőrzésre kerül.

<!-- jarock-auto-update-check -->

## Frissítések ellenőrzése indításkor

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows-konzolabezárás elleni védelem:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Írja be a stop parancsot, és várjon a SAFE TO CLOSE üzenetre. Mentés közben ne kényszerítse a bezárást. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
