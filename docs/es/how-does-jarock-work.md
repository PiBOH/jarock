# ¿Cómo funciona Jarock?

## Explicación sencilla del servidor

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Cargador:** Fabric
**Plataforma principal:** Windows 10/11

Este documento explica qué ocurre después de descargar Jarock.


> DedicatedPower is updated automatically from its latest GitHub release; the other server mods are pinned and verified with SHA-512.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Nota de mantenimiento:** el lanzador ahora busca un runtime Java 25+ compatible de 64 bits en lugar de confiar solo en el primer `java.exe` de `PATH`. Usa `scripts/java-runtime.ps1`, guarda el ejecutable seleccionado en `server/java-path.txt` y lo valida antes de iniciar. Java 8 puede permanecer instalado.

## 1. Resumen

El usuario debe instalar Java de 64 bits, descargar o clonar el repositorio y ejecutar `start-server.bat`. El programa encuentra su propia carpeta, comprueba Java y la ruta, habilita los permisos de rutas largas si hace falta, descarga el instalador Fabric y las mods fijadas, y verifica cada archivo con SHA-512.

Fabric crea el runtime en `server/`. La primera ejecución crea `server/eula.txt` con `eula=false` y se detiene. El usuario debe leer <https://www.minecraft.net/eula>, cambiarlo a `eula=true` si acepta y ejecutar de nuevo. Después Fabric se inicia; Geyser traduce el tráfico Bedrock y Floodgate gestiona su autenticación.

Jarock **no** configura el router, el firewall ni el port forwarding.

## 2. Archivos y carpetas

El repositorio contiene scripts, plantillas y un manifiesto, no el mundo ni los `.jar` generados:

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

El runtime se crea en `server/`. Mundos, logs, librerías, claves privadas y listas locales están ignorados por Git.

## 3. El flujo de arranque

`start-server.bat` calcula su ubicación y no utiliza una carpeta fija como `C:\MinecraftServer`. Por eso funciona con espacios, Unicode, `!` y carpetas anidadas accesibles.

Ejecuta `scripts\bootstrap-fabric.ps1`, comprueba `server/fabric-server-launch.jar`, verifica que `server/eula.txt` contiene exactamente `eula=true`, ejecuta `scripts\configure-geyser.ps1` y lanza:

```text
java -Xms4G -Xmx4G -jar fabric-server-launch.jar nogui
```

Si Java termina con error, revisa:

```text
server\logs\latest.log
server\crash-reports\
```

## 4. El bootstrap

La raíz se calcula con `$PSScriptRoot`. Para rutas profundas se consulta:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

Si no vale `1`, Jarock pide permisos de administrador y ejecuta `scripts\enable-long-paths.ps1`. El cambio es global para Windows y puede requerir reiniciar.

Después comprueba `java -version`, carga `server\mods-manifest.ps1`, instala Fabric 26.2 con Loader `0.19.3`, descarga las mods en `server\mods\` y verifica todos los hashes SHA-512. No sobrescribe configuraciones locales existentes.

El conjunto incluye Fabric API, Geyser-Fabric, Floodgate-Fabric, Lithium, FerriteCore, Krypton, ServerCore y Fabric Carpet. No instala plugins Bukkit/Spigot/Paper.

## 5. Geyser, Floodgate y red

Geyser crea su configuración completa durante el primer arranque real. Después, cuando existe:

```text
server\config\Geyser-Fabric\config.yml
```

el script establece:

```yaml
auth-type: floodgate
```

La conexión Bedrock usa normalmente UDP `19132` y Java TCP `25565`. Jarock no abre ni reenvía esos puertos. `key.pem` es secreto y nunca debe publicarse.

## 6. Mods y errores

Lithium optimiza la lógica, FerriteCore la memoria, Krypton la red, ServerCore el rendimiento y Carpet las herramientas técnicas/redstone. Sodium, Litematica, MiniHUD y Tweakeroo son normalmente mods del cliente y no deben copiarse a `server/mods/`.

Después de cualquier error, lee `ERROR:` o `WARNING:` y sigue `Suggested fix:`. Si Java se cierra, busca el primer `Caused by:` en los logs. Las causas comunes son Java ausente, permisos, descargas corruptas, EULA sin aceptar o mods incompatibles.

Jarock no modifica router, firewall, port forwarding, IP pública, permisos de operador ni GitHub. Lo que falta antes de publicar está en `TODO.md`.

> **Nota técnica: Usa siempre `start-server.bat` en la raíz del repositorio. No hagas doble clic en `server.jar`; Windows puede usar Java 8 o Java 21, mientras que Minecraft 26.2 requiere Java 25+ de 64 bits. Consulta la [guía completa en inglés](../en/how-does-jarock-work.md).**
