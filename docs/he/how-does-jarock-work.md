# איך Jarock עובד?

## הסבר פשוט על השרת

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**טוען:** Fabric
**פלטפורמה ראשית:** Windows 10/11

המסמך מסביר מה קורה לאחר הורדת Jarock.


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome Message 2.8 with its required Collective library is included as a verified server-side Minecraft 26.2 mod for Fabric and NeoForge; it sends configurable join messages.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **הערת תחזוקה:** מפעיל השרת מחפש כעת סביבת Java 25+ תואמת ב־64 סיביות במקום לסמוך רק על `java.exe` הראשון ב־`PATH`. הוא משתמש ב־`scripts/java-runtime.ps1`, שומר את קובץ ההפעלה שנבחר ב־`server/java-path.txt` ומאמת אותו לפני ההפעלה. ניתן להשאיר את Java 8 מותקנת.

## 1. בקצרה

המשתמש מתקין Java בגרסת 64-bit, מוריד את ה-repository ומפעיל את `start-server.bat`. התוכנית מוצאת את התיקייה שלה, בודקת את Java ואת הנתיב, מבקשת להפעיל תמיכה בנתיבים ארוכים של Windows כאשר צריך, מורידה את Fabric ואת ה-mods המקובעים ובודקת כל קובץ באמצעות SHA-512.

Fabric יוצר את סביבת הריצה בתוך `server/`. בהרצה הראשונה נוצר `server/eula.txt` עם `eula=false` והתהליך נעצר. יש לקרוא את <https://www.minecraft.net/eula>, לשנות ל-`eula=true` אם מסכימים ולהפעיל שוב. Geyser מתרגם תעבורת Bedrock ו-Floodgate מטפל באימות Bedrock.

Jarock **לא** מגדיר router, firewall או port forwarding.

## 2. קבצים וזרימה

ה-repository כולל scripts, תבניות ו-manifest, אך לא את העולם או קובצי `.jar` שנוצרים:

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

סביבת הריצה נוצרת ב-`server/`. Git מתעלם מעולמות, logs, ספריות, מפתחות פרטיים ורשימות מקומיות.

`start-server.bat` משתמש במיקום שלו ולא בנתיב קבוע כמו `C:\MinecraftServer`, ולכן תומך בנתיבים נגישים עם רווחים, Unicode, `!` ותיקיות מקוננות. עבור נתיבים ארוכים הוא בודק:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

אם צריך, הוא מבקש הרשאות administrator ומפעיל את `scripts\enable-long-paths.ps1`. השינוי חל על כל המחשב וייתכן שיידרש אתחול Windows.

## 3. EULA, Geyser ושגיאות

ההרצה הראשונה יוצרת `server/eula.txt` עם `eula=false` ונעצרת. קוראים את ה-EULA, משנים ל-`eula=true` אם מסכימים ומפעילים שוב.

Geyser יוצר את התצורה המלאה בהרצה האמיתית הראשונה. לאחר שנוצר:

```text
server\config\Geyser-Fabric\config.yml
```

הסקריפט מגדיר:

```yaml
auth-type: floodgate
```

Java משתמש בדרך כלל ב-TCP `25565` ו-Bedrock ב-UDP `19132`. Jarock אינו פותח פורטים. `key.pem` הוא פרטי ואסור לפרסם אותו.

אחרי שגיאה קוראים את `ERROR:` או `WARNING:` ופועלים לפי `Suggested fix:`. אם Java נסגר, מחפשים את `Caused by:` הראשון ב-`server\logs\latest.log` או ב-`server\crash-reports\`. המשימות שנותרו נמצאות ב-`TODO.md`.

> **הערה טכנית: יש להשתמש תמיד ב־`start-server.bat` שבתיקיית השורש של המאגר. אין ללחוץ פעמיים על `server.jar`; Windows עלול להשתמש ב־Java 8 או Java 21, בעוד Minecraft 26.2 דורש Java 25+ ‏64-bit. ראו את [המדריך המלא באנגלית](../en/how-does-jarock-work.md).**

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> InvView 1.4.21 is a verified Minecraft 26.2 server-side Fabric mod. It requires Fabric API and lets authorized operators inspect and manage online or offline player inventories and ender chests; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> OfflineCommands 1.0.3 is a verified Minecraft 26.2 server-side Fabric mod for running commands on offline players. No compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

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
