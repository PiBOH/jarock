# Guia del servidor Fabric

Instal·la Java 25 de 64 bits, executa `start-server.bat` i usa `parameter-manager.bat` per a RAM i GUI o `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Llegeix `server/eula.txt` i posa `eula=true` només després d’acceptar la EULA. Usa Fabric, Geyser-Fabric i Floodgate-Fabric i fes còpies. Jarock no modifica router, firewall ni port forwarding.

See the [English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Show ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Nota tècnica: Utilitza sempre el `start-server.bat` de l’arrel del repositori. No facis doble clic a `server.jar`; Windows pot utilitzar Java 8 o Java 21, mentre que Minecraft 26.2 requereix Java 25+ de 64 bits. Consulta la [guia anglesa completa](../en/server-guide.md).**



<!-- jarock-lan-addresses-ca -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-safe-shutdown -->

## Aturada segura

> Escriu `stop` a la consola i deixa la finestra oberta. Espera `CLEAN SHUTDOWN COMPLETE` i després `SAFE TO CLOSE` abans de tancar-la. Si falta el segon missatge, revisa el registre i l’informe de fallada i restaura una còpia si cal.

<!-- jarock-updater -->


## Actualitzar Jarock

> Llegeix `scripts/version.txt`, atura el servidor i espera `SAFE TO CLOSE`; després executa `scripts/update-jarock.bat`. Cerca una versió més nova del mateix canal beta/estable, demana confirmació i crea una còpia de retorn. Conserva el món, el runtime, els mods, les biblioteques i la configuració local; només repara dependències absents o invàlides.

> El paquet complet i la seva suma de verificació SHA-512 publicada es comproven abans de la instal·lació.

<!-- jarock-auto-update-check -->

## Comprovació d'actualitzacions en iniciar

Startup update modes: AUTO_UPDATE_MODE=auto checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.
