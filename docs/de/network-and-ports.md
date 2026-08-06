# Netzwerk-, Firewall- und Router-Konfiguration

Installieren Sie 64-Bit-Java 25, führen Sie `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` aus und schließen Sie `TODO.md` ab, bevor Sie Ports öffnen. Vergeben Sie eine feste LAN-IP, öffnen Sie TCP `25565` (Java) und UDP `19132` (Bedrock) in der Windows-Firewall, konfigurieren Sie die Portweiterleitung im Router oder verwenden Sie einen UDP-fähigen Tunnel wie playit.gg. Stellen Sie sicher, dass `online-mode=true` und `white-list=true` aktiviert sind und `key.pem` niemals veröffentlicht wird. Bei CGNAT einen Tunnel verwenden. Siehe [kanonische englische Anleitung](../en/network-and-ports.md).

> Verwenden Sie immer `start-server.bat`; starten Sie `server.jar` nicht per Doppelklick.
