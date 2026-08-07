# מדריך שרת Fabric

התקן Java 25 ‏64-bit, הפעל `start-server.bat` והשתמש ב-`parameter-manager.bat` להגדרת RAM ו-GUI או `nogui`. (enable "Set JAVA_HOME variable" in the Temurin installer) קרא את `server/eula.txt`, אשר את ה-EULA והגדר `eula=true`; השתמש ב-Fabric, Geyser-Fabric ו-Floodgate-Fabric וצור גיבויים. Jarock אינו משנה נתב, firewall או port forwarding.

קרא את המדריך המלא באנגלית: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **הערה טכנית: יש להשתמש תמיד ב־`start-server.bat` שבתיקיית השורש של המאגר. אין ללחוץ פעמיים על `server.jar`; Windows עלול להשתמש ב־Java 8 או Java 21, בעוד Minecraft 26.2 דורש Java 25+ ‏64-bit. ראו את [המדריך המלא באנגלית](../en/server-guide.md).**

<!-- jarock-safe-shutdown -->

## כיבוי בטוח

> הקלד `stop` והשאר את החלון פתוח. המתן ל-`CLEAN SHUTDOWN COMPLETE` ולאחר מכן ל-`SAFE TO CLOSE` לפני הסגירה. אם ההודעה השנייה חסרה, בדוק את היומן ואת דוח הקריסה ושחזר גיבוי לפי הצורך.

<!-- jarock-updater -->


## עדכון Jarock

> קרא את `version.txt`, עצור את השרת והמתן ל-`SAFE TO CLOSE`; לאחר מכן הפעל `update-jarock.bat`. הוא מחפש גרסה חדשה יותר באותו ערוץ בטא/יציב, מבקש אישור ויוצר גיבוי לחזרה. העולם, ה-runtime, המודים, הספריות וההגדרות המקומיות נשמרים; תלויות יתוקנו רק אם הן חסרות או לא תקינות.

> החבילה המלאה וסכום הבדיקה SHA-512 שפורסם עבורה נבדקים לפני ההתקנה.
