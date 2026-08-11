# Bagaimana Jarock bekerja?

## Penjelasan sederhana tentang server

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Loader:** Fabric
**Platform utama:** Windows 10/11

Dokumen ini menjelaskan apa yang terjadi setelah Jarock diunduh.


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome Message 2.8 with its required Collective library is included as a verified server-side Minecraft 26.2 mod for Fabric and NeoForge; it sends configurable join messages.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Catatan pemeliharaan:** Peluncur sekarang mencari runtime Java 25+ 64-bit yang kompatibel, bukan hanya mempercayai `java.exe` pertama di `PATH`. Peluncur menggunakan `scripts/java-runtime.ps1`, menyimpan executable yang dipilih di `server/java-path.txt`, dan memvalidasinya sebelum memulai. Java 8 boleh tetap terpasang.

## 1. Ringkasan

Pengguna memasang Java 64-bit, mengunduh repository ini, lalu menjalankan `start-server.bat`. Program menemukan foldernya sendiri, memeriksa Java dan path, meminta dukungan Windows untuk long path jika diperlukan, mengunduh installer Fabric dan mods yang telah dipatok, lalu memeriksa setiap file dengan SHA-512.

Fabric membuat runtime di `server/`. Pada proses pertama, `server/eula.txt` dibuat dengan `eula=false` lalu proses berhenti. Pengguna harus membaca <https://www.minecraft.net/eula>, mengubahnya menjadi `eula=true` jika setuju, lalu menjalankan kembali. Geyser menerjemahkan lalu lintas Bedrock dan Floodgate menangani autentikasi Bedrock.

Jarock **tidak** mengatur router, firewall, atau port forwarding.

## 2. File dan alur

Repository berisi scripts, template, dan manifest, tetapi tidak berisi dunia atau file `.jar` yang dihasilkan:

```text
start-server.bat
scripts/bootstrap-server.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
scripts/version.txt
CHANGELOG.md
TODO.md
```

Runtime dibuat di `server/`. Git mengabaikan world, log, library, private key, dan daftar lokal.

`start-server.bat` menggunakan lokasinya sendiri, bukan path tetap seperti `C:\MinecraftServer`, sehingga mendukung path yang dapat diakses dengan spasi, Unicode, `!`, dan folder bertingkat. Untuk path panjang, program memeriksa:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

Jika diperlukan, program meminta izin administrator dan menjalankan `scripts\enable-long-paths.ps1`. Perubahan ini berlaku untuk seluruh komputer dan aplikasi lama mungkin memerlukan restart Windows.

## 3. EULA, Geyser, dan kesalahan

Proses pertama membuat `server/eula.txt` dengan `eula=false` lalu berhenti. Baca EULA, ubah menjadi `eula=true` jika setuju, lalu jalankan lagi.

Geyser membuat konfigurasi lengkap saat server benar-benar pertama kali dijalankan. Setelah file ini ada:

```text
server\config\Geyser-Fabric\config.yml
```

script menetapkan:

```yaml
auth-type: floodgate
```

Java biasanya menggunakan TCP `25565`, sedangkan Bedrock menggunakan UDP `19132`. Jarock tidak membuka port. `key.pem` bersifat rahasia dan tidak boleh dipublikasikan.

Setelah kesalahan, baca `ERROR:` atau `WARNING:` dan ikuti `Suggested fix:`. Jika Java berhenti, cari `Caused by:` pertama di `server\logs\latest.log` atau `server\crash-reports\`. Tugas yang tersisa ada di `TODO.md`.

> **Catatan teknis: Selalu gunakan `start-server.bat` di root repository. Jangan klik ganda `server.jar`; Windows mungkin menggunakan Java 8 atau Java 21, sedangkan Minecraft 26.2 memerlukan Java 25+ 64-bit. Lihat [panduan bahasa Inggris lengkap](../en/how-does-jarock-work.md).**

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> InvView 1.4.21 is a verified Minecraft 26.2 server-side Fabric mod. It requires Fabric API and lets authorized operators inspect and manage online or offline player inventories and ender chests; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> OfflineCommands 1.0.3 is a verified Minecraft 26.2 server-side Fabric mod for running commands on offline players. No compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

<!-- jarock-safe-shutdown -->

## Mematikan dengan aman

> Ketik `stop` dan biarkan jendela terbuka. Tunggu `CLEAN SHUTDOWN COMPLETE` lalu `SAFE TO CLOSE` sebelum menutupnya. Jika pesan kedua tidak muncul, periksa log dan laporan crash lalu pulihkan cadangan bila perlu.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Memperbarui Jarock

> Baca `scripts/version.txt`, hentikan server dan tunggu `SAFE TO CLOSE`; lalu jalankan `scripts/update-jarock.bat`. Program mencari rilis yang lebih baru di kanal beta/stabil yang sama, meminta konfirmasi, dan membuat cadangan rollback. Dunia, runtime, mod, pustaka, dan pengaturan lokal dipertahankan; dependensi hanya diperbaiki jika hilang atau tidak valid.

> Paket lengkap dan checksum SHA-512 yang dipublikasikan diverifikasi sebelum pemasangan.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Pemeriksaan pembaruan saat memulai

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified package matching scripts/jarock-edition.ini automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Perlindungan penutupan konsol Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Ketik stop dan tunggu SAFE TO CLOSE. Jangan menutup paksa saat dunia disimpan. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
