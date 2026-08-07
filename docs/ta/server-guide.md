# Fabric சேவையக வழிகாட்டி

64-bit Java 25 நிறுவி `start-server.bat` இயக்கவும்; RAM மற்றும் GUI அல்லது `nogui`-ஐ `parameter-manager.bat` மூலம் அமைக்கவும். (enable "Set JAVA_HOME variable" in the Temurin installer) `server/eula.txt` படித்து EULA ஏற்ற பிறகே `eula=true` அமைக்கவும்; Fabric, Geyser-Fabric, Floodgate-Fabric பயன்படுத்தி backup எடுக்கவும், Jarock router, firewall அல்லது port forwarding மாற்றாது.

முழு ஆங்கில வழிகாட்டியைப் பார்க்கவும்: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **தொழில்நுட்பக் குறிப்பு: களஞ்சியத்தின் root-ல் உள்ள `start-server.bat`-ஐ எப்போதும் பயன்படுத்தவும். `server.jar`-ஐ இருமுறை கிளிக் செய்ய வேண்டாம்; Windows Java 8 அல்லது Java 21-ஐ பயன்படுத்தலாம், ஆனால் Minecraft 26.2-க்கு 64-bit Java 25+ தேவை. [முழு ஆங்கில வழிகாட்டியை](../en/server-guide.md) பார்க்கவும்.**
