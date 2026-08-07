# Jarock ilk çalıştırma

## Başlamadan önce

64 bit Java 25 veya daha yeni bir JDK kurun, Temurin yükleyicisinde JAVA_HOME seçeneğini etkinleştirin ve terminali yeniden açın. Yalnızca kökteki `start-server.bat` dosyasını çalıştırın; yerel ayarlar `scripts/server-launch-settings.ini` dosyasında tutulur ve `server/server.jar` dosyasını doğrudan açmayın.

## Loader seçimi

`start-server.bat` dosyasını çalıştırıp Fabric (önerilen), NeoForge (yedek) veya Forge (Minecraft 26.2 için şu anda kullanılamıyor) seçin. `parameter-manager.bat` RAM, GUI/console, GC, `online-mode`, banner ve `AUTO_UPDATE_CHECK` ayarlarını yönetir. **Exit without saving** kaydetmeden iptal eder.

## Kurulum ve EULA

Jarock loader ile sabitlenmiş modları otomatik indirir. İlk çalıştırma `server/eula.txt` dosyasını oluşturur ve durur. Minecraft EULA'yı okuyun; yalnızca kabul ediyorsanız `eula=false` değerini `eula=true` yapın. İlk başarılı çalıştırmadan önce `online-mode=false` kullanmayın; ilk çalıştırmayı `online-mode=true` ile tamamlayın.

## Güvenli durdurma

Tekrar çalıştırın ve world, Geyser ile Floodgate'in tamamlanmasını bekleyin. `stop` yazın ve pencereyi kapatmadan önce `CLEAN SHUTDOWN COMPLETE` ile `SAFE TO CLOSE` mesajlarını bekleyin. Hatalarda Suggested fix'i uygulayın; loader'lar karıştıysa yedek alın ve `clean-server-runtime.bat` çalıştırın. Güncelleme için `scripts/update-jarock.bat` çalıştırın ve herkese açmadan önce `TODO.md` dosyasını okuyun.
