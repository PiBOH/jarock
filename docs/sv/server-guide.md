# Fabric-serverguide

Installera 64-bitars Java 25, kör `start-server.bat` och använd `parameter-manager.bat` för RAM och GUI eller `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Läs `server/eula.txt`, godkänn EULA och sätt `eula=true`; använd Fabric, Geyser-Fabric och Floodgate-Fabric, skapa säkerhetskopior, och Jarock ändrar inte router, brandvägg eller port forwarding.

Se den fullständiga engelska guiden: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Teknisk information: Använd alltid `start-server.bat` i repositoryts rot. Dubbelklicka inte på `server.jar`; Windows kan använda Java 8 eller Java 21, medan Minecraft 26.2 kräver 64-bitars Java 25+. Se [den fullständiga engelska guiden](../en/server-guide.md).**
