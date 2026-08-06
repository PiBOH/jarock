# Ghid pentru server Fabric

Instalați Java 25 pe 64 de biți, rulați `start-server.bat` și folosiți `parameter-manager.bat` pentru RAM și GUI sau `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Citiți `server/eula.txt`, acceptați EULA și setați `eula=true`; folosiți Fabric, Geyser-Fabric și Floodgate-Fabric, faceți backup, iar Jarock nu modifică routerul, firewall-ul sau port forwarding.

Consultați ghidul complet în engleză: [../en/server-guide.md](../en/server-guide.md)


> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Notă tehnică: Folosiți întotdeauna `start-server.bat` din rădăcina repository-ului. Nu faceți dublu clic pe `server.jar`; Windows poate folosi Java 8 sau Java 21, în timp ce Minecraft 26.2 necesită Java 25+ pe 64 de biți. Consultați [ghidul complet în engleză](../en/server-guide.md).**
