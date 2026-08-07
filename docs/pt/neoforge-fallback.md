# Guia de fallback NeoForge

Use NeoForge apenas como último recurso se Fabric não servir. Forge e NeoForge são loaders diferentes e os mods devem corresponder a NeoForge; adicione Geyser/Floodgate se necessário e teste primeiro uma cópia.

Consulte o guia completo em inglês: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## Encerramento seguro

> Digite `stop` e deixe a janela aberta. Antes de fechá-la, aguarde `CLEAN SHUTDOWN COMPLETE` e depois `SAFE TO CLOSE`. Se a segunda mensagem não aparecer, verifique o log e o relatório de falha e restaure um backup se necessário.

<!-- jarock-updater -->


## Atualizar o Jarock

> Leia `scripts/version.txt`, pare o servidor e aguarde `SAFE TO CLOSE`; depois execute `scripts/update-jarock.bat`. Ele procura uma versão mais recente no mesmo canal beta/estável, pede confirmação e cria um backup de reversão. Mundo, runtime, mods, bibliotecas e configurações locais são preservados; dependências só são corrigidas se estiverem ausentes ou inválidas.

> O pacote completo e o respetivo checksum SHA-512 publicado são verificados antes da instalação.

<!-- jarock-auto-update-check -->

## Verificação de atualizações na inicialização

Defina AUTO_UPDATE_CHECK=true em parameter-manager.bat para que start-server.bat verifique o GitHub somente para leitura. Uma versão compatível mais recente será indicada, mas nada será instalado automaticamente. Pare o servidor, aguarde SAFE TO CLOSE e execute scripts/update-jarock.bat. O valor padrão é AUTO_UPDATE_CHECK=false.
