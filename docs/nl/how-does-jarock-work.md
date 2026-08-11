# Hoe werkt Jarock?

## Eenvoudige uitleg van de server

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Loader:** Fabric
**Hoofdplatform:** Windows 10/11

Dit document legt uit wat er gebeurt nadat Jarock is gedownload.


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome Message 2.8 with its required Collective library is included as a verified server-side Minecraft 26.2 mod for Fabric and NeoForge; it sends configurable join messages.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Onderhoudsnotitie:** De launcher zoekt nu naar een compatibele 64-bits Java 25+ runtime in plaats van alleen de eerste `java.exe` in `PATH` te vertrouwen. Hij gebruikt `scripts/java-runtime.ps1`, slaat het gekozen uitvoerbare bestand op in `server/java-path.txt` en controleert het vóór het starten. Java 8 mag geïnstalleerd blijven.

## 1. Kort samengevat

De gebruiker installeert 64-bits Java, downloadt deze repository en start `start-server.bat`. Het programma vindt zijn eigen map, controleert Java en het pad, vraagt indien nodig om Windows-ondersteuning voor lange paden, downloadt de vastgezette Fabric-installer en mods en controleert elk bestand met SHA-512.

Fabric maakt de runtime in `server/`. De eerste start maakt `server/eula.txt` met `eula=false` en stopt. De gebruiker moet <https://www.minecraft.net/eula> lezen, `eula=true` instellen als hij of zij akkoord gaat en opnieuw starten. Geyser vertaalt Bedrock-verkeer en Floodgate regelt de Bedrock-authenticatie.

Jarock configureert **geen** router, firewall of port forwarding.

## 2. Bestanden en mappen

De repository bevat scripts, sjablonen en een manifest, maar niet de wereld of gegenereerde `.jar`-bestanden:

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

De runtime wordt in `server/` gemaakt. Werelden, logs, bibliotheken, privésleutels en lokale lijsten worden door Git genegeerd.

`start-server.bat` gebruikt zijn eigen locatie in plaats van een vast pad zoals `C:\MinecraftServer`. Toegankelijke paden met spaties, Unicode, `!` en geneste mappen worden ondersteund. Voor lange paden wordt dit gecontroleerd:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

Als het nodig is, vraagt het script administratorrechten en voert het `scripts\enable-long-paths.ps1` uit. De wijziging is systeemwijd en een herstart kan nodig zijn.

## 3. EULA, Geyser en fouten

De eerste start maakt `server/eula.txt` met `eula=false` en stopt. Lees de EULA, verander dit naar `eula=true` als je akkoord gaat en start opnieuw.

Geyser maakt zijn volledige configuratie tijdens de eerste echte serverstart. Daarna stelt het script in:

```text
server\config\Geyser-Fabric\config.yml
```

```yaml
auth-type: floodgate
```

Java gebruikt normaal TCP `25565` en Bedrock UDP `19132`. Jarock opent geen poorten. `key.pem` is privé en mag niet worden gepubliceerd.

Lees na elke fout `ERROR:` of `WARNING:` en volg `Suggested fix:`. Als Java stopt, zoek dan de eerste `Caused by:` in `server\logs\latest.log` of `server\crash-reports\`. De resterende taken staan in `TODO.md`.

> **Technische opmerking: Gebruik altijd `start-server.bat` in de hoofdmap van de repository. Dubbelklik niet op `server.jar`; Windows kan Java 8 of Java 21 gebruiken, terwijl Minecraft 26.2 64-bits Java 25+ vereist. Zie de [volledige Engelse handleiding](../en/how-does-jarock-work.md).**

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> InvView 1.4.21 is a verified Minecraft 26.2 server-side Fabric mod. It requires Fabric API and lets authorized operators inspect and manage online or offline player inventories and ender chests; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> OfflineCommands 1.0.3 is a verified Minecraft 26.2 server-side Fabric mod for running commands on offline players. No compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

<!-- jarock-safe-shutdown -->

## Veilig afsluiten

> Typ `stop` en laat het venster open. Wacht vóór het sluiten op `CLEAN SHUTDOWN COMPLETE` en daarna `SAFE TO CLOSE`. Ontbreekt de tweede melding, controleer dan het log en crashrapport en herstel zo nodig een back-up.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Jarock bijwerken

> Lees `scripts/version.txt`, stop de server en wacht op `SAFE TO CLOSE`; voer daarna `scripts/update-jarock.bat` uit. Het zoekt een nieuwere release in hetzelfde beta/stabiele kanaal, vraagt bevestiging en maakt een rollback-back-up. Wereld, runtime, mods, bibliotheken en lokale instellingen blijven behouden; afhankelijkheden worden alleen hersteld als ze ontbreken of ongeldig zijn.

> Het volledige pakket en de gepubliceerde SHA-512-controlesom worden vóór de installatie gecontroleerd.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Updatecontrole bij het opstarten

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Bescherming tegen het sluiten van de Windows-console:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Typ stop en wacht op SAFE TO CLOSE. Forceer nooit het sluiten tijdens het opslaan van de wereld. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
