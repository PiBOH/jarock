# Jarock хэрхэн ажилладаг вэ?

## Серверийн энгийн тайлбар

**Одоогийн хувилбар:** `0.0.2-alpha`  
**Minecraft:** Java Edition `26.2`  
**Loader:** Fabric  
**Үндсэн платформ:** Windows 10/11

Энэ баримт нь Jarock-ийг татсаны дараа юу болдгийг тайлбарлана.

## 1. Товчоор

Хэрэглэгч 64-бит Java суулгана, энэ repository-г татаж аваад `start-server.bat`-ийг ажиллуулна. Програм өөрийн хавтсыг олж, Java болон замыг шалгана. Шаардлагатай бол Windows-ийн урт замын дэмжлэгийг идэвхжүүлэхийг хүснэ. Дараа нь тогтоосон Fabric installer болон mods-ийг татаж, файл бүрийг SHA-512-оор шалгана.

Fabric runtime-ийг `server/` дотор үүсгэнэ. Эхний ажиллуулалтаар `server/eula.txt` файлыг `eula=false` утгатай үүсгээд зогсоно. Хэрэглэгч <https://www.minecraft.net/eula>-г уншиж, зөвшөөрвөл `eula=true` болгож дахин ажиллуулна. Geyser нь Bedrock-ийн урсгалыг хөрвүүлж, Floodgate нь Bedrock баталгаажуулалтыг хариуцна.

Jarock нь router, firewall эсвэл port forwarding-ийг **тохируулахгүй**.

## 2. Файл ба урсгал

Repository нь scripts, загварууд болон manifest агуулдаг боловч world эсвэл үүссэн `.jar` файлуудыг агуулдаггүй:

```text
start-server.bat
scripts/bootstrap-fabric.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
version.txt
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