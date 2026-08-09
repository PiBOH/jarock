# מדריך רשת, חומת אש ונתב

התקן Java 25 64-bit, הרץ `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` והשלם את `TODO.md` לפני פתיחת פורטים. קבע IP LAN קבוע, פתח TCP `25565` (Java) ו-UDP `19132` (Bedrock) בחומת האש של Windows, קבע העברת פורטים בנתב או השתמש במנהרת UDP כמו playit.gg. וודא `online-mode=true` ו-`white-list=true` ולעולם אל תפרסם את `key.pem`. עבור CGNAT השתמש במנהרה. ראה [מדריך באנגלית](../en/network-and-ports.md).

> השתמש תמיד ב-`start-server.bat`; אל תלחץ פעמיים על `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## כיבוי בטוח

> הקלד `stop` והשאר את החלון פתוח. המתן ל-`CLEAN SHUTDOWN COMPLETE` ולאחר מכן ל-`SAFE TO CLOSE` לפני הסגירה. אם ההודעה השנייה חסרה, בדוק את היומן ואת דוח הקריסה ושחזר גיבוי לפי הצורך.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## עדכון Jarock

> קרא את `scripts/version.txt`, עצור את השרת והמתן ל-`SAFE TO CLOSE`; לאחר מכן הפעל `scripts/update-jarock.bat`. הוא מחפש גרסה חדשה יותר באותו ערוץ בטא/יציב, מבקש אישור ויוצר גיבוי לחזרה. העולם, ה-runtime, המודים, הספריות וההגדרות המקומיות נשמרים; תלויות יתוקנו רק אם הן חסרות או לא תקינות.

> החבילה המלאה וסכום הבדיקה SHA-512 שפורסם עבורה נבדקים לפני ההתקנה.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## בדיקת עדכונים בעת ההפעלה

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **הגנה מפני סגירת מסוף Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. הקלד stop והמתן ל-SAFE TO CLOSE. לעולם אל תסגור בכוח בזמן שמירת העולם. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
