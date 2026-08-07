# คู่มือเซิร์ฟเวอร์ Fabric

ติดตั้ง Java 25 แบบ 64 บิต เรียกใช้ `start-server.bat` และใช้ `parameter-manager.bat` ตั้งค่า RAM กับ GUI หรือ `nogui` อ่าน `server/eula.txt` ยอมรับ EULA แล้วตั้ง `eula=true`; ใช้ Fabric, Geyser-Fabric และ Floodgate-Fabric ทำ backup และ Jarock ไม่แก้เราเตอร์ ไฟร์วอลล์ หรือ port forwarding (enable "Set JAVA_HOME variable" in the Temurin installer)

ดูคู่มือภาษาอังกฤษฉบับเต็ม: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> **หมายเหตุทางเทคนิค: ใช้ `start-server.bat` ที่อยู่ในโฟลเดอร์รากของ repository เสมอ อย่าดับเบิลคลิก `server.jar` เพราะ Windows อาจใช้ Java 8 หรือ Java 21 ขณะที่ Minecraft 26.2 ต้องใช้ Java 25+ แบบ 64 บิต ดู[คู่มือภาษาอังกฤษฉบับเต็ม](../en/server-guide.md)**
