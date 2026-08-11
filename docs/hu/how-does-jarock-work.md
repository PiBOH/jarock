# Hogyan működik a Jarock?

## A szerver egyszerű magyarázata

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Betöltő:** Fabric
**Fő platform:** Windows 10/11

Ez a dokumentum bemutatja, mi történik a Jarock letöltése után.


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome Message 2.8 with its required Collective library is included as a verified server-side Minecraft 26.2 mod for Fabric and NeoForge; it sends configurable join messages.

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

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> InvView 1.4.21 is a verified Minecraft 26.2 server-side Fabric mod. It requires Fabric API and lets authorized operators inspect and manage online or offline player inventories and ender chests; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> OfflineCommands 1.0.3 is a verified Minecraft 26.2 server-side Fabric mod for running commands on offline players. No compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

<!-- jarock-safe-shutdown -->

## Biztonságos leállítás

> Írja be a `stop` parancsot, és hagyja nyitva az ablakot. Bezárás előtt várja meg a `CLEAN SHUTDOWN COMPLETE`, majd a `SAFE TO CLOSE` üzenetet. Ha a második üzenet hiányzik, ellenőrizze a naplót és a hibajelentést, szükség esetén állítsa vissza a mentést.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Jarock frissítése

> Olvassa el a `scripts/version.txt` fájlt, állítsa le a szervert, és várja meg a `SAFE TO CLOSE` üzenetet; ezután futtassa az `scripts/update-jarock.bat` fájlt. Azonos béta/stabil csatornán keres újabb verziót, megerősítést kér és visszaállítási mentést készít. A világ, a runtime, a modok, a könyvtárak és a helyi beállítások megmaradnak; a függőségeket csak hiány vagy érvénytelenség esetén javítja.

> A teljes csomag és a hozzá közzétett SHA-512 ellenőrzőösszeg telepítés előtt ellenőrzésre kerül.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Frissítések ellenőrzése indításkor

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified package matching scripts/jarock-edition.ini automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows-konzolabezárás elleni védelem:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Írja be a stop parancsot, és várjon a SAFE TO CLOSE üzenetre. Mentés közben ne kényszerítse a bezárást. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
