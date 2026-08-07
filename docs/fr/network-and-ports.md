# Réseau, pare-feu et routeur

Installez Java 25 64 bits, lancez `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` et terminez `TODO.md` avant d'ouvrir les ports. Attribuez une IP LAN fixe, ouvrez TCP `25565` (Java) et UDP `19132` (Bedrock) dans le pare-feu Windows, configurez la redirection de ports sur le routeur ou utilisez un tunnel compatible UDP comme playit.gg. Vérifiez que `online-mode=true` et `white-list=true`, et ne publiez jamais `key.pem`. En cas de CGNAT, utilisez un tunnel. Voir le [guide en anglais](../en/network-and-ports.md).

> Utilisez toujours `start-server.bat` ; ne double-cliquez pas sur `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Arrêt sûr

> Saisissez `stop` et laissez la fenêtre ouverte. Attendez `CLEAN SHUTDOWN COMPLETE`, puis `SAFE TO CLOSE` avant de la fermer. Si le second message manque, consultez le journal et le rapport de crash et restaurez une sauvegarde si nécessaire.

<!-- jarock-updater -->


## Mettre Jarock à jour

> Lisez `scripts/version.txt`, arrêtez le serveur et attendez `SAFE TO CLOSE`, puis exécutez `scripts/update-jarock.bat`. Il recherche une version plus récente du même canal bêta/stable, demande confirmation et crée une sauvegarde de retour. Le monde, le runtime, les mods, les bibliothèques et les réglages locaux sont conservés; les dépendances ne sont réparées que si elles manquent ou sont invalides.

> Le paquet complet et son empreinte SHA-512 publiée sont vérifiés avant l’installation.

<!-- jarock-auto-update-check -->

## Vérification des mises à jour au démarrage

Définissez AUTO_UPDATE_CHECK=true dans parameter-manager.bat afin que start-server.bat vérifie GitHub en lecture seule au démarrage. Une version compatible plus récente est signalée, mais demandera une confirmation avant l’installation. Choisissez Y pour installer la mise à jour Lite ou N/Entrée pour continuer avec la version actuelle. La valeur par défaut est AUTO_UPDATE_CHECK=false. When a compatible newer release is found at startup, Jarock asks `Download and install it now? (y/N)`; choose y to install the verified Lite package, or N/Enter to continue with the current version. It never updates silently.
