# Fabric சேவையக வழிகாட்டி

64-bit Java 25 நிறுவி `start-server.bat` இயக்கவும்; RAM மற்றும் GUI அல்லது `nogui`-ஐ `parameter-manager.bat` மூலம் அமைக்கவும். (enable "Set JAVA_HOME variable" in the Temurin installer) `server/eula.txt` படித்து EULA ஏற்ற பிறகே `eula=true` அமைக்கவும்; Fabric, Geyser-Fabric, Floodgate-Fabric பயன்படுத்தி backup எடுக்கவும், Jarock router, firewall அல்லது port forwarding மாற்றாது.

முழு ஆங்கில வழிகாட்டியைப் பார்க்கவும்: [../en/server-guide.md](../en/server-guide.md)


Jarock never moves, renames, deletes or replaces an existing world automatically. If Minecraft reports a world-integrity or generation error, stop safely, inspect the logs and crash report, and restore the world from a known-good backup. A fresh world is generated only after you deliberately delete the existing `world`, `world_nether` and `world_the_end` folders yourself. If only some of `world`, `world_nether` and `world_the_end` exist, Jarock refuses to start to prevent mixing old and new dimensions; restore all three from a backup or deliberately delete all three to create a new world. Java stores the Nether and End inside the configured `level-name` folder as `DIM-1` and `DIM1`. If that configured folder exists, Jarock leaves it untouched and lets Minecraft load it or report its integrity error. A new world is possible only when the configured folder is absent and no other possible old world folder remains; after a `level-name` change, Jarock refuses to start instead of silently replacing an existing world.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Show ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **தொழில்நுட்பக் குறிப்பு: களஞ்சியத்தின் root-ல் உள்ள `start-server.bat`-ஐ எப்போதும் பயன்படுத்தவும். `server.jar`-ஐ இருமுறை கிளிக் செய்ய வேண்டாம்; Windows Java 8 அல்லது Java 21-ஐ பயன்படுத்தலாம், ஆனால் Minecraft 26.2-க்கு 64-bit Java 25+ தேவை. [முழு ஆங்கில வழிகாட்டியை](../en/server-guide.md) பார்க்கவும்.**



<!-- jarock-lan-addresses-ta -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

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
