# NeoForge மாற்று வழிகாட்டி

Fabric பொருந்தாதபோது மட்டும் NeoForge-ஐ கடைசி தேர்வாகப் பயன்படுத்தவும். Forge மற்றும் NeoForge வேறு loaders; mods NeoForge-க்கு பொருந்த வேண்டும். தேவைப்பட்டால் Geyser/Floodgate சேர்த்து முதலில் நகலில் சோதிக்கவும்.

முழு ஆங்கில வழிகாட்டியைப் பார்க்கவும்: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## பாதுகாப்பான நிறுத்தம்

> `stop` எனத் தட்டச்சு செய்து சாளரத்தைத் திறந்தே வைக்கவும். மூடுவதற்கு முன் `CLEAN SHUTDOWN COMPLETE`, பின்னர் `SAFE TO CLOSE` தோன்றும் வரை காத்திருக்கவும். இரண்டாவது செய்தி இல்லையெனில் பதிவையும் crash அறிக்கையையும் சரிபார்த்து, தேவையானால் காப்புப்பிரதியை மீட்டெடுக்கவும்.

<!-- jarock-updater -->


## Jarock புதுப்பிப்பு

> `scripts/version.txt` ஐப் படித்து, சர்வரை நிறுத்தி `SAFE TO CLOSE` தோன்றும் வரை காத்திருக்கவும்; பின்னர் `scripts/update-jarock.bat` ஐ இயக்கவும். அதே beta/stable சேனலில் புதிய பதிப்பைத் தேடி, உறுதிப்படுத்தல் பெற்று rollback காப்புப்பிரதியை உருவாக்கும். உலகம், runtime, modகள், நூலகங்கள் மற்றும் உள்ளூர் அமைப்புகள் பாதுகாக்கப்படும்; சார்புகள் இல்லை அல்லது தவறானவை என்றால் மட்டுமே சரிசெய்யப்படும்.

> முழு தொகுப்பும் அதற்கான வெளியிடப்பட்ட SHA-512 சரிபார்ப்புத் தொகையும் நிறுவலுக்கு முன் சரிபார்க்கப்படும்.

<!-- jarock-auto-update-check -->

## தொடக்கத்தில் புதுப்பிப்பு சரிபார்ப்பு

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows கன்சோல் மூடல் பாதுகாப்பு:** While Jarock is running, the classic Windows console may show a warning when X is clicked. stop என தட்டச்சு செய்து SAFE TO CLOSE வரும்வரை காத்திருக்கவும். உலகம் சேமிக்கும்போது கட்டாயமாக மூடாதீர்கள். This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
