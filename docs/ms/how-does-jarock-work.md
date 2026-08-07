# Bagaimanakah Jarock berfungsi?

## Penerangan mudah tentang pelayan

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Loader:** Fabric
**Platform utama:** Windows 10/11

Dokumen ini menerangkan perkara yang berlaku selepas Jarock dimuat turun.


> DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Nota penyelenggaraan:** pelancar kini mencari runtime Java 25+ 64-bit yang serasi dan bukannya hanya mempercayai `java.exe` pertama dalam `PATH`. Ia menggunakan `scripts/java-runtime.ps1`, menyimpan executable yang dipilih dalam `server/java-path.txt` dan mengesahkannya sebelum memulakan. Java 8 boleh kekal dipasang.

## 1. Ringkasan

Pengguna memasang Java 64-bit, memuat turun repository ini dan menjalankan `start-server.bat`. Program mencari foldernya sendiri, menyemak Java dan laluan, meminta sokongan Windows untuk laluan panjang jika perlu, memuat turun Fabric installer dan mods yang ditetapkan, kemudian mengesahkan setiap fail menggunakan SHA-512.

Fabric mencipta runtime dalam `server/`. Pelaksanaan pertama mencipta `server/eula.txt` dengan `eula=false` lalu berhenti. Pengguna perlu membaca <https://www.minecraft.net/eula>, menukarnya kepada `eula=true` jika bersetuju, kemudian menjalankan semula. Geyser menterjemah trafik Bedrock dan Floodgate mengurus pengesahan Bedrock.

Jarock **tidak** mengkonfigurasi router, firewall atau port forwarding.

## 2. Fail dan aliran

Repository mengandungi scripts, templat dan manifest, tetapi tidak mengandungi dunia atau fail `.jar` yang dijana:

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

Runtime dicipta dalam `server/`. Git mengabaikan dunia, logs, library, kunci peribadi dan senarai tempatan.

`start-server.bat` menggunakan lokasinya sendiri, bukan laluan tetap seperti `C:\MinecraftServer`, jadi laluan yang boleh diakses dengan ruang, Unicode, `!` dan folder bersarang disokong. Untuk laluan panjang, program menyemak:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

Jika perlu, ia meminta kebenaran pentadbir dan menjalankan `scripts\enable-long-paths.ps1`. Perubahan ini terpakai pada seluruh mesin dan aplikasi lama mungkin memerlukan Windows dimulakan semula.

## 3. EULA, Geyser dan ralat

Pelaksanaan pertama mencipta `server/eula.txt` dengan `eula=false` lalu berhenti. Baca EULA, tukar kepada `eula=true` jika bersetuju dan jalankan semula.

Geyser mencipta konfigurasi lengkap semasa pelancaran pelayan sebenar yang pertama. Selepas fail ini wujud:

```text
server\config\Geyser-Fabric\config.yml
```

skrip menetapkan:

```yaml
auth-type: floodgate
```

Java biasanya menggunakan TCP `25565`, manakala Bedrock menggunakan UDP `19132`. Jarock tidak membuka port. `key.pem` adalah rahsia dan tidak boleh diterbitkan.

Selepas ralat, baca `ERROR:` atau `WARNING:` dan ikuti `Suggested fix:`. Jika Java berhenti, cari `Caused by:` pertama dalam `server\logs\latest.log` atau `server\crash-reports\`. Tugasan yang tinggal terdapat dalam `TODO.md`.

> **Nota teknikal: Sentiasa gunakan `start-server.bat` di akar repositori. Jangan klik dua kali `server.jar`; Windows mungkin menggunakan Java 8 atau Java 21, sedangkan Minecraft 26.2 memerlukan Java 25+ 64-bit. Lihat [panduan bahasa Inggeris lengkap](../en/how-does-jarock-work.md).**
