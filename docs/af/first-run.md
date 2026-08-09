# Eerste Jarock-beginloop

## Voorbereiding

Hierdie gids verduidelik die eerste gebruik van 'n vars Jarock-bewaarplek. Gebruik altyd die wortel-`start-server.bat`; moenie `server/server.jar` direk oopmaak nie. Installeer 'n 64-bis Java 25 of nuwer JDK en aktiveer **Set JAVA_HOME variable** in die Temurin-installeerder. Heropen die opdragvenster daarna.

## Eerste loader-keuse

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## Installasie en EULA

Jarock laai die gekose loader en vasgepinde bedienermods outomaties af. Die eerste lopie skep `server/eula.txt` en stop gewoonlik. Lees die Minecraft EULA en verander slegs indien jy instem `eula=false` na `eula=true`. Moenie `online-mode=false` voor die eerste suksesvolle lopie stel nie; gebruik eers `online-mode=true`.

## Veilige afskakeling

Begin `start-server.bat` weer. Laat wêreldskepping, Geyser en Floodgate volledig klaarmaak. Om te stop, tik `stop` in die bedienerkonsole en moenie die venster sluit nie. Wag vir `CLEAN SHUTDOWN COMPLETE` en `SAFE TO CLOSE`; eers daarna is dit veilig om die venster te sluit.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## Na die eerste begin

As Java ontbreek, installeer 64-bis Java 25 en heropen die terminale. Vir netwerk- of aflaaifoute, lees die voorgestelde oplossing en probeer weer. As Fabric en NeoForge gemeng is, maak 'n rugsteun, voer `clean-server-runtime.bat` uit en kies een loader. Hou `online-mode=true` vir normale veilige gebruik en lees `TODO.md` voor openbare toegang.

## Veiligheidsnota

Vir 'n opdatering, stop veilig en voer `scripts/update-jarock.bat` uit.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-af -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Windows-konsole-sluitbeskerming:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Tik stop en wag vir SAFE TO CLOSE. Moet nooit forseer sluit terwyl die wêreld gestoor word nie. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
