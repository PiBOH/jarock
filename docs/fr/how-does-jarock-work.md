# Comment fonctionne Jarock ?

## Explication simple du serveur

**Minecraft :** Java Edition `26.2`
**Chargeur :** Fabric
**Plate-forme principale :** Windows 10/11

Ce document décrit ce qui se passe après le téléchargement de Jarock.

> **Note de maintenance :** le lanceur recherche désormais un runtime Java 25+ compatible en 64 bits au lieu de faire confiance uniquement au premier `java.exe` de `PATH`. Il utilise `scripts/java-runtime.ps1`, enregistre l'exécutable choisi dans `server/java-path.txt` et le vérifie avant le démarrage. Java 8 peut rester installé.

## 1. Résumé

L’utilisateur installe Java 64 bits, télécharge ou clone le dépôt, puis lance `start-server.bat`. Le programme trouve son propre dossier, vérifie Java et le chemin, demande si nécessaire l’activation des chemins longs Windows, télécharge Fabric et les mods épinglés, puis vérifie chaque fichier avec SHA-512.

Fabric crée l’environnement dans `server/`. Au premier lancement, `server/eula.txt` est créé avec `eula=false` et le serveur s’arrête. L’utilisateur doit lire <https://www.minecraft.net/eula>, mettre `eula=true` s’il accepte, puis relancer. Geyser traduit ensuite le trafic Bedrock et Floodgate gère son authentification.

Jarock **ne** configure ni routeur, ni pare-feu, ni port forwarding.

## 2. Dépôt et runtime

Le dépôt contient scripts, modèles et manifeste, mais pas le monde ni les `.jar` générés :

```text
start-server.bat
scripts/bootstrap-fabric.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
version.txt
CHANGELOG.md
TODO.md
```

Le runtime est créé dans `server/`. Les mondes, journaux, bibliothèques, clés privées et listes locales sont ignorés par Git.

## 3. Le démarrage

`start-server.bat` utilise son propre emplacement et aucun chemin fixe comme `C:\MinecraftServer`. Les espaces, caractères Unicode, `!` et les sous-dossiers accessibles sont donc pris en charge.

Il exécute `scripts\bootstrap-fabric.ps1`, vérifie `server/fabric-server-launch.jar` et `server/eula.txt`, puis exécute `scripts\configure-geyser.ps1` avant de lancer :

```text
java -Xms4G -Xmx4G -jar fabric-server-launch.jar nogui
```

En cas d’arrêt avec erreur, consulter :

```text
server\logs\latest.log
server\crash-reports\
```

## 4. Le bootstrap

La racine est calculée avec `$PSScriptRoot`. Pour un chemin profond, Jarock vérifie :

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

Si la valeur n’est pas `1`, il demande les droits administrateur et exécute `scripts\enable-long-paths.ps1`. Le changement est global à la machine et un redémarrage peut être nécessaire.

Le script vérifie `java -version`, charge `server\mods-manifest.ps1`, installe Fabric 26.2 avec Loader `0.19.3`, télécharge les mods dans `server\mods\` et vérifie tous les SHA-512. Les configurations locales existantes ne sont pas écrasées.

Le stack comprend Fabric API, Geyser-Fabric, Floodgate-Fabric, Lithium, FerriteCore, Krypton, ServerCore et Fabric Carpet. Les plugins Bukkit/Spigot/Paper ne sont pas installés.

## 5. EULA, Geyser et Floodgate

Le premier lancement crée `server/eula.txt` avec `eula=false`. Après acceptation de la EULA, un second lancement démarre vraiment le serveur.

Geyser génère son YAML complet pendant le premier démarrage réel. Quand ce fichier existe :

```text
server\config\Geyser-Fabric\config.yml
```

le script met :

```yaml
auth-type: floodgate
```

Bedrock utilise généralement UDP `19132` et Java TCP `25565`; Jarock ne les ouvre pas. `key.pem` est une clé privée et ne doit jamais être publié.

## 6. Erreurs et limites

Après une erreur, lire `ERROR:` ou `WARNING:` et suivre `Suggested fix:`. Si Java s’arrête, chercher le premier `Caused by:` dans les logs. Les causes fréquentes sont Java absent, permissions, téléchargement corrompu, EULA non acceptée ou mod incompatible.

Jarock ne modifie pas le routeur, le pare-feu, le port forwarding, l’adresse IP publique ou GitHub. Les tâches restantes sont dans `TODO.md`. Les lecteurs réseau non compatibles, droits refusés et applications legacy non compatibles avec les chemins longs restent des limites de Windows.
