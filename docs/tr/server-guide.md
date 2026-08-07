# Fabric sunucu kılavuzu

64 bit Java 25 kurun, `start-server.bat` çalıştırın ve RAM ile GUI veya `nogui` ayarlarını `parameter-manager.bat` üzerinden yapın. (enable "Set JAVA_HOME variable" in the Temurin installer) `server/eula.txt` dosyasını okuyun, EULA’yı kabul edip `eula=true` yapın; Fabric, Geyser-Fabric ve Floodgate-Fabric kullanın, yedek alın, Jarock router, firewall veya port forwarding değiştirmez.

Tam İngilizce kılavuza bakın: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Teknik not: Her zaman repository kökündeki `start-server.bat` dosyasını kullanın. `server.jar` dosyasına çift tıklamayın; Windows Java 8 veya Java 21 kullanabilir, ancak Minecraft 26.2 için 64 bit Java 25+ gerekir. [Tam İngilizce kılavuza](../en/server-guide.md) bakın.**
