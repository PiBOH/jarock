# הפעלה ראשונה של Jarock

## בחירת loader

התקן JDK ‏64 סיביות של Java 25 ומעלה, הפעל JAVA_HOME במתקין Temurin ופתח מחדש את הטרמינל. השתמש תמיד ב-`start-server.bat` en `scripts/server-launch-settings.ini` שבשורש ואל תפתח ישירות את `server/server.jar`.

## התקנה ו-EULA

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## כיבוי בטוח

Jarock מוריד אוטומטית את ה-loader ואת המודים המוצמדים. ההפעלה הראשונה יוצרת `server/eula.txt` ונעצרת. קרא את Minecraft EULA ושנה `eula=false` ל-`eula=true` רק אם אתה מסכים. אל תשתמש ב-`online-mode=false` לפני הפעלה מוצלחת ראשונה.

## כיבוי בטוח

הפעל שוב, המתן לסיום העולם, Geyser ו-Floodgate, כתוב `stop` והמתן ל-`CLEAN SHUTDOWN COMPLETE` ול-`SAFE TO CLOSE`. במקרה של שגיאה פעל לפי Suggested fix; אם ה-loaders מעורבבים, גבה והפעל `clean-server-runtime.bat`. קרא את `TODO.md` לפני גישה ציבורית.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## הערת בטיחות

השלם את ההפעלה הראשונה עם `online-mode=true` כדי להשתמש באימות הרגיל.

## הערת בטיחות

כדי להתקין עדכון, עצור את השרת בבטחה והפעל `scripts/update-jarock.bat`.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-he -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **הגנה מפני סגירת מסוף Windows:** While Jarock is running, the classic Windows console may show a warning when X is clicked. הקלד stop והמתן ל-SAFE TO CLOSE. לעולם אל תסגור בכוח בזמן שמירת העולם. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
