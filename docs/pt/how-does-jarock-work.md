# Como funciona o Jarock?

## Explicação simples do servidor

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Loader:** Fabric
**Plataforma principal:** Windows 10/11

Este documento explica o que acontece depois de baixar o Jarock.


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Nota de manutenção:** o iniciador agora procura um runtime Java 25+ compatível de 64 bits em vez de confiar apenas no primeiro `java.exe` do `PATH`. Usa `scripts/java-runtime.ps1`, guarda o executável selecionado em `server/java-path.txt` e valida-o antes de iniciar. O Java 8 pode continuar instalado.

## 1. Resumo

O usuário instala Java 64-bit, baixa ou clona o repositório e executa `start-server.bat`. O programa encontra a própria pasta, verifica Java e o caminho, solicita a ativação de caminhos longos do Windows quando necessário, baixa o instalador Fabric e os mods fixados e verifica cada arquivo com SHA-512.

O Fabric cria o runtime em `server/`. Na primeira execução, `server/eula.txt` é criado com `eula=false` e o processo para. O usuário deve ler <https://www.minecraft.net/eula>, alterar para `eula=true` se concordar e executar novamente. Geyser traduz o tráfego Bedrock e Floodgate cuida da autenticação Bedrock.

O Jarock **não** configura roteador, firewall ou port forwarding.

## 2. Arquivos

O repositório contém scripts, modelos e manifesto, mas não contém o mundo nem `.jar` gerados:

```text
start-server.bat
scripts/bootstrap-server.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
scripts/version.txt
CHANGELOG.md
TODO.md
```

O runtime é criado em `server/`. Mundos, logs, bibliotecas, chaves privadas e listas locais são ignorados pelo Git.

## 3. Inicialização

`start-server.bat` usa a própria localização, não um caminho fixo como `C:\MinecraftServer`. Assim, caminhos acessíveis com espaços, Unicode, `!` e subpastas são suportados.

Ele executa `scripts\bootstrap-server.ps1`, verifica `server/fabric-server-launch.jar` e `server/eula.txt`, executa `scripts\configure-geyser.ps1` e inicia:

```text
java -Xms4G -Xmx4G -jar fabric-server-launch.jar nogui
```

Se Java terminar com erro, consulte:

```text
server\logs\latest.log
server\crash-reports\
```

## 4. Bootstrap e mods

A raiz é calculada usando `$PSScriptRoot`. Para caminhos profundos, é verificado:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

Se o valor não for `1`, o Jarock solicita administrador e executa `scripts\enable-long-paths.ps1`. A alteração é global para a máquina e pode exigir reinicialização.

Depois são verificados `java -version`, `server\mods-manifest.ps1`, Fabric 26.2 com Loader `0.19.3`, os mods em `server\mods\` e todos os hashes SHA-512. Configurações locais existentes não são sobrescritas.

O conjunto padrão inclui Fabric API, Geyser-Fabric, Floodgate-Fabric, Lithium, FerriteCore, Krypton, ServerCore e Fabric Carpet. Plugins Bukkit/Spigot/Paper não são instalados.

## 5. Geyser, Floodgate e rede

Geyser cria sua configuração completa durante a primeira inicialização real. Quando existe:

```text
server\config\Geyser-Fabric\config.yml
```

o script define:

```yaml
auth-type: floodgate
```

Bedrock usa normalmente UDP `19132` e Java TCP `25565`. O Jarock documenta esses valores, mas não abre portas. `key.pem` é privado e nunca deve ser publicado.

## 6. Erros e limites

Depois de um erro, leia `ERROR:` ou `WARNING:` e siga `Suggested fix:`. Se Java fechar, procure o primeiro `Caused by:` nos logs. Causas comuns são Java ausente, permissões, download corrompido, EULA não aceita ou mod incompatível.

O Jarock não altera roteador, firewall, port forwarding ou IP público. O que ainda falta está em `TODO.md`. Drives indisponíveis, permissões negadas, compartilhamentos sem suporte e aplicativos antigos continuam sendo limitações do Windows.

> **Nota técnica: Use sempre `start-server.bat` na raiz do repositório. Não clique duas vezes em `server.jar`; o Windows pode usar Java 8 ou Java 21, enquanto o Minecraft 26.2 exige Java 25+ de 64 bits. Consulte o [guia completo em inglês](../en/how-does-jarock-work.md).**

<!-- jarock-safe-shutdown -->

## Encerramento seguro

> Digite `stop` e deixe a janela aberta. Antes de fechá-la, aguarde `CLEAN SHUTDOWN COMPLETE` e depois `SAFE TO CLOSE`. Se a segunda mensagem não aparecer, verifique o log e o relatório de falha e restaure um backup se necessário.

<!-- jarock-updater -->


## Atualizar o Jarock

> Leia `scripts/version.txt`, pare o servidor e aguarde `SAFE TO CLOSE`; depois execute `scripts/update-jarock.bat`. Ele procura uma versão mais recente no mesmo canal beta/estável, pede confirmação e cria um backup de reversão. Mundo, runtime, mods, bibliotecas e configurações locais são preservados; dependências só são corrigidas se estiverem ausentes ou inválidas.

> O pacote completo e o respetivo checksum SHA-512 publicado são verificados antes da instalação.

<!-- jarock-auto-update-check -->

## Verificação de atualizações na inicialização

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Proteção contra o fechamento do console do Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Digite stop e aguarde SAFE TO CLOSE. Nunca force o fechamento enquanto o mundo estiver sendo salvo. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
