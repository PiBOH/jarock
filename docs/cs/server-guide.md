# Průvodce serverem Fabric

Nainstalujte 64bitovou Javu 25, spusťte `start-server.bat` a použijte `parameter-manager.bat` pro RAM a GUI nebo `nogui`. Přečtěte `server/eula.txt` a nastavte `eula=true` až po přijetí EULA. Použijte Fabric, Geyser-Fabric a Floodgate-Fabric a vytvořte zálohu. Jarock nemění router, firewall ani port forwarding.

See the [canonical English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Technická poznámka: Vždy používejte `start-server.bat` v kořenu repozitáře. Na `server.jar` neklikejte dvakrát; Windows může použít Javu 8 nebo Javu 21, zatímco Minecraft 26.2 vyžaduje 64bitovou Javu 25+. Viz [úplná anglická příručka](../en/server-guide.md).**
