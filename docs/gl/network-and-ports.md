# Guía de rede, firewall e router

Instala Java 25 de 64 bits, executa `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` e completa `TODO.md` antes de abrir portos. Asigna un IP LAN fixo, abre TCP `25565` (Java) e UDP `19132` (Bedrock) no firewall de Windows, configura o reenvío de portos no router ou usa un túnel UDP como playit.gg. Comproba `online-mode=true` e `white-list=true` e nunca publiques `key.pem`. Para CGNAT, usa un túnel. Consulta a [guía canónica en inglés](../en/network-and-ports.md).

> Usa sempre `start-server.bat`; non fagas dobre clic en `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Apagado seguro

> Escribe `stop` e deixa a xanela aberta. Agarda por `CLEAN SHUTDOWN COMPLETE` e despois `SAFE TO CLOSE` antes de pechala. Se falta a segunda mensaxe, revisa o rexistro e o informe de fallo e restaura unha copia se é preciso.

<!-- jarock-updater -->


## Actualizar Jarock

> Le `version.txt`, detén o servidor e agarda por `SAFE TO CLOSE`; despois executa `update-jarock.bat`. Busca unha versión máis nova da mesma canle beta/estable, pide confirmación e crea unha copia de recuperación. Conserva o mundo, runtime, mods, bibliotecas e configuración local; só repara dependencias ausentes ou inválidas.

> O paquete completo e a súa suma de comprobación SHA-512 publicada verifícanse antes da instalación.

<!-- jarock-auto-update-check -->

## Comprobación de actualizacións ao iniciar

Establece AUTO_UPDATE_CHECK=true en parameter-manager.bat para que start-server.bat comprobe GitHub en modo de só lectura. Informará dunha versión compatible máis recente, pero non instalará nada automaticamente. Detén o servidor, agarda por SAFE TO CLOSE e executa update-jarock.bat. O valor predeterminado é AUTO_UPDATE_CHECK=false.
