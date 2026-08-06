# Guida a rete, firewall e router

Installa Java 25 a 64 bit, esegui `start-server.bat` e completa `TODO.md` prima di aprire le porte. Assegna un IP LAN statico, apri TCP `25565` (Java) e UDP `19132` (Bedrock) nel firewall di Windows, configura il port forwarding sul router oppure usa un tunnel compatibile UDP come playit.gg. Assicurati che `online-mode=true` e `white-list=true` siano attivi e non pubblicare mai `key.pem`. In caso di CGNAT, usa un tunnel. Vedi la [guida canonica in inglese](../en/network-and-ports.md).

> Usa sempre `start-server.bat`; non fare doppio clic su `server.jar`.
