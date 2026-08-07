# מדריך חלופי NeoForge

השתמש ב-NeoForge רק כמוצא אחרון כאשר Fabric אינו מתאים. Forge ו-NeoForge הם loaders שונים וה-mods חייבים להתאים ל-NeoForge; הוסף Geyser/Floodgate לפי הצורך ובדוק קודם עותק.

קרא את המדריך המלא באנגלית: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## כיבוי בטוח

> הקלד `stop` והשאר את החלון פתוח. המתן ל-`CLEAN SHUTDOWN COMPLETE` ולאחר מכן ל-`SAFE TO CLOSE` לפני הסגירה. אם ההודעה השנייה חסרה, בדוק את היומן ואת דוח הקריסה ושחזר גיבוי לפי הצורך.

<!-- jarock-updater -->


## עדכון Jarock

> קרא את `version.txt`, עצור את השרת והמתן ל-`SAFE TO CLOSE`; לאחר מכן הפעל `update-jarock.bat`. הוא מחפש גרסה חדשה יותר באותו ערוץ בטא/יציב, מבקש אישור ויוצר גיבוי לחזרה. העולם, ה-runtime, המודים, הספריות וההגדרות המקומיות נשמרים; תלויות יתוקנו רק אם הן חסרות או לא תקינות.

> החבילה המלאה וסכום הבדיקה SHA-512 שפורסם עבורה נבדקים לפני ההתקנה.

<!-- jarock-auto-update-check -->

## בדיקת עדכונים בעת ההפעלה

הגדר AUTO_UPDATE_CHECK=true בתוך parameter-manager.bat כדי ש-start-server.bat יבצע בדיקת GitHub לקריאה בלבד. תוצג גרסה תואמת חדשה יותר, אך דבר לא יותקן אוטומטית. עצור את השרת, המתן ל-SAFE TO CLOSE והפעל update-jarock.bat. ברירת המחדל היא AUTO_UPDATE_CHECK=false.
