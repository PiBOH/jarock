> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

# Erster Start von Jarock

## Vor dem Start

Diese Anleitung beschreibt die erste Verwendung eines frischen Jarock-Repositorys. Verwende immer das `start-server.bat` im Stammverzeichnis und öffne `server/server.jar` nicht direkt. Installiere ein 64-Bit-JDK Java 25 oder neuer, aktiviere **Set JAVA_HOME variable** im Temurin-Installer und öffne das Terminal danach neu.

## Loader auswählen

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified package matching scripts/jarock-edition.ini automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## Installation und EULA

Jarock lädt den ausgewählten Loader und die festgelegten Server-Mods automatisch herunter. Beim ersten Start wird `server/eula.txt` erstellt und der Vorgang endet normalerweise. Lies die Minecraft EULA und ändere `eula=false` nur bei Zustimmung in `eula=true`. Setze `online-mode=false` nicht vor dem ersten erfolgreichen Start; verwende zunächst `online-mode=true`.

## Sicheres Beenden

Starte `start-server.bat` erneut und lasse Welt, Geyser und Floodgate vollständig laden. Zum Beenden gib `stop` in der Konsole ein und schließe das Fenster nicht. Warte auf `CLEAN SHUTDOWN COMPLETE` und `SAFE TO CLOSE`, bevor du es schließt.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## Nach dem ersten Start

Wenn Java fehlt, installiere Java 25 (64 Bit) und öffne das Terminal neu. Bei Downloadfehlern folge Suggested fix. Bei gemischten Fabric/NeoForge-Dateien sichere die Welt und führe `clean-server-runtime.bat` aus. Lass `online-mode=true` aktiv und lies `TODO.md` vor einer Veröffentlichung.

## Sicherheitshinweis

Für ein Update den Server sicher beenden und `scripts/update-jarock.bat` ausführen.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-de -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Schutz vor dem Schließen der Windows-Konsole:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Geben Sie stop ein und warten Sie auf SAFE TO CLOSE. Schließen Sie während des Speicherns niemals gewaltsam. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
