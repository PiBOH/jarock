# Vodič za Fabric poslužitelj

Instaliraj 64-bitnu Javu 25, pokreni `start-server.bat` i koristi `parameter-manager.bat` za RAM te GUI ili `nogui`. Pročitaj `server/eula.txt` i postavi `eula=true` tek nakon prihvaćanja EULA-e. Koristi Fabric, Geyser-Fabric i Floodgate-Fabric te izradi backup. Jarock ne mijenja router, firewall ni port forwarding.

See the [English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


Jarock never moves, renames, deletes or replaces an existing world automatically. If Minecraft reports a world-integrity or generation error, stop safely, inspect the logs and crash report, and restore the world from a known-good backup. A fresh world is generated only after you deliberately delete the existing `world`, `world_nether` and `world_the_end` folders yourself. If only some of `world`, `world_nether` and `world_the_end` exist, Jarock refuses to start to prevent mixing old and new dimensions; restore all three from a backup or deliberately delete all three to create a new world. Java stores the Nether and End inside the configured `level-name` folder as `DIM-1` and `DIM1`. If that configured folder exists, Jarock leaves it untouched and lets Minecraft load it or report its integrity error. A new world is possible only when the configured folder is absent and no other possible old world folder remains; after a `level-name` change, Jarock refuses to start instead of silently replacing an existing world.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Show ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> Technical fallback note: Links In Chat is included in the pinned Fabric 26.2 server stack. It makes URLs in server chat clickable and adds `/link` and `/linkwhisper`; clients do not need to install it. Welcome AWA is also included as a verified server-side Fabric 26.2 mod; it sends configurable colored join messages using `%player%` and supports `welcome reload`.
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Tehnička napomena: Uvijek koristite `start-server.bat` iz korijena repozitorija. (enable "Set JAVA_HOME variable" in the Temurin installer) Nemojte dvaput kliknuti `server.jar`; Windows može koristiti Java 8 ili Java 21, dok Minecraft 26.2 zahtijeva 64-bitnu Javu 25+. Pogledajte [potpuni vodič na engleskom](../en/server-guide.md).**



<!-- jarock-lan-addresses-hr -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

<!-- jarock-safe-shutdown -->

## Sigurno gašenje

> Upišite `stop` i ostavite prozor otvoren. Prije zatvaranja pričekajte `CLEAN SHUTDOWN COMPLETE`, a zatim `SAFE TO CLOSE`. Ako druga poruka nedostaje, provjerite zapisnik i izvještaj o padu te po potrebi vratite sigurnosnu kopiju.

<!-- jarock-updater -->


## Ažuriranje Jarocka

> Pročitajte `scripts/version.txt`, zaustavite poslužitelj i pričekajte `SAFE TO CLOSE`; zatim pokrenite `scripts/update-jarock.bat`. Traži noviju verziju istog beta/stabilnog kanala, traži potvrdu i stvara pričuvnu kopiju za povratak. Svijet, runtime, modovi, biblioteke i lokalne postavke ostaju sačuvani; ovisnosti se obnavljaju samo ako nedostaju ili nisu valjane.

> Potpuni paket i njegov objavljeni kontrolni zbroj SHA-512 provjeravaju se prije instalacije.

<!-- jarock-auto-update-check -->

## Provjera ažuriranja pri pokretanju

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Zaštita od zatvaranja Windows konzole:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Upišite stop i pričekajte SAFE TO CLOSE. Ne prisiljavajte zatvaranje dok se svijet sprema. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
