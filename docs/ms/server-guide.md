# Panduan pelayan Fabric

Pasang Java 25 64-bit, jalankan `start-server.bat` dan gunakan `parameter-manager.bat` untuk RAM serta GUI atau `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Baca `server/eula.txt`, terima EULA dan tetapkan `eula=true`; gunakan Fabric, Geyser-Fabric dan Floodgate-Fabric, buat sandaran, dan Jarock tidak mengubah router, firewall atau port forwarding.

Lihat panduan lengkap bahasa Inggeris: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Show ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Nota teknikal: Sentiasa gunakan `start-server.bat` di akar repositori. Jangan klik dua kali `server.jar`; Windows mungkin menggunakan Java 8 atau Java 21, sedangkan Minecraft 26.2 memerlukan Java 25+ 64-bit. Lihat [panduan bahasa Inggeris lengkap](../en/server-guide.md).**



<!-- jarock-lan-addresses-ms -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-safe-shutdown -->

## Penutupan selamat

> Taip `stop` dan biarkan tetingkap terbuka. Tunggu `CLEAN SHUTDOWN COMPLETE` kemudian `SAFE TO CLOSE` sebelum menutupnya. Jika mesej kedua tiada, semak log dan laporan ranap dan pulihkan sandaran jika perlu.

<!-- jarock-updater -->


## Kemas kini Jarock

> Baca `scripts/version.txt`, hentikan pelayan dan tunggu `SAFE TO CLOSE`; kemudian jalankan `scripts/update-jarock.bat`. Ia mencari keluaran lebih baharu dalam saluran beta/stabil yang sama, meminta pengesahan dan membuat sandaran rollback. Dunia, runtime, mod, pustaka dan tetapan tempatan dikekalkan; kebergantungan hanya dibaiki jika hilang atau tidak sah.

> Pakej penuh dan checksum SHA-512 yang diterbitkan disahkan sebelum pemasangan.

<!-- jarock-auto-update-check -->

## Semakan kemas kini semasa mula

Startup update modes: AUTO_UPDATE_MODE=auto checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.
