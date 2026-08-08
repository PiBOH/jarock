# Fabric-serverguide

Installera 64-bitars Java 25, kör `start-server.bat` och använd `parameter-manager.bat` för RAM och GUI eller `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Läs `server/eula.txt`, godkänn EULA och sätt `eula=true`; använd Fabric, Geyser-Fabric och Floodgate-Fabric, skapa säkerhetskopior, och Jarock ändrar inte router, brandvägg eller port forwarding.

Se den fullständiga engelska guiden: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Show ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Teknisk information: Använd alltid `start-server.bat` i repositoryts rot. Dubbelklicka inte på `server.jar`; Windows kan använda Java 8 eller Java 21, medan Minecraft 26.2 kräver 64-bitars Java 25+. Se [den fullständiga engelska guiden](../en/server-guide.md).**



<!-- jarock-lan-addresses-sv -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-safe-shutdown -->

## Säker avstängning

> Skriv `stop` och låt fönstret vara öppet. Vänta på `CLEAN SHUTDOWN COMPLETE` och sedan `SAFE TO CLOSE` innan du stänger det. Om det andra meddelandet saknas, kontrollera loggen och kraschrapporten och återställ en säkerhetskopia vid behov.

<!-- jarock-updater -->


## Uppdatera Jarock

> Läs `scripts/version.txt`, stoppa servern och vänta på `SAFE TO CLOSE`; kör sedan `scripts/update-jarock.bat`. Den söker efter en nyare version i samma beta/stabila kanal, frågar efter bekräftelse och skapar en återställningskopia. Värld, runtime, moddar, bibliotek och lokala inställningar bevaras; beroenden repareras bara om de saknas eller är ogiltiga.

> Hela paketet och dess publicerade SHA-512-kontrollsumma verifieras före installationen.

<!-- jarock-auto-update-check -->

## Sök efter uppdateringar vid start

Startup update modes: AUTO_UPDATE_MODE=auto checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.
