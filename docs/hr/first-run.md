# Prvo pokretanje Jarocka

## Odabir loadera

Instaliraj 64-bitni JDK Java 25 ili noviji, uključi JAVA_HOME u Temurin instalaciji i ponovno otvori terminal. Uvijek pokreni korijenski `start-server.bat` en `scripts/server-launch-settings.ini` i ne otvaraj izravno `server/server.jar`.

## Instalacija i EULA

Pokreni `start-server.bat` i odaberi Fabric (preporučeno), NeoForge (rezervno) ili Forge (trenutačno nije dostupan za Minecraft 26.2). `parameter-manager.bat` podešava RAM, GUI/konzolu, GC, `online-mode`, banner i `AUTO_UPDATE_CHECK`. **Exit without saving** otkazuje bez spremanja.

## Sigurno zaustavljanje

Jarock automatski preuzima loader i zaključane modove. Prvo pokretanje stvara `server/eula.txt` i zaustavlja se. Pročitaj Minecraft EULA i promijeni `eula=false` u `eula=true` samo ako prihvaćaš. Ne koristi `online-mode=false` prije prvog uspješnog pokretanja.

## Sigurno zaustavljanje

Ponovno pokreni, pričekaj svijet, Geyser i Floodgate, upiši `stop` i čekaj `CLEAN SHUTDOWN COMPLETE` i `SAFE TO CLOSE`. Kod pogreške slijedi Suggested fix; ako su loaderi pomiješani, napravi sigurnosnu kopiju i pokreni `clean-server-runtime.bat`. Pročitaj `TODO.md` prije javnog pristupa.

## Sigurnosna napomena

Prvo pokretanje dovrši s `online-mode=true` kako bi normalna autentikacija radila.

## Sigurnosna napomena

Za instalaciju ažuriranja sigurno zaustavite poslužitelj i pokrenite `scripts/update-jarock.bat`.

<!-- jarock-lan-addresses-hr -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.
