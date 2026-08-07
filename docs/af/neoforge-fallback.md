# NeoForge-terugvalgids

Gebruik NeoForge net as Fabric die vereiste mod nie het nie. Forge en NeoForge is verskillende laaiers; mods moet by NeoForge pas. Voeg Geyser/Floodgate indien nodig by, en toets eers ’n rugsteun.

See the [English NeoForge fallback guide](../en/neoforge-fallback.md) for the complete procedure. Verify every mod against the selected loader.

<!-- jarock-safe-shutdown -->

## Veilige afsluiting

> Tik `stop` in die bedienerkonsole en laat die venster oop. Wag vir `CLEAN SHUTDOWN COMPLETE` en daarna `SAFE TO CLOSE` voordat jy dit sluit. As die tweede boodskap ontbreek, lees die log en crash-verslag en herstel ’n rugsteun indien nodig.

<!-- jarock-updater -->


## Jarock-bywerking

> Lees `scripts/version.txt`, stop die bediener en wag vir `SAFE TO CLOSE`; voer dan `scripts/update-jarock.bat` uit. Dit soek ’n nuwer vrystelling in dieselfde beta/stabiele kanaal, vra bevestiging en maak ’n terugrolrugsteun. Die wêreld, runtime, mods, biblioteke en plaaslike instellings bly behoue; afhanklikhede word net herstel as hulle ontbreek of ongeldig is.

> Die volledige pakket en sy gepubliseerde SHA-512-kontrolesom word voor installasie nagegaan.

<!-- jarock-auto-update-check -->

## Kontrole vir opdaterings tydens opstart

Stel AUTO_UPDATE_CHECK=true in parameter-manager.bat sodat start-server.bat tydens opstart 'n leesalleen-GitHub-kontrole uitvoer. Dit meld 'n versoenbare nuwer Jarock-weergawe, vra eers bevestiging voordat dit installeer. Kies y of tik yes om die Lite-opdatering te installeer, of N/Enter om voort te gaan met die huidige weergawe. Die verstek is AUTO_UPDATE_CHECK=false. When a compatible newer release is found at startup, Jarock asks `Download and install it now? (y/N)`; choose y to install the verified Lite package, or N/Enter to continue with the current version. It never updates silently.
