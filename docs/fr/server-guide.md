# Guide du serveur Fabric

Installez Java 25 64 bits, lancez `start-server.bat` et utilisez `parameter-manager.bat` pour la RAM et le mode GUI ou `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Lisez `server/eula.txt` et mettez `eula=true` après acceptation de l’EULA seulement. Utilisez Fabric, Geyser-Fabric et Floodgate-Fabric et faites des sauvegardes. Jarock ne modifie ni routeur, ni pare-feu, ni port forwarding.

See the [English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Note technique : utilisez toujours `start-server.bat` à la racine du dépôt. Ne double-cliquez pas sur `server.jar` ; Windows peut utiliser Java 8 ou Java 21, alors que Minecraft 26.2 exige Java 25+ en 64 bits. Consultez le [guide anglais complet](../en/server-guide.md).**

<!-- jarock-safe-shutdown -->

## Arrêt sûr

> Saisissez `stop` et laissez la fenêtre ouverte. Attendez `CLEAN SHUTDOWN COMPLETE`, puis `SAFE TO CLOSE` avant de la fermer. Si le second message manque, consultez le journal et le rapport de crash et restaurez une sauvegarde si nécessaire.

<!-- jarock-updater -->


## Mettre Jarock à jour

> Lisez `version.txt`, arrêtez le serveur et attendez `SAFE TO CLOSE`, puis exécutez `update-jarock.bat`. Il recherche une version plus récente du même canal bêta/stable, demande confirmation et crée une sauvegarde de retour. Le monde, le runtime, les mods, les bibliothèques et les réglages locaux sont conservés; les dépendances ne sont réparées que si elles manquent ou sont invalides.

> Le paquet complet et son empreinte SHA-512 publiée sont vérifiés avant l’installation.

<!-- jarock-auto-update-check -->

## Vérification des mises à jour au démarrage

Définissez AUTO_UPDATE_CHECK=true dans parameter-manager.bat afin que start-server.bat vérifie GitHub en lecture seule au démarrage. Une version compatible plus récente est signalée, mais rien n’est installé automatiquement. Arrêtez le serveur, attendez SAFE TO CLOSE et exécutez update-jarock.bat. La valeur par défaut est AUTO_UPDATE_CHECK=false.
