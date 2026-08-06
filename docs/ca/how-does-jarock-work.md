# Com funciona Jarock?

## Explicació senzilla del servidor

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Carregador:** Fabric
**Plataforma principal:** Windows 10/11

Aquest document explica què passa després de descarregar Jarock.

> **Nota de manteniment:** el llançador ara cerca un runtime Java 25+ compatible de 64 bits en lloc de confiar només en el primer `java.exe` de `PATH`. Utilitza `scripts/java-runtime.ps1`, desa l'executable seleccionat a `server/java-path.txt` i el valida abans d'iniciar. Java 8 pot continuar instal·lat.

## 1. Resum

L’usuari instal·la Java de 64 bits, descarrega aquest repository i executa `start-server.bat`. El programa troba la seva pròpia carpeta, comprova Java i el camí, demana activar els camins llargs de Windows si cal, descarrega Fabric i les mods fixades i verifica cada fitxer amb SHA-512.

Fabric crea el runtime a `server/`. La primera execució crea `server/eula.txt` amb `eula=false` i s’atura. Cal llegir <https://www.minecraft.net/eula>, canviar-ho a `eula=true` si s’accepta i tornar a executar-lo. Geyser tradueix el trànsit Bedrock i Floodgate gestiona l’autenticació Bedrock.

Jarock **no** configura el router, el firewall ni el port forwarding.

## 2. Fitxers i flux

El repository conté scripts, plantilles i un manifest, però no conté el món ni els `.jar` generats:

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

El runtime es crea a `server/`. Git ignora els mons, logs, biblioteques, claus privades i llistes locals.

`start-server.bat` fa servir la seva ubicació, no un camí fix com `C:\MinecraftServer`. Admet camins accessibles amb espais, Unicode, `!` i carpetes niades. Per als camins llargs comprova:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

Si cal, demana permisos d’administrador i executa `scripts\enable-long-paths.ps1`. El canvi és global i pot requerir reiniciar Windows.

## 3. EULA, Geyser i errors

La primera execució crea `server/eula.txt` amb `eula=false`. Llegeix la EULA, canvia-ho a `eula=true` si hi estàs d’acord i executa el programa de nou.

Geyser genera la configuració completa durant el primer inici real. Després, a:

```text
server\config\Geyser-Fabric\config.yml
```

el script estableix:

```yaml
auth-type: floodgate
```

Java utilitza normalment TCP `25565` i Bedrock UDP `19132`. Jarock no obre ports. `key.pem` és privat i no s’ha de publicar.

Després d’un error, llegeix `ERROR:` o `WARNING:` i segueix `Suggested fix:`. Si Java s’atura, busca el primer `Caused by:` a `server\logs\latest.log` o `server\crash-reports\`. Les tasques pendents són a `TODO.md`.

> **Nota tècnica: Utilitza sempre el `start-server.bat` de l’arrel del repositori. No facis doble clic a `server.jar`; Windows pot utilitzar Java 8 o Java 21, mentre que Minecraft 26.2 requereix Java 25+ de 64 bits. Consulta la [guia anglesa completa](../en/how-does-jarock-work.md).**
