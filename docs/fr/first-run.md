> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

# Premier démarrage de Jarock

## Avant de commencer

Cette guide décrit la première utilisation d’un dépôt Jarock neuf. Utilisez toujours le `start-server.bat` racine, n’ouvrez pas `server/server.jar` directement, installez un JDK Java 25+ 64 bits, activez **Set JAVA_HOME variable** dans Temurin et rouvrez le terminal.

## Choisir le loader

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## Installation et EULA

Le loader et les mods épinglés sont téléchargés automatiquement. Le premier démarrage crée `server/eula.txt` puis s’arrête. Lisez la Minecraft EULA et passez `eula=false` à `eula=true` seulement si vous acceptez. Ne mettez pas `online-mode=false` avant le premier démarrage réussi; utilisez d’abord `online-mode=true`.

## Arrêt sécurisé

Relancez `start-server.bat` et attendez la fin du monde, de Geyser et de Floodgate. Pour arrêter, saisissez `stop` et attendez `CLEAN SHUTDOWN COMPLETE` puis `SAFE TO CLOSE` avant de fermer.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## Après le premier démarrage

Si Java manque, installez Java 25 64 bits. Suivez Suggested fix en cas d’erreur. Si les loaders sont mélangés, sauvegardez le monde et lancez `clean-server-runtime.bat`. Lisez `TODO.md` avant de rendre le serveur public.

## Note de sécurité

Pour installer une mise à jour, arrêtez le serveur correctement et exécutez `scripts/update-jarock.bat`.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-fr -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Protection contre la fermeture de la console Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Saisissez stop et attendez SAFE TO CLOSE. Ne forcez jamais la fermeture pendant l’enregistrement du monde. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
