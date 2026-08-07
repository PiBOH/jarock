# Erster Start von Jarock

## Vor dem Start

Diese Anleitung beschreibt die erste Verwendung eines frischen Jarock-Repositorys. Verwende immer das `start-server.bat` im Stammverzeichnis und öffne `server/server.jar` nicht direkt. Installiere ein 64-Bit-JDK Java 25 oder neuer, aktiviere **Set JAVA_HOME variable** im Temurin-Installer und öffne das Terminal danach neu.

## Loader auswählen

Starte `start-server.bat`. Jarock prüft Java, Pfade und `scripts/server-launch-settings.ini` und migriert alte Root-Einstellungen automatisch. Wähle Fabric (empfohlen), NeoForge (Fallback) oder Forge (für Minecraft 26.2 derzeit nicht verfügbar). Mit `parameter-manager.bat` konfigurierst du RAM, GUI/Konsole, GC, `online-mode`, Banner und `AUTO_UPDATE_CHECK`. **Exit without saving** verwirft Änderungen.

## Installation und EULA

Jarock lädt den ausgewählten Loader und die festgelegten Server-Mods automatisch herunter. Beim ersten Start wird `server/eula.txt` erstellt und der Vorgang endet normalerweise. Lies die Minecraft EULA und ändere `eula=false` nur bei Zustimmung in `eula=true`. Setze `online-mode=false` nicht vor dem ersten erfolgreichen Start; verwende zunächst `online-mode=true`.

## Sicheres Beenden

Starte `start-server.bat` erneut und lasse Welt, Geyser und Floodgate vollständig laden. Zum Beenden gib `stop` in der Konsole ein und schließe das Fenster nicht. Warte auf `CLEAN SHUTDOWN COMPLETE` und `SAFE TO CLOSE`, bevor du es schließt.

## Nach dem ersten Start

Wenn Java fehlt, installiere Java 25 (64 Bit) und öffne das Terminal neu. Bei Downloadfehlern folge Suggested fix. Bei gemischten Fabric/NeoForge-Dateien sichere die Welt und führe `clean-server-runtime.bat` aus. Lass `online-mode=true` aktiv und lies `TODO.md` vor einer Veröffentlichung.

## Sicherheitshinweis

Für ein Update den Server sicher beenden und `scripts/update-jarock.bat` ausführen.
