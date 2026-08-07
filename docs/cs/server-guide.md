# Průvodce serverem Fabric

Nainstalujte 64bitovou Javu 25, spusťte `start-server.bat` a použijte `parameter-manager.bat` pro RAM a GUI nebo `nogui`. Přečtěte `server/eula.txt` a nastavte `eula=true` až po přijetí EULA. Použijte Fabric, Geyser-Fabric a Floodgate-Fabric a vytvořte zálohu. Jarock nemění router, firewall ani port forwarding.

See the [English installation guide](../en/server-guide.md) for the complete procedure. Keep commands, paths, keys and URLs unchanged.


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Technická poznámka: Vždy používejte `start-server.bat` v kořenu repozitáře. Na `server.jar` neklikejte dvakrát; Windows může použít Javu 8 nebo Javu 21, zatímco Minecraft 26.2 vyžaduje 64bitovou Javu 25+. Viz [úplná anglická příručka](../en/server-guide.md).**
