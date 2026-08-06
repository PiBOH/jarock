# Panduan rangkaian, firewall dan penghala

Pasang Java 25 64-bit, jalankan `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` dan selesaikan `TODO.md` sebelum membuka port. Tetapkan IP LAN tetap, buka TCP `25565` (Java) dan UDP `19132` (Bedrock) dalam Windows Firewall, konfigurasikan pemajuan port pada penghala atau gunakan terowong UDP seperti playit.gg. Pastikan `online-mode=true` dan `white-list=true` diaktifkan dan jangan sesekali menerbitkan `key.pem`. Untuk CGNAT, gunakan terowong. Lihat [panduan bahasa Inggeris](../en/network-and-ports.md).

> Sentiasa gunakan `start-server.bat`; jangan klik dua kali `server.jar`.
