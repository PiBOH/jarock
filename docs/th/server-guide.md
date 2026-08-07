# คู่มือเซิร์ฟเวอร์ Fabric

ติดตั้ง Java 25 แบบ 64 บิต เรียกใช้ `start-server.bat` และใช้ `parameter-manager.bat` ตั้งค่า RAM กับ GUI หรือ `nogui` อ่าน `server/eula.txt` ยอมรับ EULA แล้วตั้ง `eula=true`; ใช้ Fabric, Geyser-Fabric และ Floodgate-Fabric ทำ backup และ Jarock ไม่แก้เราเตอร์ ไฟร์วอลล์ หรือ port forwarding (enable "Set JAVA_HOME variable" in the Temurin installer)

ดูคู่มือภาษาอังกฤษฉบับเต็ม: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **หมายเหตุทางเทคนิค: ใช้ `start-server.bat` ที่อยู่ในโฟลเดอร์รากของ repository เสมอ อย่าดับเบิลคลิก `server.jar` เพราะ Windows อาจใช้ Java 8 หรือ Java 21 ขณะที่ Minecraft 26.2 ต้องใช้ Java 25+ แบบ 64 บิต ดู[คู่มือภาษาอังกฤษฉบับเต็ม](../en/server-guide.md)**

<!-- jarock-safe-shutdown -->

## การปิดอย่างปลอดภัย

> พิมพ์ `stop` และเปิดหน้าต่างไว้ รอ `CLEAN SHUTDOWN COMPLETE` แล้วจึงรอ `SAFE TO CLOSE` ก่อนปิดหน้าต่าง หากไม่มีข้อความที่สอง ให้ตรวจสอบล็อกและรายงานการแครช และกู้คืนข้อมูลสำรองหากจำเป็น

<!-- jarock-updater -->


## อัปเดต Jarock

> อ่าน `version.txt` หยุดเซิร์ฟเวอร์และรอ `SAFE TO CLOSE` จากนั้นเรียกใช้ `update-jarock.bat` โปรแกรมจะค้นหารุ่นใหม่ในช่อง beta/stable เดียวกัน ขอการยืนยันและสร้างข้อมูลสำรองสำหรับย้อนกลับ โลก runtime ม็อด ไลบรารี และการตั้งค่าจะถูกเก็บไว้ และจะแก้ไข dependency เฉพาะเมื่อขาดหายหรือไม่ถูกต้อง

> แพ็กเกจเต็มและค่า checksum SHA-512 ที่เผยแพร่จะถูกตรวจสอบก่อนติดตั้ง

<!-- jarock-auto-update-check -->

## ตรวจสอบการอัปเดตเมื่อเริ่มต้น

ตั้งค่า AUTO_UPDATE_CHECK=true ใน parameter-manager.bat เพื่อให้ start-server.bat ตรวจสอบ GitHub แบบอ่านอย่างเดียว ระบบจะแจ้ง Jarock รุ่นใหม่ที่เข้ากันได้ แต่จะไม่ติดตั้งอัตโนมัติ ให้หยุดเซิร์ฟเวอร์ รอ SAFE TO CLOSE แล้วเรียกใช้ update-jarock.bat ค่าเริ่มต้นคือ AUTO_UPDATE_CHECK=false
