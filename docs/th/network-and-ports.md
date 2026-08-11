# คู่มือเครือข่าย ไฟร์วอลล์ และเราเตอร์

ติดตั้ง Java 25 แบบ 64-bit รัน `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` และทำ `TODO.md` ให้เสร็จก่อนเปิดพอร์ต กำหนด IP LAN แบบคงที่ เปิด TCP `25565` (Java) และ UDP `19132` (Bedrock) ในไฟร์วอลล์ Windows ตั้งค่าการส่งต่อพอร์ตบนเราเตอร์ หรือใช้ทันเนลที่รองรับ UDP เช่น playit.gg ตรวจสอบว่า `online-mode=true` และ `white-list=true` เปิดใช้งานอยู่ และห้ามเผยแพร่ `key.pem` โดยเด็ดขาด สำหรับ CGNAT ให้ใช้ทันเนล ดู[คู่มือภาษาอังกฤษ](../en/network-and-ports.md)

> ใช้ `start-server.bat` เสมอ อย่าดับเบิลคลิก `server.jar`

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

<!-- jarock-safe-shutdown -->

## การปิดอย่างปลอดภัย

> พิมพ์ `stop` และเปิดหน้าต่างไว้ รอ `CLEAN SHUTDOWN COMPLETE` แล้วจึงรอ `SAFE TO CLOSE` ก่อนปิดหน้าต่าง หากไม่มีข้อความที่สอง ให้ตรวจสอบล็อกและรายงานการแครช และกู้คืนข้อมูลสำรองหากจำเป็น
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## อัปเดต Jarock

> อ่าน `scripts/version.txt` หยุดเซิร์ฟเวอร์และรอ `SAFE TO CLOSE` จากนั้นเรียกใช้ `scripts/update-jarock.bat` โปรแกรมจะค้นหารุ่นใหม่ในช่อง beta/stable เดียวกัน ขอการยืนยันและสร้างข้อมูลสำรองสำหรับย้อนกลับ โลก runtime ม็อด ไลบรารี และการตั้งค่าจะถูกเก็บไว้ และจะแก้ไข dependency เฉพาะเมื่อขาดหายหรือไม่ถูกต้อง

> แพ็กเกจเต็มและค่า checksum SHA-512 ที่เผยแพร่จะถูกตรวจสอบก่อนติดตั้ง

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## ตรวจสอบการอัปเดตเมื่อเริ่มต้น

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified package matching scripts/jarock-edition.ini automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **การป้องกันการปิดคอนโซล Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. พิมพ์ stop และรอ SAFE TO CLOSE ห้ามบังคับปิดขณะบันทึกโลก Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
