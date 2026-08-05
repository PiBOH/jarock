# Hogyan működik a Jarock?

## A szerver egyszerű magyarázata

**Jelenlegi verzió:** `0.0.2-alpha`  
**Minecraft:** Java Edition `26.2`  
**Betöltő:** Fabric  
**Fő platform:** Windows 10/11

Ez a dokumentum bemutatja, mi történik a Jarock letöltése után.

## 1. Röviden

A felhasználó telepít egy támogatott 64 bites Java runtime-ot, letölti ezt a repository-t, majd elindítja a `start-server.bat` fájlt. A program megtalálja a saját mappáját, ellenőrzi a Java-t és az elérési utat, szükség esetén engedélyezi a Windows hosszú elérési útjait, letölti a rögzített Fabric telepítőt és a modokat, majd SHA-512 segítségével ellenőrzi a fájlokat.

A Fabric a futtatási környezetet a `server/` mappában hozza létre. Az első indítás létrehozza a `server/eula.txt` fájlt `eula=false` értékkel, majd leáll. A felhasználónak el kell olvasnia a <https://www.minecraft.net/eula> oldalt, elfogadás esetén `eula=true` értékre kell állítania, majd újra kell indítania. A Geyser fordítja a Bedrock-forgalmat, a Floodgate pedig kezeli a Bedrock-hitelesítést.

A Jarock **nem** állít be routert, tűzfalat vagy port forwardingot.

## 2. Fájlok és folyamat

A repository szkripteket, sablonokat és manifestet tartalmaz, de a világot és a generált `.jar` fájlokat nem:

```text
start-server.bat
scripts/bootstrap-fabric.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
version.txt
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