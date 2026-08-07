# Como funciona Jarock?

## Explicación sinxela do servidor

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Cargador:** Fabric
**Plataforma principal:** Windows 10/11

Este documento explica que acontece despois de descargar Jarock.


> DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Nota de mantemento:** o lanzador agora busca un runtime Java 25+ compatible de 64 bits en vez de confiar só no primeiro `java.exe` de `PATH`. Usa `scripts/java-runtime.ps1`, garda o executable seleccionado en `server/java-path.txt` e valídao antes de iniciar. Java 8 pode permanecer instalado.

## 1. Resumo

A persoa usuaria instala Java de 64 bits, descarga este repository e executa `start-server.bat`. O programa atopa o seu propio cartafol, comproba Java e a ruta, solicita activar as rutas longas de Windows cando é necesario, descarga Fabric e os mods fixados e verifica cada ficheiro con SHA-512.

Fabric crea o runtime en `server/`. A primeira execución crea `server/eula.txt` con `eula=false` e detense. Cómpre ler <https://www.minecraft.net/eula>, cambiar a `eula=true` se se acepta e executar de novo. Geyser traduce o tráfico Bedrock e Floodgate xestiona a autenticación Bedrock.

Jarock **non** configura o router, o firewall nin o port forwarding.

## 2. Ficheiros e funcionamento

O repository contén scripts, modelos e un manifest, pero non contén o mundo nin os `.jar` xerados:

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

O runtime créase en `server/`. Git ignora mundos, logs, bibliotecas, chaves privadas e listas locais.

`start-server.bat` usa a súa propia localización e non unha ruta fixa como `C:\MinecraftServer`. Admite rutas accesibles con espazos, Unicode, `!` e cartafoles aniñados. Para rutas longas comproba:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

Se é necesario, solicita permisos de administrador e executa `scripts\enable-long-paths.ps1`. O cambio é global e pode requirir reiniciar Windows.

## 3. EULA, Geyser e erros

A primeira execución crea `server/eula.txt` con `eula=false` e detense. Hai que ler a EULA, cambiar a `eula=true` se se acepta e volver executar.

Geyser xera a súa configuración completa durante o primeiro inicio real. Despois, en:

```text
server\config\Geyser-Fabric\config.yml
```

o script establece:

```yaml
auth-type: floodgate
```

Java adoita usar TCP `25565` e Bedrock UDP `19132`. Jarock non abre portos. `key.pem` é privado e nunca se debe publicar.

Despois dun erro, le `ERROR:` ou `WARNING:` e segue `Suggested fix:`. Se Java se pecha, busca o primeiro `Caused by:` en `server\logs\latest.log` ou `server\crash-reports\`. As tarefas restantes están en `TODO.md`.

> **Nota técnica: Usa sempre o `start-server.bat` da raíz do repositorio. Non fagas dobre clic en `server.jar`; Windows pode usar Java 8 ou Java 21, mentres que Minecraft 26.2 require Java 25+ de 64 bits. Consulta a [guía completa en inglés](../en/how-does-jarock-work.md).**

<!-- jarock-safe-shutdown -->

## Apagado seguro

> Escribe `stop` e deixa a xanela aberta. Agarda por `CLEAN SHUTDOWN COMPLETE` e despois `SAFE TO CLOSE` antes de pechala. Se falta a segunda mensaxe, revisa o rexistro e o informe de fallo e restaura unha copia se é preciso.

<!-- jarock-updater -->


## Actualizar Jarock

> Le `scripts/version.txt`, detén o servidor e agarda por `SAFE TO CLOSE`; despois executa `scripts/update-jarock.bat`. Busca unha versión máis nova da mesma canle beta/estable, pide confirmación e crea unha copia de recuperación. Conserva o mundo, runtime, mods, bibliotecas e configuración local; só repara dependencias ausentes ou inválidas.

> O paquete completo e a súa suma de comprobación SHA-512 publicada verifícanse antes da instalación.

<!-- jarock-auto-update-check -->

## Comprobación de actualizacións ao iniciar

Establece AUTO_UPDATE_CHECK=true en parameter-manager.bat para que start-server.bat comprobe GitHub en modo de só lectura. Informará dunha versión compatible máis recente, pero non instalará nada automaticamente. Detén o servidor, agarda por SAFE TO CLOSE e executa scripts/update-jarock.bat. O valor predeterminado é AUTO_UPDATE_CHECK=false.
