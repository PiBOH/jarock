# Guía de reserva NeoForge

Usa NeoForge só como último recurso cando Fabric non sexa axeitado. Forge e NeoForge son loaders distintos e os mods deben ser NeoForge; engade Geyser/Floodgate se cómpre e proba primeiro unha copia.

Consulta a guía completa en inglés: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

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
