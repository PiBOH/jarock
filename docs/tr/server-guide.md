# Fabric sunucu kılavuzu

64 bit Java 25 kurun, `start-server.bat` çalıştırın ve RAM ile GUI veya `nogui` ayarlarını `parameter-manager.bat` üzerinden yapın. (enable "Set JAVA_HOME variable" in the Temurin installer) `server/eula.txt` dosyasını okuyun, EULA’yı kabul edip `eula=true` yapın; Fabric, Geyser-Fabric ve Floodgate-Fabric kullanın, yedek alın, Jarock router, firewall veya port forwarding değiştirmez.

Tam İngilizce kılavuza bakın: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Teknik not: Her zaman repository kökündeki `start-server.bat` dosyasını kullanın. `server.jar` dosyasına çift tıklamayın; Windows Java 8 veya Java 21 kullanabilir, ancak Minecraft 26.2 için 64 bit Java 25+ gerekir. [Tam İngilizce kılavuza](../en/server-guide.md) bakın.**
