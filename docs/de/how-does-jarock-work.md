# Wie funktioniert Jarock?

## Eine einfache Erklärung des Servers

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Loader:** Fabric
**Hauptplattform:** Windows 10/11

Dieses Dokument beschreibt den tatsächlichen Ablauf nach dem Herunterladen von Jarock.


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

Die Laufzeit wird unter `server/` erstellt. Welten, Logs, Bibliotheken, private Schlüssel und lokale Listen werden von Git ignoriert.

## 3. Der Startablauf

`start-server.bat` verwendet seinen eigenen Speicherort statt eines festen Pfads wie `C:\MinecraftServer`. Zugängliche Ordner mit Leerzeichen, Unicode, `!` und Verschachtelungen werden unterstützt.

Es startet `scripts\bootstrap-fabric.ps1`, prüft `server/fabric-server-launch.jar` und `server/eula.txt`, führt `scripts\configure-geyser.ps1` aus und startet:

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
