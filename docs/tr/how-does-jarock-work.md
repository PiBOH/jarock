# Jarock nasıl çalışır?

## Sunucunun basit açıklaması

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Yükleyici:** Fabric
**Ana platform:** Windows 10/11

Bu belge, Jarock indirildikten sonra ne olduğunu açıklar.


> DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **Bakım notu:** başlatıcı artık `PATH` içindeki yalnızca ilk `java.exe` dosyasına güvenmek yerine uyumlu bir 64 bit Java 25+ çalışma zamanı arar. `scripts/java-runtime.ps1` kullanılır, seçilen çalıştırılabilir dosya `server/java-path.txt` içine kaydedilir ve başlatmadan önce doğrulanır. Java 8 yüklü kalabilir.

## 1. Kısaca

Kullanıcı 64 bit Java kurar, bu repository'yi indirir ve `start-server.bat` dosyasını çalıştırır. Program kendi klasörünü bulur, Java'yı ve yolu kontrol eder, gerekirse Windows uzun yol desteğini etkinleştirmek için izin ister, sabitlenmiş Fabric installer ve mods dosyalarını indirir ve her dosyayı SHA-512 ile doğrular.

Fabric runtime'ı `server/` içinde oluşturur. İlk çalıştırma `server/eula.txt` dosyasını `eula=false` değeriyle oluşturur ve durur. Kullanıcı <https://www.minecraft.net/eula> adresindeki EULA'yı okumalı, kabul ediyorsa `eula=true` yapmalı ve tekrar çalıştırmalıdır. Geyser Bedrock trafiğini dönüştürür, Floodgate ise Bedrock kimlik doğrulamasını yönetir.

Jarock router, firewall veya port forwarding ayarlarını **yapmaz**.

## 2. Dosyalar ve akış

Repository scripts, şablonlar ve manifest içerir; dünya veya oluşturulan `.jar` dosyalarını içermez:

```text
start-server.bat
scripts/bootstrap-fabric.ps1
scripts/configure-geyser.ps1
scripts/enable-long-paths.ps1
server/mods-manifest.ps1
server/server.properties.template
server/eula.txt.template
version.txt
CHANGELOG.md
TODO.md
```

Runtime `server/` içine oluşturulur. Git world, logs, kitaplıklar, özel anahtarlar ve yerel listeleri yok sayar.

`start-server.bat`, `C:\MinecraftServer` gibi sabit bir yol yerine kendi konumunu kullanır. Böylece boşluk, Unicode, `!` ve iç içe klasörler içeren erişilebilir yollar desteklenir. Uzun yollar için şunu kontrol eder:

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

Gerekirse administrator izni ister ve `scripts\enable-long-paths.ps1` dosyasını çalıştırır. Değişiklik tüm makine için geçerlidir ve eski uygulamalar Windows'un yeniden başlatılmasını gerektirebilir.

## 3. EULA, Geyser ve hatalar

İlk çalıştırma `server/eula.txt` dosyasını `eula=false` ile oluşturur ve durur. EULA'yı okuyun, kabul ediyorsanız `eula=true` yapın ve tekrar çalıştırın.

Geyser tam yapılandırmasını ilk gerçek sunucu başlatmasında oluşturur. Dosya oluşturulduktan sonra script şu dosyada:

```text
server\config\Geyser-Fabric\config.yml
```

şunu ayarlar:

```yaml
auth-type: floodgate
```

Java genellikle TCP `25565`, Bedrock ise UDP `19132` kullanır. Jarock port açmaz. `key.pem` gizlidir ve yayımlanmamalıdır.

Bir hatadan sonra `ERROR:` veya `WARNING:` satırını okuyun ve `Suggested fix:` önerisini uygulayın. Java kapanırsa `server\logs\latest.log` veya `server\crash-reports\` içindeki ilk `Caused by:` satırını bulun. Kalan görevler `TODO.md` içindedir.

> **Teknik not: Her zaman repository kökündeki `start-server.bat` dosyasını kullanın. `server.jar` dosyasına çift tıklamayın; Windows Java 8 veya Java 21 kullanabilir, ancak Minecraft 26.2 için 64 bit Java 25+ gerekir. [Tam İngilizce kılavuza](../en/how-does-jarock-work.md) bakın.**

<!-- jarock-safe-shutdown -->

## Güvenli kapatma

> `stop` yazın ve pencereyi açık bırakın. Kapatmadan önce `CLEAN SHUTDOWN COMPLETE` ve ardından `SAFE TO CLOSE` mesajlarını bekleyin. İkinci mesaj yoksa günlüğü ve çökme raporunu kontrol edip gerekirse yedeği geri yükleyin.

<!-- jarock-updater -->


## Jarock güncellemesi

> `version.txt` dosyasını okuyun, sunucuyu durdurun ve `SAFE TO CLOSE` mesajını bekleyin; ardından `update-jarock.bat` dosyasını çalıştırın. Aynı beta/kararlı kanaldaki daha yeni sürümü arar, onay ister ve geri alma yedeği oluşturur. Dünya, runtime, modlar, kütüphaneler ve yerel ayarlar korunur; bağımlılıklar yalnızca eksik veya geçersizse düzeltilir.

> Tam paket ve yayımlanan SHA-512 sağlama toplamı yüklemeden önce doğrulanır.
