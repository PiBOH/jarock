# Panduan rangkaian, firewall dan penghala

Pasang Java 25 64-bit, jalankan `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` dan selesaikan `TODO.md` sebelum membuka port. Tetapkan IP LAN tetap, buka TCP `25565` (Java) dan UDP `19132` (Bedrock) dalam Windows Firewall, konfigurasikan pemajuan port pada penghala atau gunakan terowong UDP seperti playit.gg. Pastikan `online-mode=true` dan `white-list=true` diaktifkan dan jangan sesekali menerbitkan `key.pem`. Untuk CGNAT, gunakan terowong. Lihat [panduan bahasa Inggeris](../en/network-and-ports.md).

> Sentiasa gunakan `start-server.bat`; jangan klik dua kali `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Penutupan selamat

> Taip `stop` dan biarkan tetingkap terbuka. Tunggu `CLEAN SHUTDOWN COMPLETE` kemudian `SAFE TO CLOSE` sebelum menutupnya. Jika mesej kedua tiada, semak log dan laporan ranap dan pulihkan sandaran jika perlu.

<!-- jarock-updater -->


## Kemas kini Jarock

> Baca `scripts/version.txt`, hentikan pelayan dan tunggu `SAFE TO CLOSE`; kemudian jalankan `scripts/update-jarock.bat`. Ia mencari keluaran lebih baharu dalam saluran beta/stabil yang sama, meminta pengesahan dan membuat sandaran rollback. Dunia, runtime, mod, pustaka dan tetapan tempatan dikekalkan; kebergantungan hanya dibaiki jika hilang atau tidak sah.

> Pakej penuh dan checksum SHA-512 yang diterbitkan disahkan sebelum pemasangan.

<!-- jarock-auto-update-check -->

## Semakan kemas kini semasa mula

Tetapkan AUTO_UPDATE_CHECK=true dalam parameter-manager.bat supaya start-server.bat menjalankan semakan GitHub baca sahaja. Versi Jarock serasi yang lebih baharu akan dilaporkan, tetapi tiada pemasangan automatik. Hentikan pelayan, tunggu SAFE TO CLOSE dan jalankan scripts/update-jarock.bat. Nilai lalai ialah AUTO_UPDATE_CHECK=false.
