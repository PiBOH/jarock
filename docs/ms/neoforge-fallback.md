# Panduan sandaran NeoForge

Gunakan NeoForge hanya sebagai pilihan terakhir apabila Fabric tidak sesuai. Forge dan NeoForge ialah loader berlainan dan mod mesti sepadan dengan NeoForge; tambah Geyser/Floodgate jika perlu dan uji salinan dahulu.

Lihat panduan lengkap bahasa Inggeris: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## Penutupan selamat

> Taip `stop` dan biarkan tetingkap terbuka. Tunggu `CLEAN SHUTDOWN COMPLETE` kemudian `SAFE TO CLOSE` sebelum menutupnya. Jika mesej kedua tiada, semak log dan laporan ranap dan pulihkan sandaran jika perlu.

<!-- jarock-updater -->


## Kemas kini Jarock

> Baca `scripts/version.txt`, hentikan pelayan dan tunggu `SAFE TO CLOSE`; kemudian jalankan `scripts/update-jarock.bat`. Ia mencari keluaran lebih baharu dalam saluran beta/stabil yang sama, meminta pengesahan dan membuat sandaran rollback. Dunia, runtime, mod, pustaka dan tetapan tempatan dikekalkan; kebergantungan hanya dibaiki jika hilang atau tidak sah.

> Pakej penuh dan checksum SHA-512 yang diterbitkan disahkan sebelum pemasangan.

<!-- jarock-auto-update-check -->

## Semakan kemas kini semasa mula

Tetapkan AUTO_UPDATE_CHECK=true dalam parameter-manager.bat supaya start-server.bat menjalankan semakan GitHub baca sahaja. Versi Jarock serasi yang lebih baharu akan dilaporkan, tetapi tiada pemasangan automatik. Hentikan pelayan, tunggu SAFE TO CLOSE dan jalankan scripts/update-jarock.bat. Nilai lalai ialah AUTO_UPDATE_CHECK=false. When a compatible newer release is found at startup, Jarock asks `Download and install it now? (y/N)`; choose y to install the verified Lite package, or N/Enter to continue with the current version. It never updates silently.
