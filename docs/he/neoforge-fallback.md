# מדריך חלופי NeoForge

השתמש ב-NeoForge רק כמוצא אחרון כאשר Fabric אינו מתאים. Forge ו-NeoForge הם loaders שונים וה-mods חייבים להתאים ל-NeoForge; הוסף Geyser/Floodgate לפי הצורך ובדוק קודם עותק.

קרא את המדריך המלא באנגלית: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## כיבוי בטוח

> הקלד `stop` והשאר את החלון פתוח. המתן ל-`CLEAN SHUTDOWN COMPLETE` ולאחר מכן ל-`SAFE TO CLOSE` לפני הסגירה. אם ההודעה השנייה חסרה, בדוק את היומן ואת דוח הקריסה ושחזר גיבוי לפי הצורך.

<!-- jarock-updater -->


## עדכון Jarock

> קרא את `scripts/version.txt`, עצור את השרת והמתן ל-`SAFE TO CLOSE`; לאחר מכן הפעל `scripts/update-jarock.bat`. הוא מחפש גרסה חדשה יותר באותו ערוץ בטא/יציב, מבקש אישור ויוצר גיבוי לחזרה. העולם, ה-runtime, המודים, הספריות וההגדרות המקומיות נשמרים; תלויות יתוקנו רק אם הן חסרות או לא תקינות.

> החבילה המלאה וסכום הבדיקה SHA-512 שפורסם עבורה נבדקים לפני ההתקנה.

<!-- jarock-auto-update-check -->

## בדיקת עדכונים בעת ההפעלה

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **הגנה מפני סגירת מסוף Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. הקלד stop והמתן ל-SAFE TO CLOSE. לעולם אל תסגור בכוח בזמן שמירת העולם. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
