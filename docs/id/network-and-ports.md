# Panduan jaringan, firewall, dan router

Instal Java 25 64-bit, jalankan `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` dan selesaikan `TODO.md` sebelum membuka port. Tetapkan IP LAN tetap, buka TCP `25565` (Java) dan UDP `19132` (Bedrock) di Windows Firewall, konfigurasikan penerusan port di router atau gunakan tunnel UDP seperti playit.gg. Pastikan `online-mode=true` dan `white-list=true` dan jangan pernah mempublikasikan `key.pem`. Untuk CGNAT, gunakan tunnel. Lihat [panduan bahasa Inggris](../en/network-and-ports.md).

> Selalu gunakan `start-server.bat`; jangan klik ganda `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.
