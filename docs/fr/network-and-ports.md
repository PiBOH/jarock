# Réseau, pare-feu et routeur

Installez Java 25 64 bits, lancez `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` et terminez `TODO.md` avant d'ouvrir les ports. Attribuez une IP LAN fixe, ouvrez TCP `25565` (Java) et UDP `19132` (Bedrock) dans le pare-feu Windows, configurez la redirection de ports sur le routeur ou utilisez un tunnel compatible UDP comme playit.gg. Vérifiez que `online-mode=true` et `white-list=true`, et ne publiez jamais `key.pem`. En cas de CGNAT, utilisez un tunnel. Voir le [guide en anglais](../en/network-and-ports.md).

> Utilisez toujours `start-server.bat` ; ne double-cliquez pas sur `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Arrêt sûr

> Saisissez `stop` et laissez la fenêtre ouverte. Attendez `CLEAN SHUTDOWN COMPLETE`, puis `SAFE TO CLOSE` avant de la fermer. Si le second message manque, consultez le journal et le rapport de crash et restaurez une sauvegarde si nécessaire.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Mettre Jarock à jour

> Lisez `scripts/version.txt`, arrêtez le serveur et attendez `SAFE TO CLOSE`, puis exécutez `scripts/update-jarock.bat`. Il recherche une version plus récente du même canal bêta/stable, demande confirmation et crée une sauvegarde de retour. Le monde, le runtime, les mods, les bibliothèques et les réglages locaux sont conservés; les dépendances ne sont réparées que si elles manquent ou sont invalides.

> Le paquet complet et son empreinte SHA-512 publiée sont vérifiés avant l’installation.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to run the same check without starting the server. If a verified compatible Lite package is available, the updater asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Vérification des mises à jour au démarrage

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Protection contre la fermeture de la console Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Saisissez stop et attendez SAFE TO CLOSE. Ne forcez jamais la fermeture pendant l’enregistrement du monde. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
