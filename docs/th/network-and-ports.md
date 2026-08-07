# คู่มือเครือข่าย ไฟร์วอลล์ และเราเตอร์

ติดตั้ง Java 25 แบบ 64-bit รัน `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` และทำ `TODO.md` ให้เสร็จก่อนเปิดพอร์ต กำหนด IP LAN แบบคงที่ เปิด TCP `25565` (Java) และ UDP `19132` (Bedrock) ในไฟร์วอลล์ Windows ตั้งค่าการส่งต่อพอร์ตบนเราเตอร์ หรือใช้ทันเนลที่รองรับ UDP เช่น playit.gg ตรวจสอบว่า `online-mode=true` และ `white-list=true` เปิดใช้งานอยู่ และห้ามเผยแพร่ `key.pem` โดยเด็ดขาด สำหรับ CGNAT ให้ใช้ทันเนล ดู[คู่มือภาษาอังกฤษ](../en/network-and-ports.md)

> ใช้ `start-server.bat` เสมอ อย่าดับเบิลคลิก `server.jar`

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## การปิดอย่างปลอดภัย

> พิมพ์ `stop` และเปิดหน้าต่างไว้ รอ `CLEAN SHUTDOWN COMPLETE` แล้วจึงรอ `SAFE TO CLOSE` ก่อนปิดหน้าต่าง หากไม่มีข้อความที่สอง ให้ตรวจสอบล็อกและรายงานการแครช และกู้คืนข้อมูลสำรองหากจำเป็น

<!-- jarock-updater -->


## อัปเดต Jarock

> อ่าน `version.txt` หยุดเซิร์ฟเวอร์และรอ `SAFE TO CLOSE` จากนั้นเรียกใช้ `update-jarock.bat` โปรแกรมจะค้นหารุ่นใหม่ในช่อง beta/stable เดียวกัน ขอการยืนยันและสร้างข้อมูลสำรองสำหรับย้อนกลับ โลก runtime ม็อด ไลบรารี และการตั้งค่าจะถูกเก็บไว้ และจะแก้ไข dependency เฉพาะเมื่อขาดหายหรือไม่ถูกต้อง

> แพ็กเกจเต็มและค่า checksum SHA-512 ที่เผยแพร่จะถูกตรวจสอบก่อนติดตั้ง
