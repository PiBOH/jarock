# NeoForge yedek kılavuzu

NeoForge’u yalnızca Fabric uygun değilse son seçenek olarak kullanın. Forge ve NeoForge farklı loaderlardır ve modlar NeoForge ile eşleşmelidir; gerekirse Geyser/Floodgate ekleyip önce bir kopyada test edin.

Tam İngilizce kılavuza bakın: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## Güvenli kapatma

> `stop` yazın ve pencereyi açık bırakın. Kapatmadan önce `CLEAN SHUTDOWN COMPLETE` ve ardından `SAFE TO CLOSE` mesajlarını bekleyin. İkinci mesaj yoksa günlüğü ve çökme raporunu kontrol edip gerekirse yedeği geri yükleyin.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Jarock güncellemesi

> `scripts/version.txt` dosyasını okuyun, sunucuyu durdurun ve `SAFE TO CLOSE` mesajını bekleyin; ardından `scripts/update-jarock.bat` dosyasını çalıştırın. Aynı beta/kararlı kanaldaki daha yeni sürümü arar, onay ister ve geri alma yedeği oluşturur. Dünya, runtime, modlar, kütüphaneler ve yerel ayarlar korunur; bağımlılıklar yalnızca eksik veya geçersizse düzeltilir.

> Tam paket ve yayımlanan SHA-512 sağlama toplamı yüklemeden önce doğrulanır.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## Başlangıçta güncelleme denetimi

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows konsolunu kapatmaya karşı koruma:** While Jarock is running, the classic Windows console may show a warning when X is clicked. stop yazın ve SAFE TO CLOSE mesajını bekleyin. Dünya kaydedilirken zorla kapatmayın. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
