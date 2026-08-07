# מדריך רשת, חומת אש ונתב

התקן Java 25 64-bit, הרץ `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` והשלם את `TODO.md` לפני פתיחת פורטים. קבע IP LAN קבוע, פתח TCP `25565` (Java) ו-UDP `19132` (Bedrock) בחומת האש של Windows, קבע העברת פורטים בנתב או השתמש במנהרת UDP כמו playit.gg. וודא `online-mode=true` ו-`white-list=true` ולעולם אל תפרסם את `key.pem`. עבור CGNAT השתמש במנהרה. ראה [מדריך באנגלית](../en/network-and-ports.md).

> השתמש תמיד ב-`start-server.bat`; אל תלחץ פעמיים על `server.jar`.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## כיבוי בטוח

> הקלד `stop` והשאר את החלון פתוח. המתן ל-`CLEAN SHUTDOWN COMPLETE` ולאחר מכן ל-`SAFE TO CLOSE` לפני הסגירה. אם ההודעה השנייה חסרה, בדוק את היומן ואת דוח הקריסה ושחזר גיבוי לפי הצורך.

<!-- jarock-updater -->


## עדכון Jarock

> קרא את `scripts/version.txt`, עצור את השרת והמתן ל-`SAFE TO CLOSE`; לאחר מכן הפעל `scripts/update-jarock.bat`. הוא מחפש גרסה חדשה יותר באותו ערוץ בטא/יציב, מבקש אישור ויוצר גיבוי לחזרה. העולם, ה-runtime, המודים, הספריות וההגדרות המקומיות נשמרים; תלויות יתוקנו רק אם הן חסרות או לא תקינות.

> החבילה המלאה וסכום הבדיקה SHA-512 שפורסם עבורה נבדקים לפני ההתקנה.

<!-- jarock-auto-update-check -->

## בדיקת עדכונים בעת ההפעלה

הגדר AUTO_UPDATE_CHECK=true בתוך parameter-manager.bat כדי ש-start-server.bat יבצע בדיקת GitHub לקריאה בלבד. תוצג גרסה תואמת חדשה יותר, אך דבר לא יותקן אוטומטית. עצור את השרת, המתן ל-SAFE TO CLOSE והפעל scripts/update-jarock.bat. ברירת המחדל היא AUTO_UPDATE_CHECK=false.
