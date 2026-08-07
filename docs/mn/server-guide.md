# Fabric серверийн гарын авлага

64-бит Java 25 суулгаж, `start-server.bat` ажиллуулаад `parameter-manager.bat`-аар RAM болон GUI эсвэл `nogui` тохируулна. (enable "Set JAVA_HOME variable" in the Temurin installer) `server/eula.txt`-г уншиж EULA-г зөвшөөрөн `eula=true` болго; Fabric, Geyser-Fabric, Floodgate-Fabric ашиглаж нөөцлөлт хий, Jarock чиглүүлэгч, firewall, port forwarding өөрчлөхгүй.

Англи бүрэн гарын авлагыг үз: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Техникийн тэмдэглэл: Репозиторийн үндсэн хавтас дахь `start-server.bat`-ийг үргэлж ашигла. `server.jar` дээр давхар бүү дар; Windows Java 8 эсвэл Java 21 ашиглаж болох ч Minecraft 26.2-д 64-бит Java 25+ шаардлагатай. [Англи хэл дээрх бүрэн заавар](../en/server-guide.md)-ыг үз.**

<!-- jarock-safe-shutdown -->

## Аюулгүй зогсоох

> `stop` гэж бичээд цонхыг нээлттэй үлдээнэ үү. Хаахаас өмнө `CLEAN SHUTDOWN COMPLETE`, дараа нь `SAFE TO CLOSE` гарч ирэхийг хүлээнэ үү. Хоёр дахь мэдэгдэл байхгүй бол лог, crash тайланг шалгаж шаардлагатай бол нөөц хуулбарыг сэргээнэ үү.

<!-- jarock-updater -->


## Jarock шинэчлэх

> `version.txt`-г уншиж, серверийг зогсоогоод `SAFE TO CLOSE` гарч ирэхийг хүлээнэ үү; дараа нь `update-jarock.bat`-г ажиллуулна. Ижил beta/тогтвортой сувгийн шинэ хувилбарыг хайж, баталгаажуулалт авч буцаах нөөц үүсгэнэ. Дэлхий, runtime, mod, сангууд болон дотоод тохиргоо хадгалагдана; хамаарлыг зөвхөн байхгүй эсвэл буруу үед засна.

> Бүтэн багц болон нийтэлсэн SHA-512 шалгах нийлбэрийг суулгахаас өмнө шалгана.

<!-- jarock-auto-update-check -->

## Эхлэх үед шинэчлэлт шалгах

parameter-manager.bat дотор AUTO_UPDATE_CHECK=true тохируулснаар start-server.bat GitHub хувилбаруудыг зөвхөн унших горимоор шалгана. Тохирох шинэ Jarock хувилбарыг мэдээлэх боловч автоматаар суулгахгүй. Серверийг зогсоож SAFE TO CLOSE-ийг хүлээгээд update-jarock.bat ажиллуулна. Анхдагч утга AUTO_UPDATE_CHECK=false.
