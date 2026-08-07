# Jak Jarock funguje?

## Jednoduché vysvětlení serveru

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Loader:** Fabric
**Hlavní platforma:** Windows 10/11

Tento dokument vysvětluje, co se stane po stažení Jarocku.


> DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Poznámka k údržbě:** Spouštěč nyní vyhledává kompatibilní 64bitové Java 25+ místo toho, aby důvěřoval pouze prvnímu `java.exe` v `PATH`. Používá `scripts/java-runtime.ps1`, uloží vybraný spustitelný soubor do `server/java-path.txt` a před spuštěním ho ověří. Java 8 může zůstat nainstalovaná.

## 1. Stručně

Uživatel nainstaluje 64bitovou Javu, stáhne tento repository a spustí `start-server.bat`. Program najde vlastní složku, zkontroluje Javu a cestu, podle potřeby požádá o zapnutí dlouhých cest ve Windows, stáhne připnutý Fabric installer a mods a každý soubor ověří pomocí SHA-512.

Fabric vytvoří runtime v `server/`. První spuštění vytvoří `server/eula.txt` s hodnotou `eula=false` a zastaví se. Uživatel si musí přečíst <https://www.minecraft.net/eula>, při souhlasu nastavit `eula=true` a spustit znovu. Geyser překládá provoz Bedrocku a Floodgate řeší jeho autentizaci.

Jarock **nenastavuje** router, firewall ani port forwarding.

## 2. Soubory a průběh

Repository obsahuje skripty, šablony a manifest, nikoli svět nebo vygenerované `.jar` soubory:

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

> **Technická poznámka: Vždy používejte `start-server.bat` v kořenu repozitáře. Na `server.jar` neklikejte dvakrát; Windows může použít Javu 8 nebo Javu 21, zatímco Minecraft 26.2 vyžaduje 64bitovou Javu 25+. Viz [úplná anglická příručka](../en/how-does-jarock-work.md).**

<!-- jarock-safe-shutdown -->

## Bezpečné vypnutí

> Napište `stop` do konzole a nechte okno otevřené. Před zavřením počkejte na `CLEAN SHUTDOWN COMPLETE` a potom `SAFE TO CLOSE`. Pokud druhá zpráva chybí, zkontrolujte log a hlášení pádu a podle potřeby obnovte zálohu.

<!-- jarock-updater -->


## Aktualizace Jarock

> Přečtěte `scripts/version.txt`, zastavte server a počkejte na `SAFE TO CLOSE`; potom spusťte `scripts/update-jarock.bat`. Vyhledá novější verzi ve stejném beta/stabilním kanálu, vyžádá potvrzení a vytvoří zálohu pro návrat. Svět, runtime, mody, knihovny a místní nastavení zůstanou zachovány; závislosti se obnoví jen při chybění nebo neplatnosti.

> Úplný balíček a jeho zveřejněný kontrolní součet SHA-512 se před instalací ověří.

<!-- jarock-auto-update-check -->

## Kontrola aktualizací při spuštění

Nastav AUTO_UPDATE_CHECK=true v parameter-manager.bat, aby start-server.bat provedl kontrolu vydání GitHub pouze pro čtení. Oznámí kompatibilní novější verzi, ale nic nenainstaluje automaticky. Bezpečně server zastav, počkej na SAFE TO CLOSE a spusť scripts/update-jarock.bat. Výchozí hodnota je AUTO_UPDATE_CHECK=false.
