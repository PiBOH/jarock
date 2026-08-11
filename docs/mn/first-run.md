> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

# Jarock-ийн анхны ажиллуулалт

## Loader сонгох

64 битийн Java 25 буюу түүнээс шинэ JDK суулгаж, Temurin суулгагчид JAVA_HOME-г идэвхжүүлээд терминалыг дахин нээнэ үү. Үргэлж root дахь `start-server.bat` en `scripts/server-launch-settings.ini`-г ажиллуулж, `server/server.jar`-г шууд нээхгүй.

## Суулгалт ба EULA

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## Аюулгүй зогсоох

Jarock loader болон тогтоосон mod-уудыг автоматаар татна. Эхний ажиллуулалт `server/eula.txt` үүсгээд зогсоно. Minecraft EULA-г уншаад зөвшөөрсөн тохиолдолд л `eula=false`-г `eula=true` болгоно. Эхний амжилттай ажиллуулалтаас өмнө `online-mode=false` бүү ашигла.

## Аюулгүй зогсоох

Дахин ажиллуулж world, Geyser, Floodgate-г дуусгахыг хүлээнэ. `stop` бичээд `CLEAN SHUTDOWN COMPLETE`, `SAFE TO CLOSE` хүртэл цонхыг бүү хаа. Алдаанд Suggested fix-ийг дагаж, loader холилдвол нөөцлөөд `clean-server-runtime.bat` ажиллуулж, нийтэд нээхээс өмнө `TODO.md`-г унш.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## Аюулгүй байдлын тэмдэглэл

Ердийн баталгаажуулалт ажиллахын тулд эхний ажиллуулалтыг `online-mode=true`-тэй дуусгана уу.

## Аюулгүй байдлын тэмдэглэл

Шинэчлэлт суулгахын тулд серверийг аюулгүй зогсоогоод `scripts/update-jarock.bat` ажиллуулна уу.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-mn -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Windows консолийг хаахаас хамгаалах:** While Jarock is running, the classic Windows console may show a warning when X is clicked. stop гэж бичээд SAFE TO CLOSE-ийг хүлээнэ үү. Дэлхий хадгалагдаж байх үед хүчээр бүү хаа. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
