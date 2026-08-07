# NeoForge yedek kılavuzu

NeoForge’u yalnızca Fabric uygun değilse son seçenek olarak kullanın. Forge ve NeoForge farklı loaderlardır ve modlar NeoForge ile eşleşmelidir; gerekirse Geyser/Floodgate ekleyip önce bir kopyada test edin.

Tam İngilizce kılavuza bakın: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## Güvenli kapatma

> `stop` yazın ve pencereyi açık bırakın. Kapatmadan önce `CLEAN SHUTDOWN COMPLETE` ve ardından `SAFE TO CLOSE` mesajlarını bekleyin. İkinci mesaj yoksa günlüğü ve çökme raporunu kontrol edip gerekirse yedeği geri yükleyin.

<!-- jarock-updater -->


## Jarock güncellemesi

> `scripts/version.txt` dosyasını okuyun, sunucuyu durdurun ve `SAFE TO CLOSE` mesajını bekleyin; ardından `scripts/update-jarock.bat` dosyasını çalıştırın. Aynı beta/kararlı kanaldaki daha yeni sürümü arar, onay ister ve geri alma yedeği oluşturur. Dünya, runtime, modlar, kütüphaneler ve yerel ayarlar korunur; bağımlılıklar yalnızca eksik veya geçersizse düzeltilir.

> Tam paket ve yayımlanan SHA-512 sağlama toplamı yüklemeden önce doğrulanır.

<!-- jarock-auto-update-check -->

## Başlangıçta güncelleme denetimi

start-server.bat dosyasının GitHub sürümlerini yalnızca okuma amacıyla denetlemesi için parameter-manager.bat içinde AUTO_UPDATE_CHECK=true ayarlayın. Uyumlu daha yeni Jarock sürümü bildirilir, ancak otomatik yükleme yapılmaz. Sunucuyu durdurun, SAFE TO CLOSE iletisini bekleyin ve scripts/update-jarock.bat dosyasını çalıştırın. Varsayılan AUTO_UPDATE_CHECK=false değeridir. When a compatible newer release is found at startup, Jarock asks `Download and install it now? (y/N)`; choose y to install the verified Lite package, or N/Enter to continue with the current version. It never updates silently.
