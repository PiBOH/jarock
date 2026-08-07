# Prima pornire Jarock

## Alegerea loaderului

Instalează un JDK Java 25+ pe 64 de biți, activează JAVA_HOME în instalatorul Temurin și redeschide terminalul. Folosește întotdeauna `start-server.bat` en `scripts/server-launch-settings.ini` din rădăcină și nu deschide direct `server/server.jar`.

## Instalare și EULA

Rulează `start-server.bat` și alege Fabric (recomandat), NeoForge (alternativă) sau Forge (indisponibil momentan pentru Minecraft 26.2). `parameter-manager.bat` configurează RAM, GUI/consolă, GC, `online-mode`, bannerul și `AUTO_UPDATE_CHECK`. **Exit without saving** anulează fără salvare.

## Oprire sigură

Jarock descarcă automat loaderul și modurile fixate. Prima rulare creează `server/eula.txt` și se oprește de obicei. Citește Minecraft EULA și schimbă `eula=false` în `eula=true` doar dacă accepți. Nu folosi `online-mode=false` înainte de prima rulare reușită.

## Oprire sigură

Rulează din nou, așteaptă lumea, Geyser și Floodgate, tastează `stop` și așteaptă `CLEAN SHUTDOWN COMPLETE` și `SAFE TO CLOSE`. Urmează Suggested fix la erori; dacă loaderele sunt amestecate, fă backup și rulează `clean-server-runtime.bat`. Citește `TODO.md` înainte de acces public.

## Notă de siguranță

Finalizează prima rulare cu `online-mode=true` pentru ca autentificarea normală să funcționeze.

## Notă de siguranță

Pentru a instala o actualizare, oprește serverul în siguranță și rulează `scripts/update-jarock.bat`.

<!-- jarock-lan-addresses-ro -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.
