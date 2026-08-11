# Jarock ทำงานอย่างไร?

## คำอธิบายเซิร์ฟเวอร์แบบเข้าใจง่าย

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Loader:** Fabric
**แพลตฟอร์มหลัก:** Windows 10/11

เอกสารนี้อธิบายว่าเกิดอะไรขึ้นหลังจากดาวน์โหลด Jarock


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome Message 2.8 with its required Collective library is included as a verified server-side Minecraft 26.2 mod for Fabric and NeoForge; it sends configurable join messages.

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
scripts/version.txt
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

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> InvView 1.4.21 is a verified Minecraft 26.2 server-side Fabric mod. It requires Fabric API and lets authorized operators inspect and manage online or offline player inventories and ender chests; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> OfflineCommands 1.0.3 is a verified Minecraft 26.2 server-side Fabric mod for running commands on offline players. No compatible NeoForge 26.2 build is available, so NeoForge does not install it.

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
