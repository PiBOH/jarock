# Сүлжээ, галт хана болон чиглүүлэгчийн гарын авлага

64-битийн Java 25 суулгаж, `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat`-г ажиллуулж, порт нээхээс өмнө `TODO.md`-г дуусгана уу. Тогтмол LAN IP оноож, Windows галт хананд TCP `25565` (Java) болон UDP `19132` (Bedrock)-г нээж, чиглүүлэгч дээр порт дамжуулалтыг тохируулж эсвэл playit.gg шиг UDP нийцтэй туннель ашиглана уу. `online-mode=true` ба `white-list=true` идэвхтэй эсэхийг шалгаж, `key.pem`-г хэзээ ч нийтэд бүү дэлгэ. CGNAT-д туннель ашиглана уу. [Англи гарын авлага](../en/network-and-ports.md)-г үзнэ үү.

> Үргэлж `start-server.bat`-г ашигла; `server.jar` дээр давхар бүү дар.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## Аюулгүй зогсоох

> `stop` гэж бичээд цонхыг нээлттэй үлдээнэ үү. Хаахаас өмнө `CLEAN SHUTDOWN COMPLETE`, дараа нь `SAFE TO CLOSE` гарч ирэхийг хүлээнэ үү. Хоёр дахь мэдэгдэл байхгүй бол лог, crash тайланг шалгаж шаардлагатай бол нөөц хуулбарыг сэргээнэ үү.

<!-- jarock-updater -->


## Jarock шинэчлэх

> `scripts/version.txt`-г уншиж, серверийг зогсоогоод `SAFE TO CLOSE` гарч ирэхийг хүлээнэ үү; дараа нь `scripts/update-jarock.bat`-г ажиллуулна. Ижил beta/тогтвортой сувгийн шинэ хувилбарыг хайж, баталгаажуулалт авч буцаах нөөц үүсгэнэ. Дэлхий, runtime, mod, сангууд болон дотоод тохиргоо хадгалагдана; хамаарлыг зөвхөн байхгүй эсвэл буруу үед засна.

> Бүтэн багц болон нийтэлсэн SHA-512 шалгах нийлбэрийг суулгахаас өмнө шалгана.

<!-- jarock-auto-update-check -->

## Эхлэх үед шинэчлэлт шалгах

Startup update modes: AUTO_UPDATE_MODE=auto checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.
