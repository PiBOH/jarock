# Panduan cadangan NeoForge

Gunakan NeoForge hanya sebagai pilihan terakhir jika Fabric tidak sesuai. Forge dan NeoForge adalah loader berbeda dan mod harus cocok dengan NeoForge; tambahkan Geyser/Floodgate bila perlu dan uji salinan terlebih dahulu.

Baca panduan lengkap bahasa Inggris: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## Mematikan dengan aman

> Ketik `stop` dan biarkan jendela terbuka. Tunggu `CLEAN SHUTDOWN COMPLETE` lalu `SAFE TO CLOSE` sebelum menutupnya. Jika pesan kedua tidak muncul, periksa log dan laporan crash lalu pulihkan cadangan bila perlu.

<!-- jarock-updater -->


## Memperbarui Jarock

> Baca `version.txt`, hentikan server dan tunggu `SAFE TO CLOSE`; lalu jalankan `update-jarock.bat`. Program mencari rilis yang lebih baru di kanal beta/stabil yang sama, meminta konfirmasi, dan membuat cadangan rollback. Dunia, runtime, mod, pustaka, dan pengaturan lokal dipertahankan; dependensi hanya diperbaiki jika hilang atau tidak valid.

> Paket lengkap dan checksum SHA-512 yang dipublikasikan diverifikasi sebelum pemasangan.

<!-- jarock-auto-update-check -->

## Pemeriksaan pembaruan saat memulai

Atur AUTO_UPDATE_CHECK=true di parameter-manager.bat agar start-server.bat memeriksa rilis GitHub hanya-baca. Versi Jarock yang lebih baru dan kompatibel akan dilaporkan, tetapi tidak dipasang otomatis. Hentikan server dengan aman, tunggu SAFE TO CLOSE, lalu jalankan update-jarock.bat. Nilai bawaan AUTO_UPDATE_CHECK=false.
