# Záložní průvodce NeoForge

NeoForge je poslední možnost, když Fabric nevyhovuje. Forge a NeoForge jsou různé loadery; mody musí být pro NeoForge. Podle potřeby přidejte Geyser/Floodgate a nejprve testujte kopii.

See the [English NeoForge fallback guide](../en/neoforge-fallback.md) for the complete procedure. Verify every mod against the selected loader.

<!-- jarock-safe-shutdown -->

## Bezpečné vypnutí

> Napište `stop` do konzole a nechte okno otevřené. Před zavřením počkejte na `CLEAN SHUTDOWN COMPLETE` a potom `SAFE TO CLOSE`. Pokud druhá zpráva chybí, zkontrolujte log a hlášení pádu a podle potřeby obnovte zálohu.

<!-- jarock-updater -->


## Aktualizace Jarock

> Přečtěte `scripts/version.txt`, zastavte server a počkejte na `SAFE TO CLOSE`; potom spusťte `scripts/update-jarock.bat`. Vyhledá novější verzi ve stejném beta/stabilním kanálu, vyžádá potvrzení a vytvoří zálohu pro návrat. Svět, runtime, mody, knihovny a místní nastavení zůstanou zachovány; závislosti se obnoví jen při chybění nebo neplatnosti.

> Úplný balíček a jeho zveřejněný kontrolní součet SHA-512 se před instalací ověří.

<!-- jarock-auto-update-check -->

## Kontrola aktualizací při spuštění

Nastav AUTO_UPDATE_CHECK=true v parameter-manager.bat, aby start-server.bat provedl kontrolu vydání GitHub pouze pro čtení. Oznámí kompatibilní novější verzi, ale nic nenainstaluje automaticky. Bezpečně server zastav, počkej na SAFE TO CLOSE a spusť scripts/update-jarock.bat. Výchozí hodnota je AUTO_UPDATE_CHECK=false.
