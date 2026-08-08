# Erster Start von Jarock

## Vor dem Start

Diese Anleitung beschreibt die erste Verwendung eines frischen Jarock-Repositorys. Verwende immer das `start-server.bat` im Stammverzeichnis und öffne `server/server.jar` nicht direkt. Installiere ein 64-Bit-JDK Java 25 oder neuer, aktiviere **Set JAVA_HOME variable** im Temurin-Installer und öffne das Terminal danach neu.

## Loader auswählen

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.

## Installation und EULA

Jarock lädt den ausgewählten Loader und die festgelegten Server-Mods automatisch herunter. Beim ersten Start wird `server/eula.txt` erstellt und der Vorgang endet normalerweise. Lies die Minecraft EULA und ändere `eula=false` nur bei Zustimmung in `eula=true`. Setze `online-mode=false` nicht vor dem ersten erfolgreichen Start; verwende zunächst `online-mode=true`.

## Sicheres Beenden

Starte `start-server.bat` erneut und lasse Welt, Geyser und Floodgate vollständig laden. Zum Beenden gib `stop` in der Konsole ein und schließe das Fenster nicht. Warte auf `CLEAN SHUTDOWN COMPLETE` und `SAFE TO CLOSE`, bevor du es schließt.

## Nach dem ersten Start

Wenn Java fehlt, installiere Java 25 (64 Bit) und öffne das Terminal neu. Bei Downloadfehlern folge Suggested fix. Bei gemischten Fabric/NeoForge-Dateien sichere die Welt und führe `clean-server-runtime.bat` aus. Lass `online-mode=true` aktiv und lies `TODO.md` vor einer Veröffentlichung.

## Sicherheitshinweis

Für ein Update den Server sicher beenden und `scripts/update-jarock.bat` ausführen.

<!-- jarock-lan-addresses-de -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.
