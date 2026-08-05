# Hoe werkt Jarock?

## Eenvoudige uitleg van de server

**Huidige versie:** `0.0.2-alpha`  
**Minecraft:** Java Edition `26.2`  
**Loader:** Fabric  
**Hoofdplatform:** Windows 10/11

Dit document legt uit wat er gebeurt nadat Jarock is gedownload.

## 1. Kort samengevat

De gebruiker installeert 64-bits Java, downloadt deze repository en start `start-server.bat`. Het programma vindt zijn eigen map, controleert Java en het pad, vraagt indien nodig om Windows-ondersteuning voor lange paden, downloadt de vastgezette Fabric-installer en mods en controleert elk bestand met SHA-512.

Fabric maakt de runtime in `server/`. De eerste start maakt `server/eula.txt` met `eula=false` en stopt. De gebruiker moet <https://www.minecraft.net/eula> lezen, `eula=true` instellen als hij of zij akkoord gaat en opnieuw starten. Geyser vertaalt Bedrock-verkeer en Floodgate regelt de Bedrock-authenticatie.

Jarock configureert **geen** router, firewall of port forwarding.

## 2. Bestanden en mappen

De repository bevat scripts, sjablonen en een manifest, maar niet de wereld of gegenereerde `.jar`-bestanden:

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

De runtime wordt in `server/` gemaakt. Werelden, logs, bibliotheken, privésleutels en lokale lijsten worden door Git genegeerd.

`start-server.bat` gebruikt zijn eigen locatie in plaats van een vast pad zoals `C:\MinecraftServer`. Toegankelijke paden met spaties, Unicode, `!` en geneste mappen worden ondersteund. Voor lange paden wordt dit gecontroleerd:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

Als het nodig is, vraagt het script administratorrechten en voert het `scripts\enable-long-paths.ps1` uit. De wijziging is systeemwijd en een herstart kan nodig zijn.

## 3. EULA, Geyser en fouten

De eerste start maakt `server/eula.txt` met `eula=false` en stopt. Lees de EULA, verander dit naar `eula=true` als je akkoord gaat en start opnieuw.

Geyser maakt zijn volledige configuratie tijdens de eerste echte serverstart. Daarna stelt het script in:

```text
server\config\Geyser-Fabric\config.yml
```

```yaml
auth-type: floodgate
```

Java gebruikt normaal TCP `25565` en Bedrock UDP `19132`. Jarock opent geen poorten. `key.pem` is privé en mag niet worden gepubliceerd.

Lees na elke fout `ERROR:` of `WARNING:` en volg `Suggested fix:`. Als Java stopt, zoek dan de eerste `Caused by:` in `server\logs\latest.log` of `server\crash-reports\`. De resterende taken staan in `TODO.md`.