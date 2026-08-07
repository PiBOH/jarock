# Ghid de rezervă NeoForge

Folosiți NeoForge doar ca ultimă opțiune dacă Fabric nu este potrivit. Forge și NeoForge sunt loadere diferite, iar modurile trebuie să fie pentru NeoForge; adăugați Geyser/Floodgate dacă este nevoie și testați mai întâi o copie.

Consultați ghidul complet în engleză: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## Oprire sigură

> Scrieți `stop` și lăsați fereastra deschisă. Înainte de închidere așteptați `CLEAN SHUTDOWN COMPLETE`, apoi `SAFE TO CLOSE`. Dacă al doilea mesaj lipsește, verificați jurnalul și raportul de eroare și restaurați o copie dacă este necesar.

<!-- jarock-updater -->


## Actualizarea Jarock

> Citiți `version.txt`, opriți serverul și așteptați `SAFE TO CLOSE`; apoi rulați `update-jarock.bat`. Caută o versiune mai nouă în același canal beta/stabil, cere confirmare și creează o copie pentru revenire. Lumea, runtime-ul, modurile, bibliotecile și setările locale sunt păstrate; dependențele sunt reparate doar dacă lipsesc sau sunt invalide.

> Pachetul complet și suma de verificare SHA-512 publicată sunt verificate înainte de instalare.
