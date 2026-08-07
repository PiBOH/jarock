# Primeira execução do Jarock

## Escolher o loader

Instale um JDK Java 25+ de 64 bits, ative JAVA_HOME no instalador Temurin e reabra o terminal. Use sempre o `start-server.bat` en `scripts/server-launch-settings.ini` da raiz e não abra diretamente `server/server.jar`.

## Instalação e EULA

Execute `start-server.bat` e escolha Fabric (recomendado), NeoForge (alternativa) ou Forge (atualmente indisponível para Minecraft 26.2). `parameter-manager.bat` configura RAM, GUI/consola, GC, `online-mode`, banner e `AUTO_UPDATE_CHECK`. **Exit without saving** cancela sem guardar.

## Paragem segura

O Jarock descarrega automaticamente o loader e os mods fixados. A primeira execução cria `server/eula.txt` e normalmente para. Leia a Minecraft EULA e altere `eula=false` para `eula=true` apenas se aceitar. Não use `online-mode=false` antes da primeira execução bem-sucedida.

## Paragem segura

Execute novamente, aguarde o mundo, Geyser e Floodgate, escreva `stop` e espere por `CLEAN SHUTDOWN COMPLETE` e `SAFE TO CLOSE`. Siga Suggested fix em caso de erro; se misturar loaders, faça uma cópia e execute `clean-server-runtime.bat`. Leia `TODO.md` antes do acesso público.

## Nota de segurança

Conclua a primeira execução com `online-mode=true` para usar a autenticação normal.

## Nota de segurança

Para instalar uma atualização, pare o servidor com segurança e execute `scripts/update-jarock.bat`.
