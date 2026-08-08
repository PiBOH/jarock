# Panduan server Fabric

Pasang Java 25 64-bit, jalankan `start-server.bat`, dan gunakan `parameter-manager.bat` untuk RAM serta GUI atau `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Baca `server/eula.txt`, terima EULA lalu tetapkan `eula=true`; gunakan Fabric, Geyser-Fabric dan Floodgate-Fabric, buat backup, dan Jarock tidak mengubah router, firewall atau port forwarding.

Baca panduan lengkap bahasa Inggris: [../en/server-guide.md](../en/server-guide.md)


Jarock never moves, renames, deletes or replaces an existing world automatically. If Minecraft reports a world-integrity or generation error, stop safely, inspect the logs and crash report, and restore the world from a known-good backup. A fresh world is generated only after you deliberately delete the existing `world`, `world_nether` and `world_the_end` folders yourself. If only some of `world`, `world_nether` and `world_the_end` exist, Jarock refuses to start to prevent mixing old and new dimensions; restore all three from a backup or deliberately delete all three to create a new world. Java stores the Nether and End inside the configured `level-name` folder as `DIM-1` and `DIM1`. If that configured folder exists, Jarock leaves it untouched and lets Minecraft load it or report its integrity error. A new world is possible only when the configured folder is absent and no other possible old world folder remains; after a `level-name` change, Jarock refuses to start instead of silently replacing an existing world.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Show ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> Technical fallback note: Links In Chat is included in the pinned Fabric 26.2 server stack. It makes URLs in server chat clickable and adds `/link` and `/linkwhisper`; clients do not need to install it. Welcome AWA is also included as a verified server-side Fabric 26.2 mod; it sends configurable colored join messages using `%player%` and supports `welcome reload`.
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Catatan teknis: Selalu gunakan `start-server.bat` di root repository. Jangan klik ganda `server.jar`; Windows mungkin menggunakan Java 8 atau Java 21, sedangkan Minecraft 26.2 memerlukan Java 25+ 64-bit. Lihat [panduan bahasa Inggris lengkap](../en/server-guide.md).**



<!-- jarock-lan-addresses-id -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

<!-- jarock-safe-shutdown -->

## Mematikan dengan aman

> Ketik `stop` dan biarkan jendela terbuka. Tunggu `CLEAN SHUTDOWN COMPLETE` lalu `SAFE TO CLOSE` sebelum menutupnya. Jika pesan kedua tidak muncul, periksa log dan laporan crash lalu pulihkan cadangan bila perlu.

<!-- jarock-updater -->


## Memperbarui Jarock

> Baca `scripts/version.txt`, hentikan server dan tunggu `SAFE TO CLOSE`; lalu jalankan `scripts/update-jarock.bat`. Program mencari rilis yang lebih baru di kanal beta/stabil yang sama, meminta konfirmasi, dan membuat cadangan rollback. Dunia, runtime, mod, pustaka, dan pengaturan lokal dipertahankan; dependensi hanya diperbaiki jika hilang atau tidak valid.

> Paket lengkap dan checksum SHA-512 yang dipublikasikan diverifikasi sebelum pemasangan.

<!-- jarock-auto-update-check -->

## Pemeriksaan pembaruan saat memulai

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Perlindungan penutupan konsol Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Ketik stop dan tunggu SAFE TO CLOSE. Jangan menutup paksa saat dunia disimpan. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
