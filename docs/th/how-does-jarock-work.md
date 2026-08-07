# Jarock ทำงานอย่างไร?

## คำอธิบายเซิร์ฟเวอร์แบบเข้าใจง่าย

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Loader:** Fabric
**แพลตฟอร์มหลัก:** Windows 10/11

เอกสารนี้อธิบายว่าเกิดอะไรขึ้นหลังจากดาวน์โหลด Jarock


> DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **หมายเหตุการบำรุงรักษา:** ตัวเปิดใช้งานจะค้นหา Java 25+ แบบ 64 บิตที่เข้ากันได้ แทนการเชื่อถือเฉพาะ `java.exe` ตัวแรกใน `PATH` ใช้ `scripts/java-runtime.ps1` บันทึกไฟล์ที่เลือกไว้ใน `server/java-path.txt` และตรวจสอบก่อนเริ่มทำงาน สามารถติดตั้ง Java 8 ไว้ได้

## 1. สรุป

ผู้ใช้ติดตั้ง Java แบบ 64-bit ดาวน์โหลด repository นี้ แล้วเรียกใช้ `start-server.bat` โปรแกรมจะค้นหาโฟลเดอร์ของตัวเอง ตรวจสอบ Java และ path ขอเปิดใช้ long path ของ Windows เมื่อจำเป็น ดาวน์โหลด Fabric installer และ mods ที่กำหนดไว้ แล้วตรวจสอบทุกไฟล์ด้วย SHA-512

Fabric สร้าง runtime ใน `server/` การทำงานครั้งแรกจะสร้าง `server/eula.txt` โดยมีค่า `eula=false` แล้วหยุด ผู้ใช้ต้องอ่าน <https://www.minecraft.net/eula> เปลี่ยนเป็น `eula=true` หากยอมรับ แล้วเรียกใช้อีกครั้ง Geyser แปลงการรับส่งข้อมูล Bedrock และ Floodgate จัดการการยืนยันตัวตน Bedrock

Jarock **ไม่** ตั้งค่า router, firewall หรือ port forwarding

## 2. ไฟล์และลำดับการทำงาน

Repository มี scripts, templates และ manifest แต่ไม่มีโลกหรือไฟล์ `.jar` ที่สร้างขึ้น:

```text
start-server.bat
scripts/bootstrap-server.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
version.txt
CHANGELOG.md
TODO.md
```

Runtime ถูกสร้างใน `server/` โดย Git จะไม่ติดตาม world, logs, libraries, private keys และรายการภายในเครื่อง

`start-server.bat` ใช้ตำแหน่งของตัวเอง ไม่ได้ใช้ path คงที่อย่าง `C:\MinecraftServer` จึงรองรับ path ที่เข้าถึงได้ซึ่งมีช่องว่าง Unicode `!` และโฟลเดอร์ซ้อนกัน สำหรับ path ที่ยาวจะตรวจสอบ:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

หากจำเป็น จะขอสิทธิ์ administrator และเรียก `scripts\enable-long-paths.ps1` การเปลี่ยนแปลงนี้มีผลทั้งเครื่อง และโปรแกรมรุ่นเก่าอาจต้อง restart Windows

## 3. EULA, Geyser และข้อผิดพลาด

การทำงานครั้งแรกจะสร้าง `server/eula.txt` ด้วย `eula=false` แล้วหยุด อ่าน EULA เปลี่ยนเป็น `eula=true` หากยอมรับ แล้วเรียกใช้อีกครั้ง

Geyser สร้าง configuration แบบสมบูรณ์ในการเริ่มเซิร์ฟเวอร์จริงครั้งแรก หลังจากมีไฟล์นี้:

```text
server\config\Geyser-Fabric\config.yml
```

script จะตั้งค่า:

```yaml
auth-type: floodgate
```

Java โดยทั่วไปใช้ TCP `25565` และ Bedrock ใช้ UDP `19132` Jarock ไม่เปิด port ใด ๆ `key.pem` เป็นข้อมูลลับและห้ามเผยแพร่

เมื่อเกิดข้อผิดพลาด ให้อ่าน `ERROR:` หรือ `WARNING:` และทำตาม `Suggested fix:` หาก Java ปิดตัว ให้ตรวจสอบ `Caused by:` รายการแรกใน `server\logs\latest.log` หรือ `server\crash-reports\` งานที่เหลืออยู่ใน `TODO.md`

> **หมายเหตุทางเทคนิค: ใช้ `start-server.bat` ที่อยู่ในโฟลเดอร์รากของ repository เสมอ อย่าดับเบิลคลิก `server.jar` เพราะ Windows อาจใช้ Java 8 หรือ Java 21 ขณะที่ Minecraft 26.2 ต้องใช้ Java 25+ แบบ 64 บิต ดู[คู่มือภาษาอังกฤษฉบับเต็ม](../en/how-does-jarock-work.md)**

<!-- jarock-safe-shutdown -->

## การปิดอย่างปลอดภัย

> พิมพ์ `stop` และเปิดหน้าต่างไว้ รอ `CLEAN SHUTDOWN COMPLETE` แล้วจึงรอ `SAFE TO CLOSE` ก่อนปิดหน้าต่าง หากไม่มีข้อความที่สอง ให้ตรวจสอบล็อกและรายงานการแครช และกู้คืนข้อมูลสำรองหากจำเป็น

<!-- jarock-updater -->


## อัปเดต Jarock

> อ่าน `version.txt` หยุดเซิร์ฟเวอร์และรอ `SAFE TO CLOSE` จากนั้นเรียกใช้ `update-jarock.bat` โปรแกรมจะค้นหารุ่นใหม่ในช่อง beta/stable เดียวกัน ขอการยืนยันและสร้างข้อมูลสำรองสำหรับย้อนกลับ โลก runtime ม็อด ไลบรารี และการตั้งค่าจะถูกเก็บไว้ และจะแก้ไข dependency เฉพาะเมื่อขาดหายหรือไม่ถูกต้อง

> แพ็กเกจเต็มและค่า checksum SHA-512 ที่เผยแพร่จะถูกตรวจสอบก่อนติดตั้ง
