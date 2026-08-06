# คู่มือเครือข่าย ไฟร์วอลล์ และเราเตอร์

ติดตั้ง Java 25 แบบ 64-bit รัน `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` และทำ `TODO.md` ให้เสร็จก่อนเปิดพอร์ต กำหนด IP LAN แบบคงที่ เปิด TCP `25565` (Java) และ UDP `19132` (Bedrock) ในไฟร์วอลล์ Windows ตั้งค่าการส่งต่อพอร์ตบนเราเตอร์ หรือใช้ทันเนลที่รองรับ UDP เช่น playit.gg ตรวจสอบว่า `online-mode=true` และ `white-list=true` เปิดใช้งานอยู่ และห้ามเผยแพร่ `key.pem` โดยเด็ดขาด สำหรับ CGNAT ให้ใช้ทันเนล ดู[คู่มือภาษาอังกฤษ](../en/network-and-ports.md)

> ใช้ `start-server.bat` เสมอ อย่าดับเบิลคลิก `server.jar`
