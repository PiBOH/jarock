# Bagaimana Jarock bekerja?

## Penjelasan sederhana tentang server

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Loader:** Fabric
**Platform utama:** Windows 10/11

Dokumen ini menjelaskan apa yang terjadi setelah Jarock diunduh.


> DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512.

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
scripts/bootstrap-fabric.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
version.txt
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

<!-- jarock-safe-shutdown -->

## Mematikan dengan aman

> Ketik `stop` dan biarkan jendela terbuka. Tunggu `CLEAN SHUTDOWN COMPLETE` lalu `SAFE TO CLOSE` sebelum menutupnya. Jika pesan kedua tidak muncul, periksa log dan laporan crash lalu pulihkan cadangan bila perlu.

<!-- jarock-updater -->


## Memperbarui Jarock

> Baca `version.txt`, hentikan server dan tunggu `SAFE TO CLOSE`; lalu jalankan `update-jarock.bat`. Program mencari rilis yang lebih baru di kanal beta/stabil yang sama, meminta konfirmasi, dan membuat cadangan rollback. Dunia, runtime, mod, pustaka, dan pengaturan lokal dipertahankan; dependensi hanya diperbaiki jika hilang atau tidak valid.

> Paket lengkap dan checksum SHA-512 yang dipublikasikan diverifikasi sebelum pemasangan.
