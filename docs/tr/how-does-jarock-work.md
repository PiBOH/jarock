# Jarock nasıl çalışır?

## Sunucunun basit açıklaması

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**Yükleyici:** Fabric
**Ana platform:** Windows 10/11

Bu belge, Jarock indirildikten sonra ne olduğunu açıklar.


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome Message 2.8 with its required Collective library is included as a verified server-side Minecraft 26.2 mod for Fabric and NeoForge; it sends configurable join messages.

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

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> InvView 1.4.21 is a verified Minecraft 26.2 server-side Fabric mod. It requires Fabric API and lets authorized operators inspect and manage online or offline player inventories and ender chests; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> OfflineCommands 1.0.3 is a verified Minecraft 26.2 server-side Fabric mod for running commands on offline players. No compatible NeoForge 26.2 build is available, so NeoForge does not install it.

<!-- jarock-safe-shutdown -->

## Güvenli kapatma

> `stop` yazın ve pencereyi açık bırakın. Kapatmadan önce `CLEAN SHUTDOWN COMPLETE` ve ardından `SAFE TO CLOSE` mesajlarını bekleyin. İkinci mesaj yoksa günlüğü ve çökme raporunu kontrol edip gerekirse yedeği geri yükleyin.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Jarock güncellemesi

> `scripts/version.txt` dosyasını okuyun, sunucuyu durdurun ve `SAFE TO CLOSE` mesajını bekleyin; ardından `scripts/update-jarock.bat` dosyasını çalıştırın. Aynı beta/kararlı kanaldaki daha yeni sürümü arar, onay ister ve geri alma yedeği oluşturur. Dünya, runtime, modlar, kütüphaneler ve yerel ayarlar korunur; bağımlılıklar yalnızca eksik veya geçersizse düzeltilir.

> Tam paket ve yayımlanan SHA-512 sağlama toplamı yüklemeden önce doğrulanır.

<!-- jarock-auto-update-check -->

## Başlangıçta güncelleme denetimi

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows konsolunu kapatmaya karşı koruma:** While Jarock is running, the classic Windows console may show a warning when X is clicked. stop yazın ve SAFE TO CLOSE mesajını bekleyin. Dünya kaydedilirken zorla kapatmayın. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
