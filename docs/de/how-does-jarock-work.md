# Wie funktioniert Jarock?

## Eine einfache Erklärung des Servers

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Loader:** Fabric
**Hauptplattform:** Windows 10/11

Dieses Dokument beschreibt den tatsächlichen Ablauf nach dem Herunterladen von Jarock.


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome Message 2.8 with its required Collective library is included as a verified server-side Minecraft 26.2 mod for Fabric and NeoForge; it sends configurable join messages.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Wartungshinweis:** Der Launcher sucht jetzt nach einer kompatiblen 64-Bit-Java-25+-Laufzeit, statt nur dem ersten `java.exe` in `PATH` zu vertrauen. Er verwendet `scripts/java-runtime.ps1`, speichert die ausgewählte ausführbare Datei in `server/java-path.txt` und prüft sie vor dem Start. Java 8 darf installiert bleiben.

## 1. Kurzfassung

Der Benutzer installiert eine unterstützte 64-Bit-Java-Version, lädt dieses Repository herunter und startet `start-server.bat`. Das Programm findet seinen eigenen Speicherort, prüft Java und den Pfad, fordert bei langen Pfaden die Aktivierung von Windows Long Paths an, lädt den festgelegten Fabric-Installer und die Mods herunter und prüft jede Datei mit SHA-512.

Fabric erstellt die Laufzeit in `server/`. Beim ersten Start entsteht `server/eula.txt` mit `eula=false`; danach wird angehalten. Der Benutzer liest <https://www.minecraft.net/eula>, setzt bei Zustimmung `eula=true` und startet erneut. Geyser übersetzt anschließend Bedrock-Datenverkehr und Floodgate übernimmt die Bedrock-Authentifizierung.

Jarock richtet **keinen** Router, keine Firewall und kein Port Forwarding ein.

## 2. Repository und Laufzeit

Im Repository liegen Skripte, Vorlagen und das Manifest, aber keine generierte Welt und keine `.jar`-Dateien:

```text
start-server.bat
scripts/bootstrap-server.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
scripts/version.txt
CHANGELOG.md
TODO.md
```

Die Laufzeit wird unter `server/` erstellt. Welten, Logs, Bibliotheken, private Schlüssel und lokale Listen werden von Git ignoriert.

## 3. Der Startablauf

`start-server.bat` verwendet seinen eigenen Speicherort statt eines festen Pfads wie `C:\MinecraftServer`. Zugängliche Ordner mit Leerzeichen, Unicode, `!` und Verschachtelungen werden unterstützt.

Es startet `scripts\bootstrap-server.ps1`, prüft `server/fabric-server-launch.jar` und `server/eula.txt`, führt `scripts\configure-geyser.ps1` aus und startet:

```text
java -Xms4G -Xmx4G -jar fabric-server-launch.jar nogui
```

Bei einem Fehler müssen diese Dateien geprüft werden:

```text
server\logs\latest.log
server\crash-reports\
```

## 4. Der Bootstrap

Die Root wird aus `$PSScriptRoot` berechnet. Bei langen Pfaden wird geprüft:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

Wenn der Wert nicht `1` ist, fordert Jarock Administratorrechte an und führt `scripts\enable-long-paths.ps1` aus. Die Änderung gilt systemweit; ältere Programme benötigen eventuell einen Neustart.

Danach werden `java -version`, `server\mods-manifest.ps1`, Fabric 26.2 mit Loader `0.19.3`, die Mods in `server\mods\` und alle SHA-512-Hashes geprüft. Vorhandene lokale Konfigurationen werden nicht überschrieben.

Enthalten sind Fabric API, Geyser-Fabric, Floodgate-Fabric, Lithium, FerriteCore, Krypton, ServerCore und Fabric Carpet. Beliebige Bukkit/Spigot/Paper-Plugins werden nicht installiert.

## 5. EULA, Geyser und Floodgate

Der erste Start erstellt `server/eula.txt` mit `eula=false`. Erst nach der manuellen Zustimmung und `eula=true` startet der echte Server.

Geyser erzeugt seine vollständige Konfiguration beim ersten echten Start. Danach setzt das Hilfsskript in:

```text
server\config\Geyser-Fabric\config.yml
```

folgenden Wert:

```yaml
auth-type: floodgate
```

Java verwendet normalerweise TCP `25565`, Bedrock UDP `19132`. Jarock öffnet diese Ports nicht. `key.pem` ist geheim und darf nicht veröffentlicht werden.

## 6. Fehler und Grenzen

Nach jedem Fehler `ERROR:` oder `WARNING:` lesen und `Suggested fix:` befolgen. Wenn Java beendet wird, den ersten `Caused by:`-Eintrag in den Logs suchen. Häufige Ursachen sind fehlendes Java, fehlende Schreibrechte, beschädigte Downloads, nicht akzeptierte EULA oder inkompatible Mods.

Jarock verändert keinen Router, keine Firewall, kein Port Forwarding und keine öffentliche IP. Die offenen Aufgaben stehen in `TODO.md`. Nicht verfügbare Laufwerke, verweigerte Rechte, ungeeignete Netzwerkfreigaben und alte Anwendungen bleiben Windows-Grenzen.

> **Technischer Hinweis: Verwenden Sie immer `start-server.bat` im Stammverzeichnis des Repositorys. Doppelklicken Sie nicht auf `server.jar`; Windows kann Java 8 oder Java 21 verwenden, während Minecraft 26.2 64-Bit-Java 25+ benötigt. Siehe die [vollständige englische Anleitung](../en/how-does-jarock-work.md).**

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> InvView 1.4.21 is a verified Minecraft 26.2 server-side Fabric mod. It requires Fabric API and lets authorized operators inspect and manage online or offline player inventories and ender chests; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> OfflineCommands 1.0.3 is a verified Minecraft 26.2 server-side Fabric mod for running commands on offline players. No compatible NeoForge 26.2 build is available, so NeoForge does not install it.

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

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified package matching scripts/jarock-edition.ini automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Schutz vor dem Schließen der Windows-Konsole:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Geben Sie stop ein und warten Sie auf SAFE TO CLOSE. Schließen Sie während des Speicherns niemals gewaltsam. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
