# Guía de red, firewall y router

Instala Java 25 de 64 bits, ejecuta `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` y completa `TODO.md` antes de abrir puertos. Asigna una IP LAN fija, abre TCP `25565` (Java) y UDP `19132` (Bedrock) en el firewall de Windows, configura el reenvío de puertos en el router o usa un túnel UDP como playit.gg. Comprueba que `online-mode=true` y `white-list=true`, y nunca publiques `key.pem`. Si tienes CGNAT, usa un túnel. Consulta la [guía canónica en inglés](../en/network-and-ports.md).

> Usa siempre `start-server.bat`; no hagas doble clic en `server.jar`.
