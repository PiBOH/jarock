# Jarock ilk çalıştırma

## Başlamadan önce

64 bit Java 25 veya daha yeni bir JDK kurun, Temurin yükleyicisinde JAVA_HOME seçeneğini etkinleştirin ve terminali yeniden açın. Yalnızca kökteki `start-server.bat` dosyasını çalıştırın; yerel ayarlar `scripts/server-launch-settings.ini` dosyasında tutulur ve `server/server.jar` dosyasını doğrudan açmayın.

## Loader seçimi

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## Kurulum ve EULA

Jarock loader ile sabitlenmiş modları otomatik indirir. İlk çalıştırma `server/eula.txt` dosyasını oluşturur ve durur. Minecraft EULA'yı okuyun; yalnızca kabul ediyorsanız `eula=false` değerini `eula=true` yapın. İlk başarılı çalıştırmadan önce `online-mode=false` kullanmayın; ilk çalıştırmayı `online-mode=true` ile tamamlayın.

## Güvenli durdurma

Tekrar çalıştırın ve world, Geyser ile Floodgate'in tamamlanmasını bekleyin. `stop` yazın ve pencereyi kapatmadan önce `CLEAN SHUTDOWN COMPLETE` ile `SAFE TO CLOSE` mesajlarını bekleyin. Hatalarda Suggested fix'i uygulayın; loader'lar karıştıysa yedek alın ve `clean-server-runtime.bat` çalıştırın. Güncelleme için `scripts/update-jarock.bat` çalıştırın ve herkese açmadan önce `TODO.md` dosyasını okuyun.

<!-- jarock-lan-addresses-tr -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Windows konsolunu kapatmaya karşı koruma:** While Jarock is running, the classic Windows console may show a warning when X is clicked. stop yazın ve SAFE TO CLOSE mesajını bekleyin. Dünya kaydedilirken zorla kapatmayın. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
