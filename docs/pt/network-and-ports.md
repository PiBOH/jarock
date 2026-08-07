# Guia de rede, firewall e router

Instale Java 25 64-bit, execute `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` e conclua `TODO.md` antes de abrir portas. Atribua um IP LAN fixo, abra TCP `25565` (Java) e UDP `19132` (Bedrock) no firewall do Windows, configure o encaminhamento de portas no router ou utilize um túnel UDP como playit.gg. Verifique `online-mode=true` e `white-list=true` e nunca publique `key.pem`. Para CGNAT, utilize um túnel. Consulte o [guia canónico em inglês](../en/network-and-ports.md).

> Utilize sempre `start-server.bat`; não faça duplo clique em `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

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
