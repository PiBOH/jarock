# Vodnik za omrežje, požarni zid in usmerjevalnik

Namestite 64-bitno Javo 25, zaženite `start-server.bat` in dokončajte `TODO.md` pred odpiranjem vrat. Dodelite fiksni LAN IP, odprite TCP `25565` (Java) in UDP `19132` (Bedrock) v požarnem zidu Windows, konfigurirajte posredovanje vrat na usmerjevalniku ali uporabite UDP združljiv tunel, kot je playit.gg. Preverite `online-mode=true` in `white-list=true` in nikoli ne objavite `key.pem`. Za CGNAT uporabite tunel. Glejte [kanonični angleški vodnik](../en/network-and-ports.md). (abilita Set JAVA_HOME nell’installer Temurin) (enable "Set JAVA_HOME variable" in the Temurin installer)

> Vedno uporabite `start-server.bat`; ne dvokliknite `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.
