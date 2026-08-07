# Gids vir netwerk, firewall en router

Installeer 64-bis Java 25, voer `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` uit en voltooi `TODO.md` voordat jy poorte oopmaak. Ken 'n vaste LAN IP toe, maak TCP `25565` (Java) en UDP `19132` (Bedrock) in Windows Defender Firewall oop, stel poort-aanstuur op die router op of gebruik 'n UDP-versoenbare tonnel soos playit.gg. Maak seker `online-mode=true` en `white-list=true` is aan en publiseer nooit `key.pem` nie. Gebruik 'n tonnel vir CGNAT. Sien die [kanonieke Engelse gids](../en/network-and-ports.md).

> Gebruik altyd `start-server.bat`; moenie op `server.jar` dubbelklik nie.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Veilige afsluiting

> Tik `stop` in die bedienerkonsole en laat die venster oop. Wag vir `CLEAN SHUTDOWN COMPLETE` en daarna `SAFE TO CLOSE` voordat jy dit sluit. As die tweede boodskap ontbreek, lees die log en crash-verslag en herstel ’n rugsteun indien nodig.

<!-- jarock-updater -->


## Jarock-bywerking

> Lees `scripts/version.txt`, stop die bediener en wag vir `SAFE TO CLOSE`; voer dan `scripts/update-jarock.bat` uit. Dit soek ’n nuwer vrystelling in dieselfde beta/stabiele kanaal, vra bevestiging en maak ’n terugrolrugsteun. Die wêreld, runtime, mods, biblioteke en plaaslike instellings bly behoue; afhanklikhede word net herstel as hulle ontbreek of ongeldig is.

> Die volledige pakket en sy gepubliseerde SHA-512-kontrolesom word voor installasie nagegaan.

<!-- jarock-auto-update-check -->

## Kontrole vir opdaterings tydens opstart

Stel AUTO_UPDATE_CHECK=true in parameter-manager.bat sodat start-server.bat tydens opstart 'n leesalleen-GitHub-kontrole uitvoer. Dit meld 'n versoenbare nuwer Jarock-weergawe, maar installeer niks outomaties nie. Stop veilig, wag vir SAFE TO CLOSE en voer scripts/update-jarock.bat uit. Die verstek is AUTO_UPDATE_CHECK=false.
