# การเริ่มต้น Jarock ครั้งแรก

## ก่อนเริ่มต้น

ติดตั้ง JDK Java 25 ขึ้นไปแบบ 64 บิต เปิดใช้งาน JAVA_HOME ในตัวติดตั้ง Temurin แล้วเปิด terminal ใหม่ ใช้ `start-server.bat` ที่ root เท่านั้น การตั้งค่าในเครื่องจะอยู่ที่ `scripts/server-launch-settings.ini` และอย่าเปิด `server/server.jar` โดยตรง

## เลือก loader

เรียกใช้ `start-server.bat` แล้วเลือก Fabric (แนะนำ), NeoForge (ทางเลือก) หรือ Forge (ยังไม่พร้อมสำหรับ Minecraft 26.2) ใช้ `parameter-manager.bat` ตั้งค่า RAM, GUI/console, GC, `online-mode`, แบนเนอร์ และ `AUTO_UPDATE_CHECK` โดย **Exit without saving** จะยกเลิกโดยไม่บันทึก

## การติดตั้งและ EULA

Jarock จะดาวน์โหลด loader และ mod ที่กำหนดไว้โดยอัตโนมัติ การเริ่มครั้งแรกจะสร้าง `server/eula.txt` แล้วหยุด อ่าน Minecraft EULA และเปลี่ยน `eula=false` เป็น `eula=true` เมื่อยอมรับเท่านั้น อย่าใช้ `online-mode=false` ก่อนการเริ่มครั้งแรกที่สำเร็จ และให้เริ่มครั้งแรกด้วย `online-mode=true`

## การหยุดอย่างปลอดภัย

เริ่มใหม่และรอให้ world, Geyser และ Floodgate โหลดเสร็จ พิมพ์ `stop` แล้วรอ `CLEAN SHUTDOWN COMPLETE` และ `SAFE TO CLOSE` ก่อนปิดหน้าต่าง หากมีข้อผิดพลาดให้ทำตาม Suggested fix หาก loader ปะปนให้สำรองข้อมูลแล้วเรียก `clean-server-runtime.bat` ติดตั้งการอัปเดตด้วย `scripts/update-jarock.bat` และอ่าน `TODO.md` ก่อนเปิดใช้งานสาธารณะ
