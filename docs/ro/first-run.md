> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

# Prima pornire Jarock

## Alegerea loaderului

Instalează un JDK Java 25+ pe 64 de biți, activează JAVA_HOME în instalatorul Temurin și redeschide terminalul. Folosește întotdeauna `start-server.bat` en `scripts/server-launch-settings.ini` din rădăcină și nu deschide direct `server/server.jar`.

## Instalare și EULA

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified package matching scripts/jarock-edition.ini automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## Oprire sigură

Jarock descarcă automat loaderul și modurile fixate. Prima rulare creează `server/eula.txt` și se oprește de obicei. Citește Minecraft EULA și schimbă `eula=false` în `eula=true` doar dacă accepți. Nu folosi `online-mode=false` înainte de prima rulare reușită.

## Oprire sigură

Rulează din nou, așteaptă lumea, Geyser și Floodgate, tastează `stop` și așteaptă `CLEAN SHUTDOWN COMPLETE` și `SAFE TO CLOSE`. Urmează Suggested fix la erori; dacă loaderele sunt amestecate, fă backup și rulează `clean-server-runtime.bat`. Citește `TODO.md` înainte de acces public.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## Notă de siguranță

Finalizează prima rulare cu `online-mode=true` pentru ca autentificarea normală să funcționeze.

## Notă de siguranță

Pentru a instala o actualizare, oprește serverul în siguranță și rulează `scripts/update-jarock.bat`.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-ro -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Protecție împotriva închiderii consolei Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Tastează stop și așteaptă SAFE TO CLOSE. Nu forța închiderea în timpul salvării lumii. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
