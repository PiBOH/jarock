# คู่มือทางเลือก NeoForge

ใช้ NeoForge เป็นทางเลือกสุดท้ายเมื่อ Fabric ไม่เหมาะสมเท่านั้น Forge และ NeoForge เป็น loader คนละแบบ และ mods ต้องตรงกับ NeoForge; เพิ่ม Geyser/Floodgate หากจำเป็นและทดสอบสำเนาก่อน

ดูคู่มือภาษาอังกฤษฉบับเต็ม: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## การปิดอย่างปลอดภัย

> พิมพ์ `stop` และเปิดหน้าต่างไว้ รอ `CLEAN SHUTDOWN COMPLETE` แล้วจึงรอ `SAFE TO CLOSE` ก่อนปิดหน้าต่าง หากไม่มีข้อความที่สอง ให้ตรวจสอบล็อกและรายงานการแครช และกู้คืนข้อมูลสำรองหากจำเป็น

<!-- jarock-updater -->


## อัปเดต Jarock

> อ่าน `scripts/version.txt` หยุดเซิร์ฟเวอร์และรอ `SAFE TO CLOSE` จากนั้นเรียกใช้ `scripts/update-jarock.bat` โปรแกรมจะค้นหารุ่นใหม่ในช่อง beta/stable เดียวกัน ขอการยืนยันและสร้างข้อมูลสำรองสำหรับย้อนกลับ โลก runtime ม็อด ไลบรารี และการตั้งค่าจะถูกเก็บไว้ และจะแก้ไข dependency เฉพาะเมื่อขาดหายหรือไม่ถูกต้อง

> แพ็กเกจเต็มและค่า checksum SHA-512 ที่เผยแพร่จะถูกตรวจสอบก่อนติดตั้ง

<!-- jarock-auto-update-check -->

## ตรวจสอบการอัปเดตเมื่อเริ่มต้น

ตั้งค่า AUTO_UPDATE_CHECK=true ใน parameter-manager.bat เพื่อให้ start-server.bat ตรวจสอบ GitHub แบบอ่านอย่างเดียว ระบบจะแจ้ง Jarock รุ่นใหม่ที่เข้ากันได้ แต่จะไม่ติดตั้งอัตโนมัติ ให้หยุดเซิร์ฟเวอร์ รอ SAFE TO CLOSE แล้วเรียกใช้ scripts/update-jarock.bat ค่าเริ่มต้นคือ AUTO_UPDATE_CHECK=false
