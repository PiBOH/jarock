# Ghid pentru server Fabric

Instalați Java 25 pe 64 de biți, rulați `start-server.bat` și folosiți `parameter-manager.bat` pentru RAM și GUI sau `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Citiți `server/eula.txt`, acceptați EULA și setați `eula=true`; folosiți Fabric, Geyser-Fabric și Floodgate-Fabric, faceți backup, iar Jarock nu modifică routerul, firewall-ul sau port forwarding.

Consultați ghidul complet în engleză: [../en/server-guide.md](../en/server-guide.md)


Jarock never moves, renames, deletes or replaces an existing world automatically. If Minecraft reports a world-integrity or generation error, stop safely, inspect the logs and crash report, and restore the world from a known-good backup. A fresh world is generated only after you deliberately delete the existing `world`, `world_nether` and `world_the_end` folders yourself. If only some of `world`, `world_nether` and `world_the_end` exist, Jarock refuses to start to prevent mixing old and new dimensions; restore all three from a backup or deliberately delete all three to create a new world. Java stores the Nether and End inside the configured `level-name` folder as `DIM-1` and `DIM1`. If that configured folder exists, Jarock leaves it untouched and lets Minecraft load it or report its integrity error. A new world is possible only when the configured folder is absent and no other possible old world folder remains; after a `level-name` change, Jarock refuses to start instead of silently replacing an existing world.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Show ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Notă tehnică: Folosiți întotdeauna `start-server.bat` din rădăcina repository-ului. Nu faceți dublu clic pe `server.jar`; Windows poate folosi Java 8 sau Java 21, în timp ce Minecraft 26.2 necesită Java 25+ pe 64 de biți. Consultați [ghidul complet în engleză](../en/server-guide.md).**



<!-- jarock-lan-addresses-ro -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-safe-shutdown -->

## Oprire sigură

> Scrieți `stop` și lăsați fereastra deschisă. Înainte de închidere așteptați `CLEAN SHUTDOWN COMPLETE`, apoi `SAFE TO CLOSE`. Dacă al doilea mesaj lipsește, verificați jurnalul și raportul de eroare și restaurați o copie dacă este necesar.

<!-- jarock-updater -->


## Actualizarea Jarock

> Citiți `scripts/version.txt`, opriți serverul și așteptați `SAFE TO CLOSE`; apoi rulați `scripts/update-jarock.bat`. Caută o versiune mai nouă în același canal beta/stabil, cere confirmare și creează o copie pentru revenire. Lumea, runtime-ul, modurile, bibliotecile și setările locale sunt păstrate; dependențele sunt reparate doar dacă lipsesc sau sunt invalide.

> Pachetul complet și suma de verificare SHA-512 publicată sunt verificate înainte de instalare.

<!-- jarock-auto-update-check -->

## Verificarea actualizărilor la pornire

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Protecție împotriva închiderii consolei Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Tastează stop și așteaptă SAFE TO CLOSE. Nu forța închiderea în timpul salvării lumii. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
