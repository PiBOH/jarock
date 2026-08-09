# Panduan rangkaian, firewall dan penghala

Pasang Java 25 64-bit, jalankan `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` dan selesaikan `TODO.md` sebelum membuka port. Tetapkan IP LAN tetap, buka TCP `25565` (Java) dan UDP `19132` (Bedrock) dalam Windows Firewall, konfigurasikan pemajuan port pada penghala atau gunakan terowong UDP seperti playit.gg. Pastikan `online-mode=true` dan `white-list=true` diaktifkan dan jangan sesekali menerbitkan `key.pem`. Untuk CGNAT, gunakan terowong. Lihat [panduan bahasa Inggeris](../en/network-and-ports.md).

> Sentiasa gunakan `start-server.bat`; jangan klik dua kali `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Penutupan selamat

> Taip `stop` dan biarkan tetingkap terbuka. Tunggu `CLEAN SHUTDOWN COMPLETE` kemudian `SAFE TO CLOSE` sebelum menutupnya. Jika mesej kedua tiada, semak log dan laporan ranap dan pulihkan sandaran jika perlu.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Kemas kini Jarock

> Baca `scripts/version.txt`, hentikan pelayan dan tunggu `SAFE TO CLOSE`; kemudian jalankan `scripts/update-jarock.bat`. Ia mencari keluaran lebih baharu dalam saluran beta/stabil yang sama, meminta pengesahan dan membuat sandaran rollback. Dunia, runtime, mod, pustaka dan tetapan tempatan dikekalkan; kebergantungan hanya dibaiki jika hilang atau tidak sah.

> Pakej penuh dan checksum SHA-512 yang diterbitkan disahkan sebelum pemasangan.

<!-- jarock-auto-update-check -->

## Semakan kemas kini semasa mula

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Perlindungan penutupan konsol Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Taip stop dan tunggu SAFE TO CLOSE. Jangan paksa tutup semasa dunia disimpan. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
