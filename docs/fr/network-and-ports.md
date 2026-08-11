# Réseau, pare-feu et routeur

Installez Java 25 64 bits, lancez `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` et terminez `TODO.md` avant d'ouvrir les ports. Attribuez une IP LAN fixe, ouvrez TCP `25565` (Java) et UDP `19132` (Bedrock) dans le pare-feu Windows, configurez la redirection de ports sur le routeur ou utilisez un tunnel compatible UDP comme playit.gg. Vérifiez que `online-mode=true` et `white-list=true`, et ne publiez jamais `key.pem`. En cas de CGNAT, utilisez un tunnel. Voir le [guide en anglais](../en/network-and-ports.md).

> Utilisez toujours `start-server.bat` ; ne double-cliquez pas sur `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

<!-- jarock-safe-shutdown -->

## Arrêt sûr

> Saisissez `stop` et laissez la fenêtre ouverte. Attendez `CLEAN SHUTDOWN COMPLETE`, puis `SAFE TO CLOSE` avant de la fermer. Si le second message manque, consultez le journal et le rapport de crash et restaurez une sauvegarde si nécessaire.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Mettre Jarock à jour

> Lisez `scripts/version.txt`, arrêtez le serveur et attendez `SAFE TO CLOSE`, puis exécutez `scripts/update-jarock.bat`. Il recherche une version plus récente du même canal bêta/stable, demande confirmation et crée une sauvegarde de retour. Le monde, le runtime, les mods, les bibliothèques et les réglages locaux sont conservés; les dépendances ne sont réparées que si elles manquent ou sont invalides.

> Le paquet complet et son empreinte SHA-512 publiée sont vérifiés avant l’installation.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Vérification des mises à jour au démarrage

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified package matching scripts/jarock-edition.ini automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Protection contre la fermeture de la console Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Saisissez stop et attendez SAFE TO CLOSE. Ne forcez jamais la fermeture pendant l’enregistrement du monde. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
