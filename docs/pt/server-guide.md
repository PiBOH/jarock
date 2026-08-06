# Guia do servidor Fabric

Instale Java 25 de 64 bits, execute `start-server.bat` e use `parameter-manager.bat` para RAM e GUI ou `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Leia `server/eula.txt`, aceite a EULA e defina `eula=true`; use Fabric, Geyser-Fabric e Floodgate-Fabric, faça cópias e lembre-se de que o Jarock não altera router, firewall ou port forwarding.

Consulte o guia completo em inglês: [../en/server-guide.md](../en/server-guide.md)


> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Nota técnica: Use sempre `start-server.bat` na raiz do repositório. Não clique duas vezes em `server.jar`; o Windows pode usar Java 8 ou Java 21, enquanto o Minecraft 26.2 exige Java 25+ de 64 bits. Consulte o [guia completo em inglês](../en/server-guide.md).**
