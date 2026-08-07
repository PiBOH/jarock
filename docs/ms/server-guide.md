# Panduan pelayan Fabric

Pasang Java 25 64-bit, jalankan `start-server.bat` dan gunakan `parameter-manager.bat` untuk RAM serta GUI atau `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Baca `server/eula.txt`, terima EULA dan tetapkan `eula=true`; gunakan Fabric, Geyser-Fabric dan Floodgate-Fabric, buat sandaran, dan Jarock tidak mengubah router, firewall atau port forwarding.

Lihat panduan lengkap bahasa Inggeris: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Nota teknikal: Sentiasa gunakan `start-server.bat` di akar repositori. Jangan klik dua kali `server.jar`; Windows mungkin menggunakan Java 8 atau Java 21, sedangkan Minecraft 26.2 memerlukan Java 25+ 64-bit. Lihat [panduan bahasa Inggeris lengkap](../en/server-guide.md).**
