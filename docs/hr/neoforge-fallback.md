# NeoForge rezervni vodič

NeoForge je zadnja opcija ako Fabric ne odgovara. Forge i NeoForge su različiti loaderi; modovi moraju biti za NeoForge. Po potrebi dodaj Geyser/Floodgate i prvo testiraj kopiju.

See the [English NeoForge fallback guide](../en/neoforge-fallback.md) for the complete procedure. Verify every mod against the selected loader.

<!-- jarock-safe-shutdown -->

## Sigurno gašenje

> Upišite `stop` i ostavite prozor otvoren. Prije zatvaranja pričekajte `CLEAN SHUTDOWN COMPLETE`, a zatim `SAFE TO CLOSE`. Ako druga poruka nedostaje, provjerite zapisnik i izvještaj o padu te po potrebi vratite sigurnosnu kopiju.

<!-- jarock-updater -->


## Ažuriranje Jarocka

> Pročitajte `scripts/version.txt`, zaustavite poslužitelj i pričekajte `SAFE TO CLOSE`; zatim pokrenite `scripts/update-jarock.bat`. Traži noviju verziju istog beta/stabilnog kanala, traži potvrdu i stvara pričuvnu kopiju za povratak. Svijet, runtime, modovi, biblioteke i lokalne postavke ostaju sačuvani; ovisnosti se obnavljaju samo ako nedostaju ili nisu valjane.

> Potpuni paket i njegov objavljeni kontrolni zbroj SHA-512 provjeravaju se prije instalacije.

<!-- jarock-auto-update-check -->

## Provjera ažuriranja pri pokretanju

Postavi AUTO_UPDATE_CHECK=true u parameter-manager.bat kako bi start-server.bat izvršio GitHub provjeru samo za čitanje. Prijavit će kompatibilnu noviju verziju, ali ništa neće automatski instalirati. Sigurno zaustavi poslužitelj, pričekaj SAFE TO CLOSE i pokreni scripts/update-jarock.bat. Zadano je AUTO_UPDATE_CHECK=false.
