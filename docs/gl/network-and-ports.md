# Guía de rede, firewall e router

Instala Java 25 de 64 bits, executa `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` e completa `TODO.md` antes de abrir portos. Asigna un IP LAN fixo, abre TCP `25565` (Java) e UDP `19132` (Bedrock) no firewall de Windows, configura o reenvío de portos no router ou usa un túnel UDP como playit.gg. Comproba `online-mode=true` e `white-list=true` e nunca publiques `key.pem`. Para CGNAT, usa un túnel. Consulta a [guía canónica en inglés](../en/network-and-ports.md).

> Usa sempre `start-server.bat`; non fagas dobre clic en `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.
