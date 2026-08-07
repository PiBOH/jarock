# NeoForge yedek kılavuzu

NeoForge’u yalnızca Fabric uygun değilse son seçenek olarak kullanın. Forge ve NeoForge farklı loaderlardır ve modlar NeoForge ile eşleşmelidir; gerekirse Geyser/Floodgate ekleyip önce bir kopyada test edin.

Tam İngilizce kılavuza bakın: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## Güvenli kapatma

> `stop` yazın ve pencereyi açık bırakın. Kapatmadan önce `CLEAN SHUTDOWN COMPLETE` ve ardından `SAFE TO CLOSE` mesajlarını bekleyin. İkinci mesaj yoksa günlüğü ve çökme raporunu kontrol edip gerekirse yedeği geri yükleyin.

<!-- jarock-updater -->


## Jarock güncellemesi

> `version.txt` dosyasını okuyun, sunucuyu durdurun ve `SAFE TO CLOSE` mesajını bekleyin; ardından `update-jarock.bat` dosyasını çalıştırın. Aynı beta/kararlı kanaldaki daha yeni sürümü arar, onay ister ve geri alma yedeği oluşturur. Dünya, runtime, modlar, kütüphaneler ve yerel ayarlar korunur; bağımlılıklar yalnızca eksik veya geçersizse düzeltilir.

> Tam paket ve yayımlanan SHA-512 sağlama toplamı yüklemeden önce doğrulanır.
