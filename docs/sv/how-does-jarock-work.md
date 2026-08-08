# Hur fungerar Jarock?

## En enkel förklaring av servern

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Loader:** Fabric
**Huvudplattform:** Windows 10/11

Det här dokumentet förklarar vad som händer efter att Jarock har laddats ner.


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Underhållsnotis:** startprogrammet söker nu efter en kompatibel 64-bitars Java 25+-körning i stället för att bara lita på den första `java.exe` i `PATH`. Det använder `scripts/java-runtime.ps1`, sparar den valda körbara filen i `server/java-path.txt` och validerar den före start. Java 8 kan vara installerat.

## 1. Kort version

Användaren installerar Java med 64 bitar, laddar ner detta repository och kör `start-server.bat`. Programmet hittar sin egen mapp, kontrollerar Java och sökvägen, begär stöd för långa Windows-sökvägar vid behov, laddar ner den fastställda Fabric-installeraren och mods och verifierar varje fil med SHA-512.

Fabric skapar runtime i `server/`. Den första körningen skapar `server/eula.txt` med `eula=false` och avslutas. Användaren måste läsa <https://www.minecraft.net/eula>, ändra till `eula=true` om villkoren accepteras och köra igen. Geyser översätter Bedrock-trafik och Floodgate hanterar Bedrock-autentisering.

Jarock konfigurerar **inte** router, firewall eller port forwarding.

## 2. Filer och flöde

Repository innehåller scripts, mallar och manifest, men inte världen eller genererade `.jar`-filer:

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

Runtime skapas i `server/`. Git ignorerar världar, logs, bibliotek, privata nycklar och lokala listor.

`start-server.bat` använder sin egen plats i stället för en fast sökväg som `C:\MinecraftServer`, och stöder därför tillgängliga sökvägar med mellanslag, Unicode, `!` och nästlade mappar. För långa sökvägar kontrolleras:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

Vid behov begär skriptet administratörsbehörighet och kör `scripts\enable-long-paths.ps1`. Ändringen gäller hela datorn och äldre program kan behöva starta om Windows.

## 3. EULA, Geyser och fel

Den första körningen skapar `server/eula.txt` med `eula=false` och stannar. Läs EULA, ändra till `eula=true` om du godkänner den och kör igen.

Geyser skapar sin fullständiga konfiguration vid den första riktiga serverstarten. När filen finns:

```text
server\config\Geyser-Fabric\config.yml
```

ställer skriptet in:

```yaml
auth-type: floodgate
```

Java använder normalt TCP `25565` och Bedrock UDP `19132`. Jarock öppnar inga portar. `key.pem` är privat och får inte publiceras.

Efter ett fel, läs `ERROR:` eller `WARNING:` och följ `Suggested fix:`. Om Java avslutas, leta efter den första `Caused by:` i `server\logs\latest.log` eller `server\crash-reports\`. Återstående uppgifter finns i `TODO.md`.

> **Teknisk information: Använd alltid `start-server.bat` i repositoryts rot. Dubbelklicka inte på `server.jar`; Windows kan använda Java 8 eller Java 21, medan Minecraft 26.2 kräver 64-bitars Java 25+. Se [den fullständiga engelska guiden](../en/how-does-jarock-work.md).**

<!-- jarock-safe-shutdown -->

## Säker avstängning

> Skriv `stop` och låt fönstret vara öppet. Vänta på `CLEAN SHUTDOWN COMPLETE` och sedan `SAFE TO CLOSE` innan du stänger det. Om det andra meddelandet saknas, kontrollera loggen och kraschrapporten och återställ en säkerhetskopia vid behov.

<!-- jarock-updater -->


## Uppdatera Jarock

> Läs `scripts/version.txt`, stoppa servern och vänta på `SAFE TO CLOSE`; kör sedan `scripts/update-jarock.bat`. Den söker efter en nyare version i samma beta/stabila kanal, frågar efter bekräftelse och skapar en återställningskopia. Värld, runtime, moddar, bibliotek och lokala inställningar bevaras; beroenden repareras bara om de saknas eller är ogiltiga.

> Hela paketet och dess publicerade SHA-512-kontrollsumma verifieras före installationen.

<!-- jarock-auto-update-check -->

## Sök efter uppdateringar vid start

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Skydd mot att stänga Windows-konsolen:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Skriv stop och vänta på SAFE TO CLOSE. Tvinga aldrig stängning medan världen sparas. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
