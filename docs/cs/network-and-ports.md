# Průvodce sítí, firewallem a routerem

Nainstalujte 64bitovou Javu 25, spusťte `start-server.bat` a dokončete `TODO.md` před otevřením portů. Přidělte pevnou LAN IP, otevřete TCP `25565` (Java) a UDP `19132` (Bedrock) ve Windows Firewallu, nakonfigurujte přesměrování portů na routeru nebo použijte UDP tunel jako playit.gg. Zkontrolujte `online-mode=true` a `white-list=true` a nikdy nezveřejňujte `key.pem`. Pro CGNAT použijte tunel. Viz [kanonický anglický průvodce](../en/network-and-ports.md). (abilita Set JAVA_HOME nell’installer Temurin) (enable "Set JAVA_HOME variable" in the Temurin installer)

> Vždy používejte `start-server.bat`; neklikejte dvakrát na `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Bezpečné vypnutí

> Napište `stop` do konzole a nechte okno otevřené. Před zavřením počkejte na `CLEAN SHUTDOWN COMPLETE` a potom `SAFE TO CLOSE`. Pokud druhá zpráva chybí, zkontrolujte log a hlášení pádu a podle potřeby obnovte zálohu.

<!-- jarock-updater -->


## Aktualizace Jarock

> Přečtěte `version.txt`, zastavte server a počkejte na `SAFE TO CLOSE`; potom spusťte `update-jarock.bat`. Vyhledá novější verzi ve stejném beta/stabilním kanálu, vyžádá potvrzení a vytvoří zálohu pro návrat. Svět, runtime, mody, knihovny a místní nastavení zůstanou zachovány; závislosti se obnoví jen při chybění nebo neplatnosti.

> Úplný balíček a jeho zveřejněný kontrolní součet SHA-512 se před instalací ověří.
