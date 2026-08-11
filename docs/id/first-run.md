> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

# Penggunaan pertama Jarock

## Memilih loader

Pasang JDK Java 25+ 64-bit, aktifkan JAVA_HOME di installer Temurin, lalu buka kembali terminal. Selalu jalankan `start-server.bat` en `scripts/server-launch-settings.ini` di root dan jangan membuka `server/server.jar` secara langsung.

## Instalasi dan EULA

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## Mematikan dengan aman

Jarock mengunduh loader dan mod yang dipatok secara otomatis. Proses pertama membuat `server/eula.txt` lalu biasanya berhenti. Baca Minecraft EULA dan ubah `eula=false` menjadi `eula=true` hanya jika setuju. Jangan memakai `online-mode=false` sebelum proses pertama berhasil.

## Mematikan dengan aman

Jalankan lagi, tunggu world, Geyser, dan Floodgate selesai, ketik `stop`, lalu tunggu `CLEAN SHUTDOWN COMPLETE` dan `SAFE TO CLOSE`. Ikuti Suggested fix jika gagal; bila loader tercampur, buat cadangan dan jalankan `clean-server-runtime.bat`. Baca `TODO.md` sebelum akses publik.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## Catatan keamanan

Selesaikan proses pertama dengan `online-mode=true` agar autentikasi normal berfungsi.

## Catatan keamanan

Untuk memasang pembaruan, hentikan server dengan aman lalu jalankan `scripts/update-jarock.bat`.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-id -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Perlindungan penutupan konsol Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Ketik stop dan tunggu SAFE TO CLOSE. Jangan menutup paksa saat dunia disimpan. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
