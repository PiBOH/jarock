# איך Jarock עובד?

## הסבר פשוט על השרת

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**טוען:** Fabric
**פלטפורמה ראשית:** Windows 10/11

המסמך מסביר מה קורה לאחר הורדת Jarock.


> DedicatedPower is updated automatically from its latest GitHub release; the other server mods are pinned and verified with SHA-512.

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
scripts/bootstrap-fabric.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
version.txt
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
