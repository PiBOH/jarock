# Průvodce sítí, firewallem a routerem

Nainstalujte 64bitovou Javu 25, spusťte `start-server.bat` a dokončete `TODO.md` před otevřením portů. Přidělte pevnou LAN IP, otevřete TCP `25565` (Java) a UDP `19132` (Bedrock) ve Windows Firewallu, nakonfigurujte přesměrování portů na routeru nebo použijte UDP tunel jako playit.gg. Zkontrolujte `online-mode=true` a `white-list=true` a nikdy nezveřejňujte `key.pem`. Pro CGNAT použijte tunel. Viz [kanonický anglický průvodce](../en/network-and-ports.md). (abilita Set JAVA_HOME nell’installer Temurin) (enable "Set JAVA_HOME variable" in the Temurin installer)

> Vždy používejte `start-server.bat`; neklikejte dvakrát na `server.jar`.
