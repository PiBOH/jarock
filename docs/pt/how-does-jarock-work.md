# Como funciona o Jarock?

## Explicação simples do servidor

**Versão atual:** `0.0.2-alpha`  
**Minecraft:** Java Edition `26.2`  
**Loader:** Fabric  
**Plataforma principal:** Windows 10/11

Este documento explica o que acontece depois de baixar o Jarock.

## 1. Resumo

O usuário instala Java 64-bit, baixa ou clona o repositório e executa `start-server.bat`. O programa encontra a própria pasta, verifica Java e o caminho, solicita a ativação de caminhos longos do Windows quando necessário, baixa o instalador Fabric e os mods fixados e verifica cada arquivo com SHA-512.

O Fabric cria o runtime em `server/`. Na primeira execução, `server/eula.txt` é criado com `eula=false` e o processo para. O usuário deve ler <https://www.minecraft.net/eula>, alterar para `eula=true` se concordar e executar novamente. Geyser traduz o tráfego Bedrock e Floodgate cuida da autenticação Bedrock.

O Jarock **não** configura roteador, firewall ou port forwarding.

## 2. Arquivos

O repositório contém scripts, modelos e manifesto, mas não contém o mundo nem `.jar` gerados:

```text
start-server.bat
scripts/bootstrap-fabric.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
version.txt
CHANGELOG.md
TODO.md
```

O runtime é criado em `server/`. Mundos, logs, bibliotecas, chaves privadas e listas locais são ignorados pelo Git.

## 3. Inicialização

`start-server.bat` usa a própria localização, não um caminho fixo como `C:\MinecraftServer`. Assim, caminhos acessíveis com espaços, Unicode, `!` e subpastas são suportados.

Ele executa `scripts\bootstrap-fabric.ps1`, verifica `server/fabric-server-launch.jar` e `server/eula.txt`, executa `scripts\configure-geyser.ps1` e inicia:

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
