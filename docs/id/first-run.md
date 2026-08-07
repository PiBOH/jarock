# Penggunaan pertama Jarock

## Memilih loader

Pasang JDK Java 25+ 64-bit, aktifkan JAVA_HOME di installer Temurin, lalu buka kembali terminal. Selalu jalankan `start-server.bat` en `scripts/server-launch-settings.ini` di root dan jangan membuka `server/server.jar` secara langsung.

## Instalasi dan EULA

Jalankan `start-server.bat`, lalu pilih Fabric (disarankan), NeoForge (cadangan), atau Forge (saat ini tidak tersedia untuk Minecraft 26.2). `parameter-manager.bat` mengatur RAM, GUI/konsol, GC, `online-mode`, banner, dan `AUTO_UPDATE_CHECK`. **Exit without saving** membatalkan tanpa menyimpan.

## Mematikan dengan aman

Jarock mengunduh loader dan mod yang dipatok secara otomatis. Proses pertama membuat `server/eula.txt` lalu biasanya berhenti. Baca Minecraft EULA dan ubah `eula=false` menjadi `eula=true` hanya jika setuju. Jangan memakai `online-mode=false` sebelum proses pertama berhasil.

## Mematikan dengan aman

Jalankan lagi, tunggu world, Geyser, dan Floodgate selesai, ketik `stop`, lalu tunggu `CLEAN SHUTDOWN COMPLETE` dan `SAFE TO CLOSE`. Ikuti Suggested fix jika gagal; bila loader tercampur, buat cadangan dan jalankan `clean-server-runtime.bat`. Baca `TODO.md` sebelum akses publik.

## Catatan keamanan

Selesaikan proses pertama dengan `online-mode=true` agar autentikasi normal berfungsi.

## Catatan keamanan

Untuk memasang pembaruan, hentikan server dengan aman lalu jalankan `scripts/update-jarock.bat`.
