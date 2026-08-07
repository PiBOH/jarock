# Fabric-Serverhandbuch

Installieren Sie 64-Bit-Java 25, starten Sie `start-server.bat` und verwenden Sie `parameter-manager.bat` für RAM sowie GUI oder `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) Lesen Sie `server/eula.txt`, akzeptieren Sie die EULA und setzen Sie `eula=true`; verwenden Sie Fabric, Geyser-Fabric und Floodgate-Fabric und erstellen Sie Backups. Jarock ändert Router, Firewall und Portweiterleitung nicht.

Lesen Sie die vollständige englische Anleitung: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Technischer Hinweis: Verwenden Sie immer `start-server.bat` im Stammverzeichnis des Repositorys. Doppelklicken Sie nicht auf `server.jar`; Windows kann Java 8 oder Java 21 verwenden, während Minecraft 26.2 64-Bit-Java 25+ benötigt. Siehe die [vollständige englische Anleitung](../en/server-guide.md).**

<!-- jarock-safe-shutdown -->

## Sicheres Beenden

> Geben Sie `stop` ein und lassen Sie das Fenster offen. Warten Sie vor dem Schließen auf `CLEAN SHUTDOWN COMPLETE` und danach `SAFE TO CLOSE`. Fehlt die zweite Meldung, prüfen Sie Log und Absturzbericht und stellen Sie bei Bedarf ein Backup wieder her.

<!-- jarock-updater -->


## Jarock aktualisieren

> Lesen Sie `version.txt`, beenden Sie den Server und warten Sie auf `SAFE TO CLOSE`; starten Sie danach `update-jarock.bat`. Es sucht eine neuere Version im gleichen Beta/stabilen Kanal, fragt nach Bestätigung und erstellt ein Rollback-Backup. Welt, Runtime, Mods, Bibliotheken und lokale Einstellungen bleiben erhalten; Abhängigkeiten werden nur bei fehlenden oder ungültigen Dateien erneut geladen.

> Das vollständige Paket und seine veröffentlichte SHA-512-Prüfsumme werden vor der Installation geprüft.
