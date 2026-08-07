# Pelancaran pertama Jarock

## Memilih loader

Pasang JDK Java 25+ 64-bit, aktifkan JAVA_HOME dalam pemasang Temurin dan buka semula terminal. Sentiasa jalankan `start-server.bat` en `scripts/server-launch-settings.ini` di root dan jangan buka `server/server.jar` secara terus.

## Pemasangan dan EULA

Jalankan `start-server.bat` dan pilih Fabric (disyorkan), NeoForge (sandaran) atau Forge (kini tidak tersedia untuk Minecraft 26.2). `parameter-manager.bat` mengkonfigurasi RAM, GUI/konsol, GC, `online-mode`, banner dan `AUTO_UPDATE_CHECK`. **Exit without saving** membatalkan tanpa menyimpan.

## Penutupan selamat

Jarock memuat turun loader dan mod yang dipinkan secara automatik. Larian pertama mencipta `server/eula.txt` dan berhenti. Baca Minecraft EULA dan tukar `eula=false` kepada `eula=true` hanya jika bersetuju. Jangan gunakan `online-mode=false` sebelum larian pertama berjaya.

## Penutupan selamat

Jalankan semula, tunggu world, Geyser dan Floodgate selesai, taip `stop` dan tunggu `CLEAN SHUTDOWN COMPLETE` serta `SAFE TO CLOSE`. Ikuti Suggested fix jika gagal; jika loader bercampur, buat sandaran dan jalankan `clean-server-runtime.bat`. Baca `TODO.md` sebelum akses awam.

## Nota keselamatan

Lengkapkan larian pertama dengan `online-mode=true` supaya pengesahan biasa berfungsi.

## Nota keselamatan

Untuk memasang kemas kini, hentikan pelayan dengan selamat dan jalankan `scripts/update-jarock.bat`.

<!-- jarock-lan-addresses-ms -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.
