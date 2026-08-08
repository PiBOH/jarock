# การเริ่มต้น Jarock ครั้งแรก

## ก่อนเริ่มต้น

ติดตั้ง JDK Java 25 ขึ้นไปแบบ 64 บิต เปิดใช้งาน JAVA_HOME ในตัวติดตั้ง Temurin แล้วเปิด terminal ใหม่ ใช้ `start-server.bat` ที่ root เท่านั้น การตั้งค่าในเครื่องจะอยู่ที่ `scripts/server-launch-settings.ini` และอย่าเปิด `server/server.jar` โดยตรง

## เลือก loader

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.

## การติดตั้งและ EULA

Jarock จะดาวน์โหลด loader และ mod ที่กำหนดไว้โดยอัตโนมัติ การเริ่มครั้งแรกจะสร้าง `server/eula.txt` แล้วหยุด อ่าน Minecraft EULA และเปลี่ยน `eula=false` เป็น `eula=true` เมื่อยอมรับเท่านั้น อย่าใช้ `online-mode=false` ก่อนการเริ่มครั้งแรกที่สำเร็จ และให้เริ่มครั้งแรกด้วย `online-mode=true`

## การหยุดอย่างปลอดภัย

เริ่มใหม่และรอให้ world, Geyser และ Floodgate โหลดเสร็จ พิมพ์ `stop` แล้วรอ `CLEAN SHUTDOWN COMPLETE` และ `SAFE TO CLOSE` ก่อนปิดหน้าต่าง หากมีข้อผิดพลาดให้ทำตาม Suggested fix หาก loader ปะปนให้สำรองข้อมูลแล้วเรียก `clean-server-runtime.bat` ติดตั้งการอัปเดตด้วย `scripts/update-jarock.bat` และอ่าน `TODO.md` ก่อนเปิดใช้งานสาธารณะ

<!-- jarock-lan-addresses-th -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.
