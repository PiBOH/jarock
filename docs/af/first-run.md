# Eerste Jarock-beginloop

## Voorbereiding

Hierdie gids verduidelik die eerste gebruik van 'n vars Jarock-bewaarplek. Gebruik altyd die wortel-`start-server.bat`; moenie `server/server.jar` direk oopmaak nie. Installeer 'n 64-bis Java 25 of nuwer JDK en aktiveer **Set JAVA_HOME variable** in die Temurin-installeerder. Heropen die opdragvenster daarna.

## Eerste loader-keuse

Begin `start-server.bat`. Jarock kontroleer Java, paaie en `scripts/server-launch-settings.ini`. As die ou wortelinstellings bestaan, word hulle na `scripts/` gemigreer. Kies Fabric (aanbeveel), NeoForge (terugval) of Forge (tans nie beskikbaar vir Minecraft 26.2 nie). `parameter-manager.bat` kan RAM, GUI/konsole, GC, `online-mode`, die banier en `AUTO_UPDATE_CHECK` instel. **Exit without saving** kanselleer sonder om veranderinge te stoor.

## Installasie en EULA

Jarock laai die gekose loader en vasgepinde bedienermods outomaties af. Die eerste lopie skep `server/eula.txt` en stop gewoonlik. Lees die Minecraft EULA en verander slegs indien jy instem `eula=false` na `eula=true`. Moenie `online-mode=false` voor die eerste suksesvolle lopie stel nie; gebruik eers `online-mode=true`.

## Veilige afskakeling

Begin `start-server.bat` weer. Laat wêreldskepping, Geyser en Floodgate volledig klaarmaak. Om te stop, tik `stop` in die bedienerkonsole en moenie die venster sluit nie. Wag vir `CLEAN SHUTDOWN COMPLETE` en `SAFE TO CLOSE`; eers daarna is dit veilig om die venster te sluit.

## Na die eerste begin

As Java ontbreek, installeer 64-bis Java 25 en heropen die terminale. Vir netwerk- of aflaaifoute, lees die voorgestelde oplossing en probeer weer. As Fabric en NeoForge gemeng is, maak 'n rugsteun, voer `clean-server-runtime.bat` uit en kies een loader. Hou `online-mode=true` vir normale veilige gebruik en lees `TODO.md` voor openbare toegang.

## Veiligheidsnota

Vir 'n opdatering, stop veilig en voer `scripts/update-jarock.bat` uit.

<!-- jarock-lan-addresses-af -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.
