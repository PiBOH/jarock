# NeoForge-terugvalgids

Gebruik NeoForge net as Fabric die vereiste mod nie het nie. Forge en NeoForge is verskillende laaiers; mods moet by NeoForge pas. Voeg Geyser/Floodgate indien nodig by, en toets eers ’n rugsteun.

See the [English NeoForge fallback guide](../en/neoforge-fallback.md) for the complete procedure. Verify every mod against the selected loader.

<!-- jarock-safe-shutdown -->

## Veilige afsluiting

> Tik `stop` in die bedienerkonsole en laat die venster oop. Wag vir `CLEAN SHUTDOWN COMPLETE` en daarna `SAFE TO CLOSE` voordat jy dit sluit. As die tweede boodskap ontbreek, lees die log en crash-verslag en herstel ’n rugsteun indien nodig.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Jarock-bywerking

> Lees `scripts/version.txt`, stop die bediener en wag vir `SAFE TO CLOSE`; voer dan `scripts/update-jarock.bat` uit. Dit soek ’n nuwer vrystelling in dieselfde beta/stabiele kanaal, vra bevestiging en maak ’n terugrolrugsteun. Die wêreld, runtime, mods, biblioteke en plaaslike instellings bly behoue; afhanklikhede word net herstel as hulle ontbreek of ongeldig is.

> Die volledige pakket en sy gepubliseerde SHA-512-kontrolesom word voor installasie nagegaan.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Kontrole vir opdaterings tydens opstart

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows-konsole-sluitbeskerming:** While Jarock is running, the classic Windows console may show a warning when X is clicked. Tik stop en wag vir SAFE TO CLOSE. Moet nooit forseer sluit terwyl die wêreld gestoor word nie. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
