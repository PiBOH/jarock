# Prvo pokretanje Jarocka

## Odabir loadera

Instaliraj 64-bitni JDK Java 25 ili noviji, uključi JAVA_HOME u Temurin instalaciji i ponovno otvori terminal. Uvijek pokreni korijenski `start-server.bat` en `scripts/server-launch-settings.ini` i ne otvaraj izravno `server/server.jar`.

## Instalacija i EULA

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

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

<!-- jarock-console-close-protection -->

> **Zaštita od zatvaranja Windows konzole:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Upišite stop i pričekajte SAFE TO CLOSE. Ne prisiljavajte zatvaranje dok se svijet sprema. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
