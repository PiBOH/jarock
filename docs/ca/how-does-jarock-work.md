# Com funciona Jarock?

## Explicació senzilla del servidor

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Carregador:** Fabric
**Plataforma principal:** Windows 10/11

Aquest document explica què passa després de descarregar Jarock.


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome AWA is also included as a verified server-side Fabric 26.2 mod; it sends configurable colored join messages using `%player%` and supports `welcome reload`.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Nota de manteniment:** el llançador ara cerca un runtime Java 25+ compatible de 64 bits en lloc de confiar només en el primer `java.exe` de `PATH`. Utilitza `scripts/java-runtime.ps1`, desa l'executable seleccionat a `server/java-path.txt` i el valida abans d'iniciar. Java 8 pot continuar instal·lat.

## 1. Resum

L’usuari instal·la Java de 64 bits, descarrega aquest repository i executa `start-server.bat`. El programa troba la seva pròpia carpeta, comprova Java i el camí, demana activar els camins llargs de Windows si cal, descarrega Fabric i les mods fixades i verifica cada fitxer amb SHA-512.

Fabric crea el runtime a `server/`. La primera execució crea `server/eula.txt` amb `eula=false` i s’atura. Cal llegir <https://www.minecraft.net/eula>, canviar-ho a `eula=true` si s’accepta i tornar a executar-lo. Geyser tradueix el trànsit Bedrock i Floodgate gestiona l’autenticació Bedrock.

Jarock **no** configura el router, el firewall ni el port forwarding.

## 2. Fitxers i flux

El repository conté scripts, plantilles i un manifest, però no conté el món ni els `.jar` generats:

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

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

<!-- jarock-safe-shutdown -->

## Aturada segura

> Escriu `stop` a la consola i deixa la finestra oberta. Espera `CLEAN SHUTDOWN COMPLETE` i després `SAFE TO CLOSE` abans de tancar-la. Si falta el segon missatge, revisa el registre i l’informe de fallada i restaura una còpia si cal.

<!-- jarock-updater -->


## Actualitzar Jarock

> Llegeix `scripts/version.txt`, atura el servidor i espera `SAFE TO CLOSE`; després executa `scripts/update-jarock.bat`. Cerca una versió més nova del mateix canal beta/estable, demana confirmació i crea una còpia de retorn. Conserva el món, el runtime, els mods, les biblioteques i la configuració local; només repara dependències absents o invàlides.

> El paquet complet i la seva suma de verificació SHA-512 publicada es comproven abans de la instal·lació.

<!-- jarock-auto-update-check -->

## Comprovació d'actualitzacions en iniciar

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Protecció contra el tancament de la consola de Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Escriu stop i espera SAFE TO CLOSE. No forcis el tancament mentre es desa el món. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
