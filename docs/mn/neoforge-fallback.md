# NeoForge нөөц гарын авлага

Fabric тохирохгүй үед л NeoForge-г эцсийн сонголт болго. Forge ба NeoForge өөр loader бөгөөд mod нь NeoForge-тэй таарах ёстой; шаардлагатай бол Geyser/Floodgate нэмээд эхлээд хуулбар дээр турш.

Англи бүрэн гарын авлагыг үз: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

<!-- jarock-safe-shutdown -->

## Аюулгүй зогсоох

> `stop` гэж бичээд цонхыг нээлттэй үлдээнэ үү. Хаахаас өмнө `CLEAN SHUTDOWN COMPLETE`, дараа нь `SAFE TO CLOSE` гарч ирэхийг хүлээнэ үү. Хоёр дахь мэдэгдэл байхгүй бол лог, crash тайланг шалгаж шаардлагатай бол нөөц хуулбарыг сэргээнэ үү.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Jarock шинэчлэх

> `scripts/version.txt`-г уншиж, серверийг зогсоогоод `SAFE TO CLOSE` гарч ирэхийг хүлээнэ үү; дараа нь `scripts/update-jarock.bat`-г ажиллуулна. Ижил beta/тогтвортой сувгийн шинэ хувилбарыг хайж, баталгаажуулалт авч буцаах нөөц үүсгэнэ. Дэлхий, runtime, mod, сангууд болон дотоод тохиргоо хадгалагдана; хамаарлыг зөвхөн байхгүй эсвэл буруу үед засна.

> Бүтэн багц болон нийтэлсэн SHA-512 шалгах нийлбэрийг суулгахаас өмнө шалгана.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Эхлэх үед шинэчлэлт шалгах

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified package matching scripts/jarock-edition.ini automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows консолийг хаахаас хамгаалах:** While Jarock is running, the classic Windows console may show a warning when X is clicked. stop гэж бичээд SAFE TO CLOSE-ийг хүлээнэ үү. Дэлхий хадгалагдаж байх үед хүчээр бүү хаа. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
