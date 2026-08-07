# NeoForge rezerves rokasgrāmata

NeoForge izmantojiet tikai kā pēdējo iespēju, ja Fabric nav piemērots. Forge un NeoForge ir atšķirīgi loaderi, un modiem jāatbilst NeoForge; pievienojiet Geyser/Floodgate, ja vajag, un vispirms pārbaudiet kopiju.

Skatiet pilno angļu rokasgrāmatu: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## Droša apturēšana

> Ierakstiet `stop` un atstājiet logu atvērtu. Pirms aizvēršanas gaidiet `CLEAN SHUTDOWN COMPLETE` un pēc tam `SAFE TO CLOSE`. Ja otrais ziņojums neparādās, pārbaudiet žurnālu un avārijas ziņojumu un vajadzības gadījumā atjaunojiet dublējumu.

<!-- jarock-updater -->


## Jarock atjaunināšana

> Izlasiet `scripts/version.txt`, apturiet serveri un gaidiet `SAFE TO CLOSE`; pēc tam palaidiet `scripts/update-jarock.bat`. Tas meklē jaunāku tās pašas beta/stabilā kanāla versiju, lūdz apstiprinājumu un izveido atcelšanas dublējumu. Pasaule, runtime, modifikācijas, bibliotēkas un lokālie iestatījumi tiek saglabāti; atkarības labo tikai tad, ja tās trūkst vai ir nederīgas.

> Pilnā pakotne un tās publicētā SHA-512 kontrolsumma tiek pārbaudīta pirms instalēšanas.

<!-- jarock-auto-update-check -->

## Atjauninājumu pārbaude palaišanas laikā

Iestatiet AUTO_UPDATE_CHECK=true failā parameter-manager.bat, lai start-server.bat veiktu tikai lasāmu GitHub pārbaudi. Tiks ziņots par saderīgu jaunāku Jarock versiju, bet nekas netiks instalēts automātiski. Apturiet serveri, uzgaidiet SAFE TO CLOSE un palaidiet scripts/update-jarock.bat. Noklusējums ir AUTO_UPDATE_CHECK=false.
