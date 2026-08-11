# Netzwerk-, Firewall- und Router-Konfiguration

Installieren Sie 64-Bit-Java 25, führen Sie `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` aus und schließen Sie `TODO.md` ab, bevor Sie Ports öffnen. Vergeben Sie eine feste LAN-IP, öffnen Sie TCP `25565` (Java) und UDP `19132` (Bedrock) in der Windows-Firewall, konfigurieren Sie die Portweiterleitung im Router oder verwenden Sie einen UDP-fähigen Tunnel wie playit.gg. Stellen Sie sicher, dass `online-mode=true` und `white-list=true` aktiviert sind und `key.pem` niemals veröffentlicht wird. Bei CGNAT einen Tunnel verwenden. Siehe [ englische Anleitung](../en/network-and-ports.md).

> Verwenden Sie immer `start-server.bat`; starten Sie `server.jar` nicht per Doppelklick.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

<!-- jarock-safe-shutdown -->

## Sicheres Beenden

> Geben Sie `stop` ein und lassen Sie das Fenster offen. Warten Sie vor dem Schließen auf `CLEAN SHUTDOWN COMPLETE` und danach `SAFE TO CLOSE`. Fehlt die zweite Meldung, prüfen Sie Log und Absturzbericht und stellen Sie bei Bedarf ein Backup wieder her.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Jarock aktualisieren

> Lesen Sie `scripts/version.txt`, beenden Sie den Server und warten Sie auf `SAFE TO CLOSE`; starten Sie danach `scripts/update-jarock.bat`. Es sucht eine neuere Version im gleichen Beta/stabilen Kanal, fragt nach Bestätigung und erstellt ein Rollback-Backup. Welt, Runtime, Mods, Bibliotheken und lokale Einstellungen bleiben erhalten; Abhängigkeiten werden nur bei fehlenden oder ungültigen Dateien erneut geladen.

> Das vollständige Paket und seine veröffentlichte SHA-512-Prüfsumme werden vor der Installation geprüft.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Updateprüfung beim Start

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Schutz vor dem Schließen der Windows-Konsole:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Geben Sie stop ein und warten Sie auf SAFE TO CLOSE. Schließen Sie während des Speicherns niemals gewaltsam. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
