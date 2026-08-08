# Jarock хэрхэн ажилладаг вэ?

## Серверийн энгийн тайлбар

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Loader:** Fabric
**Үндсэн платформ:** Windows 10/11

Энэ баримт нь Jarock-ийг татсаны дараа юу болдгийг тайлбарлана.


> DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Засвар үйлчилгээний тэмдэглэл:** эхлүүлэгч нь `PATH` дахь эхний `java.exe`-д дангаар найдахгүй, нийцтэй 64-бит Java 25+ орчныг хайна. `scripts/java-runtime.ps1`-ийг ашиглаж, сонгосон гүйцэтгэх файлыг `server/java-path.txt`-д хадгалан эхлүүлэхийн өмнө шалгана. Java 8 суусан хэвээр байж болно.

## 1. Товчоор

Хэрэглэгч 64-бит Java суулгана, энэ repository-г татаж аваад `start-server.bat`-ийг ажиллуулна. Програм өөрийн хавтсыг олж, Java болон замыг шалгана. Шаардлагатай бол Windows-ийн урт замын дэмжлэгийг идэвхжүүлэхийг хүснэ. Дараа нь тогтоосон Fabric installer болон mods-ийг татаж, файл бүрийг SHA-512-оор шалгана.

Fabric runtime-ийг `server/` дотор үүсгэнэ. Эхний ажиллуулалтаар `server/eula.txt` файлыг `eula=false` утгатай үүсгээд зогсоно. Хэрэглэгч <https://www.minecraft.net/eula>-г уншиж, зөвшөөрвөл `eula=true` болгож дахин ажиллуулна. Geyser нь Bedrock-ийн урсгалыг хөрвүүлж, Floodgate нь Bedrock баталгаажуулалтыг хариуцна.

Jarock нь router, firewall эсвэл port forwarding-ийг **тохируулахгүй**.

## 2. Файл ба урсгал

Repository нь scripts, загварууд болон manifest агуулдаг боловч world эсвэл үүссэн `.jar` файлуудыг агуулдаггүй:

```text
start-server.bat
scripts/bootstrap-server.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
scripts/version.txt
CHANGELOG.md
TODO.md
```

Runtime нь `server/` дотор үүснэ. World, logs, library, private key болон локал жагсаалтыг Git үл тоомсорлоно.

`start-server.bat` нь `C:\MinecraftServer` шиг тогтмол зам бус өөрийн байрлалыг ашигладаг. Тиймээс зай, Unicode, `!` болон дотор нь хавтасласан боломжтой замуудыг дэмжинэ. Урт замд дараах утгыг шалгана:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

Шаардлагатай бол administrator эрх хүсэж, `scripts\enable-long-paths.ps1`-ийг ажиллуулна. Энэ нь бүх компьютерт үйлчлэх өөрчлөлт бөгөөд хуучин програмуудад Windows-ийг дахин асаах шаардлагатай байж болно.

## 3. EULA, Geyser ба алдаа

Эхний ажиллуулалт `server/eula.txt`-ийг `eula=false` утгатай үүсгээд зогсоно. EULA-г уншиж, зөвшөөрвөл `eula=true` болгож дахин ажиллуулна.

Geyser нь серверийн анхны бодит ажиллуулалтаар бүрэн тохиргоог үүсгэнэ. Дараах файл үүссэний дараа:

```text
server\config\Geyser-Fabric\config.yml
```

script нь:

```yaml
auth-type: floodgate
```

гэж тохируулна.

Java ихэвчлэн TCP `25565`, Bedrock UDP `19132` ашиглана. Jarock порт нээхгүй. `key.pem` нь нууц бөгөөд нийтэлж болохгүй.

Алдаа гарвал `ERROR:` эсвэл `WARNING:`-г уншиж, `Suggested fix:`-ийг дагана. Java зогсвол `server\logs\latest.log` эсвэл `server\crash-reports\` доторх эхний `Caused by:`-г шалгана. Үлдсэн ажлууд `TODO.md`-д байна.

> **Техникийн тэмдэглэл: Репозиторийн үндсэн хавтас дахь `start-server.bat`-ийг үргэлж ашигла. `server.jar` дээр давхар бүү дар; Windows Java 8 эсвэл Java 21 ашиглаж болох ч Minecraft 26.2-д 64-бит Java 25+ шаардлагатай. [Англи хэл дээрх бүрэн заавар](../en/how-does-jarock-work.md)-ыг үз.**

<!-- jarock-safe-shutdown -->

## Аюулгүй зогсоох

> `stop` гэж бичээд цонхыг нээлттэй үлдээнэ үү. Хаахаас өмнө `CLEAN SHUTDOWN COMPLETE`, дараа нь `SAFE TO CLOSE` гарч ирэхийг хүлээнэ үү. Хоёр дахь мэдэгдэл байхгүй бол лог, crash тайланг шалгаж шаардлагатай бол нөөц хуулбарыг сэргээнэ үү.

<!-- jarock-updater -->


## Jarock шинэчлэх

> `scripts/version.txt`-г уншиж, серверийг зогсоогоод `SAFE TO CLOSE` гарч ирэхийг хүлээнэ үү; дараа нь `scripts/update-jarock.bat`-г ажиллуулна. Ижил beta/тогтвортой сувгийн шинэ хувилбарыг хайж, баталгаажуулалт авч буцаах нөөц үүсгэнэ. Дэлхий, runtime, mod, сангууд болон дотоод тохиргоо хадгалагдана; хамаарлыг зөвхөн байхгүй эсвэл буруу үед засна.

> Бүтэн багц болон нийтэлсэн SHA-512 шалгах нийлбэрийг суулгахаас өмнө шалгана.

<!-- jarock-auto-update-check -->

## Эхлэх үед шинэчлэлт шалгах

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.
