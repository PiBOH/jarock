# Jak Jarock funguje?

## Jednoduché vysvětlení serveru

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Loader:** Fabric
**Hlavní platforma:** Windows 10/11

Tento dokument vysvětluje, co se stane po stažení Jarocku.


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome AWA is also included as a verified server-side Fabric 26.2 mod; it sends configurable colored join messages using `%player%` and supports `welcome reload`.

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

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

<!-- jarock-safe-shutdown -->

## Bezpečné vypnutí

> Napište `stop` do konzole a nechte okno otevřené. Před zavřením počkejte na `CLEAN SHUTDOWN COMPLETE` a potom `SAFE TO CLOSE`. Pokud druhá zpráva chybí, zkontrolujte log a hlášení pádu a podle potřeby obnovte zálohu.

<!-- jarock-updater -->


## Aktualizace Jarock

> Přečtěte `scripts/version.txt`, zastavte server a počkejte na `SAFE TO CLOSE`; potom spusťte `scripts/update-jarock.bat`. Vyhledá novější verzi ve stejném beta/stabilním kanálu, vyžádá potvrzení a vytvoří zálohu pro návrat. Svět, runtime, mody, knihovny a místní nastavení zůstanou zachovány; závislosti se obnoví jen při chybění nebo neplatnosti.

> Úplný balíček a jeho zveřejněný kontrolní součet SHA-512 se před instalací ověří.

<!-- jarock-auto-update-check -->

## Kontrola aktualizací při spuštění

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Ochrana před zavřením konzole Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Napište stop a počkejte na SAFE TO CLOSE. Při ukládání světa nikdy nevynucujte zavření. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
