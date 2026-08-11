> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

# Primera execució de Jarock

## Abans de començar

Aquesta guia explica el primer ús d’un repositori Jarock nou. Executa sempre el `start-server.bat` de l’arrel i no obris directament `server/server.jar`. Instal·la un JDK Java 25 o posterior de 64 bits, activa **Set JAVA_HOME variable** a l’instal·lador Temurin i torna a obrir el terminal.

## Elecció del loader

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## Instal·lació i EULA

Jarock descarrega el loader i els mods fixats automàticament. El primer arrencada crea `server/eula.txt` i normalment s’atura. Llegeix la Minecraft EULA i canvia `eula=false` a `eula=true` només si hi estàs d’acord. No posis `online-mode=false` abans del primer arrencada correcte; fes primer una execució amb `online-mode=true`.

## Aturada segura

Torna a executar `start-server.bat` i deixa acabar la creació del món, Geyser i Floodgate. Per aturar-lo, escriu `stop` a la consola i no tanquis la finestra. Espera `CLEAN SHUTDOWN COMPLETE` i `SAFE TO CLOSE` abans de tancar-la.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## Després del primer arrencada

Si falta Java, instal·la Java 25 de 64 bits i reobre el terminal. Per errors de xarxa, segueix Suggested fix i torna-ho a provar. Si s’han barrejat Fabric i NeoForge, fes una còpia, executa `clean-server-runtime.bat` i tria un sol loader. Mantén `online-mode=true` i consulta `TODO.md` abans de fer públic el servidor.

## Nota de seguretat

Per instal·lar una actualització, atura el servidor amb seguretat i executa `scripts/update-jarock.bat`.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-ca -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Protecció contra el tancament de la consola de Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Escriu stop i espera SAFE TO CLOSE. No forcis el tancament mentre es desa el món. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
