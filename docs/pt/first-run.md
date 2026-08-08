# Primeira execução do Jarock

## Escolher o loader

Instale um JDK Java 25+ de 64 bits, ative JAVA_HOME no instalador Temurin e reabra o terminal. Use sempre o `start-server.bat` en `scripts/server-launch-settings.ini` da raiz e não abra diretamente `server/server.jar`.

## Instalação e EULA

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## Paragem segura

O Jarock descarrega automaticamente o loader e os mods fixados. A primeira execução cria `server/eula.txt` e normalmente para. Leia a Minecraft EULA e altere `eula=false` para `eula=true` apenas se aceitar. Não use `online-mode=false` antes da primeira execução bem-sucedida.

## Paragem segura

Execute novamente, aguarde o mundo, Geyser e Floodgate, escreva `stop` e espere por `CLEAN SHUTDOWN COMPLETE` e `SAFE TO CLOSE`. Siga Suggested fix em caso de erro; se misturar loaders, faça uma cópia e execute `clean-server-runtime.bat`. Leia `TODO.md` antes do acesso público.

## Nota de segurança

Conclua a primeira execução com `online-mode=true` para usar a autenticação normal.

## Nota de segurança

Para instalar uma atualização, pare o servidor com segurança e execute `scripts/update-jarock.bat`.

<!-- jarock-lan-addresses-pt -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Proteção contra o fechamento do console do Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Digite stop e aguarde SAFE TO CLOSE. Nunca force o fechamento enquanto o mundo estiver sendo salvo. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
