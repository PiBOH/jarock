# Ghid de rețea, firewall și router

Instalați Java 25 pe 64 de biți, rulați `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` și finalizați `TODO.md` înainte de a deschide porturile. Atribuiți un IP LAN fix, deschideți TCP `25565` (Java) și UDP `19132` (Bedrock) în firewall-ul Windows, configurați redirecționarea porturilor pe router sau folosiți un tunel UDP ca playit.gg. Asigurați-vă că `online-mode=true` și `white-list=true` sunt activate și nu publicați niciodată `key.pem`. Pentru CGNAT, folosiți un tunel. Consultați [ghidul canonic în engleză](../en/network-and-ports.md).

> Folosiți întotdeauna `start-server.bat`; nu faceți dublu clic pe `server.jar`.
