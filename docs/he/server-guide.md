# מדריך שרת Fabric

התקן Java 25 ‏64-bit, הפעל `start-server.bat` והשתמש ב-`parameter-manager.bat` להגדרת RAM ו-GUI או `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) קרא את `server/eula.txt`, אשר את ה-EULA והגדר `eula=true`; השתמש ב-Fabric, Geyser-Fabric ו-Floodgate-Fabric וצור גיבויים. Jarock אינו משנה נתב, firewall או port forwarding.

קרא את המדריך המלא באנגלית: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **הערה טכנית: יש להשתמש תמיד ב־`start-server.bat` שבתיקיית השורש של המאגר. אין ללחוץ פעמיים על `server.jar`; Windows עלול להשתמש ב־Java 8 או Java 21, בעוד Minecraft 26.2 דורש Java 25+ ‏64-bit. ראו את [המדריך המלא באנגלית](../en/server-guide.md).**
