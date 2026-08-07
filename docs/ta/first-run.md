# Jarock முதல் தொடக்கம்

## தொடங்குவதற்கு முன்

64-பிட் Java 25 அல்லது புதிய JDK-ஐ நிறுவி, Temurin நிறுவியில் JAVA_HOME-ஐ இயக்கி, terminal-ஐ மீண்டும் திறக்கவும். Root-இல் உள்ள `start-server.bat`-ஐ மட்டும் இயக்கவும்; உள்ளூர் அமைப்புகள் `scripts/server-launch-settings.ini`-ல் சேமிக்கப்படும். `server/server.jar`-ஐ நேரடியாகத் திறக்க வேண்டாம்.

## Loader-ஐத் தேர்ந்தெடுத்தல்

`start-server.bat`-ஐ இயக்கி Fabric (பரிந்துரை), NeoForge (மாற்று) அல்லது Forge (Minecraft 26.2-க்கு தற்போது கிடைக்காது) என்பதைத் தேர்ந்தெடுக்கவும். `parameter-manager.bat` மூலம் RAM, GUI/console, GC, `online-mode`, banner மற்றும் `AUTO_UPDATE_CHECK` அமைக்கலாம். **Exit without saving** சேமிக்காமல் ரத்து செய்கிறது.

## நிறுவல் மற்றும் EULA

Jarock loader மற்றும் pin செய்யப்பட்ட mods-ஐ தானாகப் பதிவிறக்கும். முதல் இயக்கம் `server/eula.txt`-ஐ உருவாக்கி நிற்கும். Minecraft EULA-ஐ படித்து ஒப்புக்கொண்டால் மட்டும் `eula=false`-ஐ `eula=true` ஆக மாற்றவும். முதல் வெற்றிகரமான இயக்கத்திற்கு முன் `online-mode=false` பயன்படுத்த வேண்டாம்; முதல் இயக்கத்தை `online-mode=true` உடன் முடிக்கவும்.

## பாதுகாப்பான நிறுத்தம்

மீண்டும் இயக்கி world, Geyser மற்றும் Floodgate முடியும் வரை காத்திருக்கவும். `stop` என type செய்து `CLEAN SHUTDOWN COMPLETE` மற்றும் `SAFE TO CLOSE` தோன்றும் வரை சாளரத்தை மூட வேண்டாம். பிழையில் Suggested fix-ஐ பின்பற்றவும்; loader கலந்திருந்தால் backup எடுத்து `clean-server-runtime.bat` இயக்கவும். Update நிறுவ `scripts/update-jarock.bat` இயக்கவும்; பொதுவாக்குவதற்கு முன் `TODO.md` படிக்கவும்.

<!-- jarock-lan-addresses-ta -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.
