# Jarock எவ்வாறு செயல்படுகிறது?

## சேவையகத்தின் எளிய விளக்கம்

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Loader:** Fabric
**முக்கிய தளம்:** Windows 10/11

Jarock-ஐ பதிவிறக்கிய பிறகு என்ன நடக்கிறது என்பதை இந்த ஆவணம் விளக்குகிறது.


> DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **பராமரிப்பு குறிப்பு:** தொடக்கி இப்போது `PATH`-இல் உள்ள முதல் `java.exe`-ஐ மட்டும் நம்பாமல், இணக்கமான 64-bit Java 25+ இயக்கநேரத்தைத் தேடுகிறது. இது `scripts/java-runtime.ps1`-ஐ பயன்படுத்தி, தேர்ந்தெடுக்கப்பட்ட executable-ஐ `server/java-path.txt`-ல் சேமித்து, தொடங்குவதற்கு முன் சரிபார்க்கிறது. Java 8 நிறுவப்பட்டே இருக்கலாம்.

## 1. சுருக்கமாக

பயனர் 64-bit Java-ஐ நிறுவி, இந்த repository-ஐ பதிவிறக்கி, `start-server.bat`-ஐ இயக்குகிறார். நிரல் தனது கோப்புறையைத் தானாகக் கண்டறிந்து, Java மற்றும் பாதையைச் சரிபார்க்கிறது. தேவையானபோது Windows நீண்ட பாதை ஆதரவை இயக்க அனுமதி கேட்கிறது. பின்னர் நிர்ணயிக்கப்பட்ட Fabric installer மற்றும் mods-ஐ பதிவிறக்கி, ஒவ்வொரு கோப்பையும் SHA-512 மூலம் சரிபார்க்கிறது.

Fabric runtime-ஐ `server/`-ல் உருவாக்குகிறது. முதல் இயக்கத்தில் `server/eula.txt` கோப்பு `eula=false` உடன் உருவாக்கப்பட்டு நிரல் நிற்கிறது. பயனர் <https://www.minecraft.net/eula> படித்து, ஏற்றுக்கொண்டால் `eula=true` என மாற்றி மீண்டும் இயக்க வேண்டும். Geyser Bedrock போக்குவரத்தை மாற்றுகிறது; Floodgate Bedrock அங்கீகாரத்தை கையாளுகிறது.

Jarock router, firewall அல்லது port forwarding-ஐ **அமைக்காது**.

## 2. கோப்புகள் மற்றும் செயல்முறை

Repository-யில் scripts, templates மற்றும் manifest உள்ளன; world அல்லது உருவாக்கப்பட்ட `.jar` கோப்புகள் இல்லை:

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

Runtime `server/`-ல் உருவாகிறது. world, logs, libraries, private keys மற்றும் உள்ளூர் பட்டியல்களை Git புறக்கணிக்கிறது.

`start-server.bat` நிலையான `C:\MinecraftServer` பாதையைப் பயன்படுத்தாமல் தனது சொந்த இருப்பிடத்தைப் பயன்படுத்துகிறது. எனவே இடைவெளி, Unicode, `!` மற்றும் உள்ளமைக்கப்பட்ட கோப்புறைகள் கொண்ட அணுகக்கூடிய பாதைகள் ஆதரிக்கப்படுகின்றன. நீண்ட பாதைகளுக்கு இது சரிபார்க்கிறது:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

தேவைப்பட்டால் administrator அனுமதி கேட்டு `scripts\enable-long-paths.ps1`-ஐ இயக்குகிறது. இது கணினி முழுவதற்குமான மாற்றம்; பழைய செயலிகளுக்கு Windows restart தேவைப்படலாம்.

## 3. EULA, Geyser மற்றும் பிழைகள்

முதல் இயக்கம் `server/eula.txt`-ஐ `eula=false` உடன் உருவாக்கி நிற்கிறது. EULA-ஐப் படித்து, ஒப்புக்கொண்டால் `eula=true` என மாற்றி மீண்டும் இயக்கவும்.

Geyser முதல் உண்மையான server இயக்கத்தின் போது முழு configuration-ஐ உருவாக்குகிறது. கோப்பு உருவான பிறகு:

```text
server\config\Geyser-Fabric\config.yml
```

script இதை அமைக்கிறது:

```yaml
auth-type: floodgate
```

Java பொதுவாக TCP `25565`-ஐயும் Bedrock UDP `19132`-ஐயும் பயன்படுத்துகிறது. Jarock எந்த port-ஐயும் திறக்காது. `key.pem` ரகசியமானது; வெளியிடக்கூடாது.

பிழை வந்தால் `ERROR:` அல்லது `WARNING:`-ஐப் படித்து `Suggested fix:`-ஐப் பின்பற்றவும். Java நிறுத்தப்பட்டால் `server\logs\latest.log` அல்லது `server\crash-reports\`-ல் முதல் `Caused by:` வரியைப் பார்க்கவும். மீதமுள்ள பணிகள் `TODO.md`-ல் உள்ளன.

> **தொழில்நுட்பக் குறிப்பு: களஞ்சியத்தின் root-ல் உள்ள `start-server.bat`-ஐ எப்போதும் பயன்படுத்தவும். `server.jar`-ஐ இருமுறை கிளிக் செய்ய வேண்டாம்; Windows Java 8 அல்லது Java 21-ஐ பயன்படுத்தலாம், ஆனால் Minecraft 26.2-க்கு 64-bit Java 25+ தேவை. [முழு ஆங்கில வழிகாட்டியை](../en/how-does-jarock-work.md) பார்க்கவும்.**

<!-- jarock-safe-shutdown -->

## பாதுகாப்பான நிறுத்தம்

> `stop` எனத் தட்டச்சு செய்து சாளரத்தைத் திறந்தே வைக்கவும். மூடுவதற்கு முன் `CLEAN SHUTDOWN COMPLETE`, பின்னர் `SAFE TO CLOSE` தோன்றும் வரை காத்திருக்கவும். இரண்டாவது செய்தி இல்லையெனில் பதிவையும் crash அறிக்கையையும் சரிபார்த்து, தேவையானால் காப்புப்பிரதியை மீட்டெடுக்கவும்.

<!-- jarock-updater -->


## Jarock புதுப்பிப்பு

> `scripts/version.txt` ஐப் படித்து, சர்வரை நிறுத்தி `SAFE TO CLOSE` தோன்றும் வரை காத்திருக்கவும்; பின்னர் `scripts/update-jarock.bat` ஐ இயக்கவும். அதே beta/stable சேனலில் புதிய பதிப்பைத் தேடி, உறுதிப்படுத்தல் பெற்று rollback காப்புப்பிரதியை உருவாக்கும். உலகம், runtime, modகள், நூலகங்கள் மற்றும் உள்ளூர் அமைப்புகள் பாதுகாக்கப்படும்; சார்புகள் இல்லை அல்லது தவறானவை என்றால் மட்டுமே சரிசெய்யப்படும்.

> முழு தொகுப்பும் அதற்கான வெளியிடப்பட்ட SHA-512 சரிபார்ப்புத் தொகையும் நிறுவலுக்கு முன் சரிபார்க்கப்படும்.

<!-- jarock-auto-update-check -->

## தொடக்கத்தில் புதுப்பிப்பு சரிபார்ப்பு

GitHub வெளியீடுகளை படிக்க மட்டும் சரிபார்க்க start-server.bat செய்ய parameter-manager.bat இல் AUTO_UPDATE_CHECK=true அமைக்கவும். இணக்கமான புதிய Jarock பதிப்பு தெரிவிக்கப்படும்; தானாக நிறுவப்படாது. சேவையகத்தை நிறுத்தி SAFE TO CLOSE வரும் வரை காத்திருந்து scripts/update-jarock.bat இயக்கவும். இயல்புநிலை AUTO_UPDATE_CHECK=false.
