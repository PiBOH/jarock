# Panduan jaringan, firewall, dan router

Instal Java 25 64-bit, jalankan `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` dan selesaikan `TODO.md` sebelum membuka port. Tetapkan IP LAN tetap, buka TCP `25565` (Java) dan UDP `19132` (Bedrock) di Windows Firewall, konfigurasikan penerusan port di router atau gunakan tunnel UDP seperti playit.gg. Pastikan `online-mode=true` dan `white-list=true` dan jangan pernah mempublikasikan `key.pem`. Untuk CGNAT, gunakan tunnel. Lihat [panduan bahasa Inggris](../en/network-and-ports.md).

> Selalu gunakan `start-server.bat`; jangan klik ganda `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Mematikan dengan aman

> Ketik `stop` dan biarkan jendela terbuka. Tunggu `CLEAN SHUTDOWN COMPLETE` lalu `SAFE TO CLOSE` sebelum menutupnya. Jika pesan kedua tidak muncul, periksa log dan laporan crash lalu pulihkan cadangan bila perlu.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Memperbarui Jarock

> Baca `scripts/version.txt`, hentikan server dan tunggu `SAFE TO CLOSE`; lalu jalankan `scripts/update-jarock.bat`. Program mencari rilis yang lebih baru di kanal beta/stabil yang sama, meminta konfirmasi, dan membuat cadangan rollback. Dunia, runtime, mod, pustaka, dan pengaturan lokal dipertahankan; dependensi hanya diperbaiki jika hilang atau tidak valid.

> Paket lengkap dan checksum SHA-512 yang dipublikasikan diverifikasi sebelum pemasangan.

<!-- jarock-auto-update-check -->

## Pemeriksaan pembaruan saat memulai

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Perlindungan penutupan konsol Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Ketik stop dan tunggu SAFE TO CLOSE. Jangan menutup paksa saat dunia disimpan. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
