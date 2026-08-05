# Jak Jarock funguje?

## Jednoduché vysvětlení serveru

**Aktuální verze:** `0.0.2-alpha`  
**Minecraft:** Java Edition `26.2`  
**Loader:** Fabric  
**Hlavní platforma:** Windows 10/11

Tento dokument vysvětluje, co se stane po stažení Jarocku.

## 1. Stručně

Uživatel nainstaluje 64bitovou Javu, stáhne tento repository a spustí `start-server.bat`. Program najde vlastní složku, zkontroluje Javu a cestu, podle potřeby požádá o zapnutí dlouhých cest ve Windows, stáhne připnutý Fabric installer a mods a každý soubor ověří pomocí SHA-512.

Fabric vytvoří runtime v `server/`. První spuštění vytvoří `server/eula.txt` s hodnotou `eula=false` a zastaví se. Uživatel si musí přečíst <https://www.minecraft.net/eula>, při souhlasu nastavit `eula=true` a spustit znovu. Geyser překládá provoz Bedrocku a Floodgate řeší jeho autentizaci.

Jarock **nenastavuje** router, firewall ani port forwarding.

## 2. Soubory a průběh

Repository obsahuje skripty, šablony a manifest, nikoli svět nebo vygenerované `.jar` soubory:

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

Runtime vzniká v `server/`; Git ignoruje světy, logy, knihovny, soukromé klíče a místní seznamy.

`start-server.bat` používá vlastní umístění namísto pevné cesty jako `C:\MinecraftServer`, takže podporuje dostupné cesty s mezerami, Unicode, `!` a vnořenými složkami. U dlouhých cest kontroluje:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

V případě potřeby vyžádá administrátorská oprávnění a spustí `scripts\enable-long-paths.ps1`. Změna je systémová a může vyžadovat restart Windows.

## 3. EULA, Geyser a chyby

První spuštění vytvoří `server/eula.txt` s `eula=false` a skončí. Přečtěte si EULA, při souhlasu změňte hodnotu na `eula=true` a spusťte znovu.

Geyser vytvoří úplnou konfiguraci při prvním skutečném spuštění. Poté skript v:

```text
server\config\Geyser-Fabric\config.yml
```

nastaví:

```yaml
auth-type: floodgate
```

Java obvykle používá TCP `25565` a Bedrock UDP `19132`. Jarock porty neotevírá. `key.pem` je soukromý a nesmí být zveřejněn.

Po chybě si přečtěte `ERROR:` nebo `WARNING:` a postupujte podle `Suggested fix:`. Pokud Java skončí, vyhledejte první `Caused by:` v `server\logs\latest.log` nebo `server\crash-reports\`. Zbývající úkoly jsou v `TODO.md`.