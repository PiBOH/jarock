# Guia do servidor Fabric

Instale Java 25 de 64 bits, execute `start-server.bat` e use `parameter-manager.bat` para RAM e GUI ou `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Leia `server/eula.txt`, aceite a EULA e defina `eula=true`; use Fabric, Geyser-Fabric e Floodgate-Fabric, faça cópias e lembre-se de que o Jarock não altera router, firewall ou port forwarding.

Consulte o guia completo em inglês: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Nota técnica: Use sempre `start-server.bat` na raiz do repositório. Não clique duas vezes em `server.jar`; o Windows pode usar Java 8 ou Java 21, enquanto o Minecraft 26.2 exige Java 25+ de 64 bits. Consulte o [guia completo em inglês](../en/server-guide.md).**

<!-- jarock-safe-shutdown -->

## Encerramento seguro

> Digite `stop` e deixe a janela aberta. Antes de fechá-la, aguarde `CLEAN SHUTDOWN COMPLETE` e depois `SAFE TO CLOSE`. Se a segunda mensagem não aparecer, verifique o log e o relatório de falha e restaure um backup se necessário.

<!-- jarock-updater -->


## Atualizar o Jarock

> Leia `version.txt`, pare o servidor e aguarde `SAFE TO CLOSE`; depois execute `update-jarock.bat`. Ele procura uma versão mais recente no mesmo canal beta/estável, pede confirmação e cria um backup de reversão. Mundo, runtime, mods, bibliotecas e configurações locais são preservados; dependências só são corrigidas se estiverem ausentes ou inválidas.

> O pacote completo e o respetivo checksum SHA-512 publicado são verificados antes da instalação.

<!-- jarock-auto-update-check -->

## Verificação de atualizações na inicialização

Defina AUTO_UPDATE_CHECK=true em parameter-manager.bat para que start-server.bat verifique o GitHub somente para leitura. Uma versão compatível mais recente será indicada, mas nada será instalado automaticamente. Pare o servidor, aguarde SAFE TO CLOSE e execute update-jarock.bat. O valor padrão é AUTO_UPDATE_CHECK=false.
