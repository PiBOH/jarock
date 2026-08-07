# Jarock-ийн анхны ажиллуулалт

## Loader сонгох

64 битийн Java 25 буюу түүнээс шинэ JDK суулгаж, Temurin суулгагчид JAVA_HOME-г идэвхжүүлээд терминалыг дахин нээнэ үү. Үргэлж root дахь `start-server.bat` en `scripts/server-launch-settings.ini`-г ажиллуулж, `server/server.jar`-г шууд нээхгүй.

## Суулгалт ба EULA

`start-server.bat`-г ажиллуулаад Fabric (зөвлөмж), NeoForge (нөөц) эсвэл Forge (Minecraft 26.2-д одоогоор байхгүй)-г сонгоно. `parameter-manager.bat` нь RAM, GUI/console, GC, `online-mode`, banner болон `AUTO_UPDATE_CHECK`-г тохируулна. **Exit without saving** нь хадгалалгүй цуцална.

## Аюулгүй зогсоох

Jarock loader болон тогтоосон mod-уудыг автоматаар татна. Эхний ажиллуулалт `server/eula.txt` үүсгээд зогсоно. Minecraft EULA-г уншаад зөвшөөрсөн тохиолдолд л `eula=false`-г `eula=true` болгоно. Эхний амжилттай ажиллуулалтаас өмнө `online-mode=false` бүү ашигла.

## Аюулгүй зогсоох

Дахин ажиллуулж world, Geyser, Floodgate-г дуусгахыг хүлээнэ. `stop` бичээд `CLEAN SHUTDOWN COMPLETE`, `SAFE TO CLOSE` хүртэл цонхыг бүү хаа. Алдаанд Suggested fix-ийг дагаж, loader холилдвол нөөцлөөд `clean-server-runtime.bat` ажиллуулж, нийтэд нээхээс өмнө `TODO.md`-г унш.

## Аюулгүй байдлын тэмдэглэл

Ердийн баталгаажуулалт ажиллахын тулд эхний ажиллуулалтыг `online-mode=true`-тэй дуусгана уу.

## Аюулгүй байдлын тэмдэглэл

Шинэчлэлт суулгахын тулд серверийг аюулгүй зогсоогоод `scripts/update-jarock.bat` ажиллуулна уу.

<!-- jarock-lan-addresses-mn -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.
