# NeoForge-reservguide

Använd NeoForge endast som sista alternativ när Fabric inte passar. Forge och NeoForge är olika loaders och mods måste passa NeoForge; lägg till Geyser/Floodgate vid behov och testa först en kopia.

Se den fullständiga engelska guiden: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## Säker avstängning

> Skriv `stop` och låt fönstret vara öppet. Vänta på `CLEAN SHUTDOWN COMPLETE` och sedan `SAFE TO CLOSE` innan du stänger det. Om det andra meddelandet saknas, kontrollera loggen och kraschrapporten och återställ en säkerhetskopia vid behov.

<!-- jarock-updater -->


## Uppdatera Jarock

> Läs `scripts/version.txt`, stoppa servern och vänta på `SAFE TO CLOSE`; kör sedan `scripts/update-jarock.bat`. Den söker efter en nyare version i samma beta/stabila kanal, frågar efter bekräftelse och skapar en återställningskopia. Värld, runtime, moddar, bibliotek och lokala inställningar bevaras; beroenden repareras bara om de saknas eller är ogiltiga.

> Hela paketet och dess publicerade SHA-512-kontrollsumma verifieras före installationen.

<!-- jarock-auto-update-check -->

## Sök efter uppdateringar vid start

Ställ in AUTO_UPDATE_CHECK=true i parameter-manager.bat så att start-server.bat gör en skrivskyddad GitHub-kontroll. En kompatibel nyare Jarock-version rapporteras, men inget installeras automatiskt. Stoppa servern, vänta på SAFE TO CLOSE och kör scripts/update-jarock.bat. Standardvärdet är AUTO_UPDATE_CHECK=false.
