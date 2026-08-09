# பிணையம், ஃபயர்வால் மற்றும் ரௌட்டர் வழிகாட்டி

64-பிட் Java 25 நிறுவவும், `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` இயக்கவும், போர்ட்களை திறக்கும் முன் `TODO.md` முடிக்கவும். நிலையான LAN IP ஒதுக்கவும், Windows ஃபயர்வாலில் TCP `25565` (Java) மற்றும் UDP `19132` (Bedrock) திறக்கவும், ரௌட்டரில் போர்ட் ஃபார்வேர்டிங் கட்டமைக்கவும் அல்லது playit.gg போன்ற UDP இணக்கமான சுரங்கப்பாதையை பயன்படுத்தவும். `online-mode=true` மற்றும் `white-list=true` இயக்கத்தில் உள்ளதா என்பதை உறுதிசெய்து `key.pem` ஐ ஒருபோதும் வெளியிட வேண்டாம். CGNAT-க்கு சுரங்கப்பாதையை பயன்படுத்தவும். [ஆங்கில வழிகாட்டி](../en/network-and-ports.md) பார்க்கவும்.

> எப்போதும் `start-server.bat` பயன்படுத்தவும்; `server.jar` மீது இரட்டை கிளிக் செய்ய வேண்டாம்.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## பாதுகாப்பான நிறுத்தம்

> `stop` எனத் தட்டச்சு செய்து சாளரத்தைத் திறந்தே வைக்கவும். மூடுவதற்கு முன் `CLEAN SHUTDOWN COMPLETE`, பின்னர் `SAFE TO CLOSE` தோன்றும் வரை காத்திருக்கவும். இரண்டாவது செய்தி இல்லையெனில் பதிவையும் crash அறிக்கையையும் சரிபார்த்து, தேவையானால் காப்புப்பிரதியை மீட்டெடுக்கவும்.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Jarock புதுப்பிப்பு

> `scripts/version.txt` ஐப் படித்து, சர்வரை நிறுத்தி `SAFE TO CLOSE` தோன்றும் வரை காத்திருக்கவும்; பின்னர் `scripts/update-jarock.bat` ஐ இயக்கவும். அதே beta/stable சேனலில் புதிய பதிப்பைத் தேடி, உறுதிப்படுத்தல் பெற்று rollback காப்புப்பிரதியை உருவாக்கும். உலகம், runtime, modகள், நூலகங்கள் மற்றும் உள்ளூர் அமைப்புகள் பாதுகாக்கப்படும்; சார்புகள் இல்லை அல்லது தவறானவை என்றால் மட்டுமே சரிசெய்யப்படும்.

> முழு தொகுப்பும் அதற்கான வெளியிடப்பட்ட SHA-512 சரிபார்ப்புத் தொகையும் நிறுவலுக்கு முன் சரிபார்க்கப்படும்.

<!-- jarock-auto-update-check -->

## தொடக்கத்தில் புதுப்பிப்பு சரிபார்ப்பு

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows கன்சோல் மூடல் பாதுகாப்பு:** While Jarock is running, the classic Windows console may show a warning when X is clicked. stop என தட்டச்சு செய்து SAFE TO CLOSE வரும்வரை காத்திருக்கவும். உலகம் சேமிக்கும்போது கட்டாயமாக மூடாதீர்கள். This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
