# Primera execució de Jarock

## Abans de començar

Aquesta guia explica el primer ús d’un repositori Jarock nou. Executa sempre el `start-server.bat` de l’arrel i no obris directament `server/server.jar`. Instal·la un JDK Java 25 o posterior de 64 bits, activa **Set JAVA_HOME variable** a l’instal·lador Temurin i torna a obrir el terminal.

## Elecció del loader

Executa `start-server.bat`. Jarock comprova Java, les rutes i `scripts/server-launch-settings.ini`, i migra automàticament la configuració antiga de l’arrel. Tria Fabric (recomanat), NeoForge (alternativa) o Forge (actualment no disponible per a Minecraft 26.2). `parameter-manager.bat` configura RAM, GUI/consola, GC, `online-mode`, la pancarta i `AUTO_UPDATE_CHECK`. **Exit without saving** cancel·la sense desar.

## Instal·lació i EULA

Jarock descarrega el loader i els mods fixats automàticament. El primer arrencada crea `server/eula.txt` i normalment s’atura. Llegeix la Minecraft EULA i canvia `eula=false` a `eula=true` només si hi estàs d’acord. No posis `online-mode=false` abans del primer arrencada correcte; fes primer una execució amb `online-mode=true`.

## Aturada segura

Torna a executar `start-server.bat` i deixa acabar la creació del món, Geyser i Floodgate. Per aturar-lo, escriu `stop` a la consola i no tanquis la finestra. Espera `CLEAN SHUTDOWN COMPLETE` i `SAFE TO CLOSE` abans de tancar-la.

## Després del primer arrencada

Si falta Java, instal·la Java 25 de 64 bits i reobre el terminal. Per errors de xarxa, segueix Suggested fix i torna-ho a provar. Si s’han barrejat Fabric i NeoForge, fes una còpia, executa `clean-server-runtime.bat` i tria un sol loader. Mantén `online-mode=true` i consulta `TODO.md` abans de fer públic el servidor.

## Nota de seguretat

Per instal·lar una actualització, atura el servidor amb seguretat i executa `scripts/update-jarock.bat`.

<!-- jarock-lan-addresses-ca -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.
