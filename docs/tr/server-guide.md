# Fabric sunucu kılavuzu

64 bit Java 25 kurun, `start-server.bat` çalıştırın ve RAM ile GUI veya `nogui` ayarlarını `parameter-manager.bat` üzerinden yapın. (enable "Set JAVA_HOME variable" in the Temurin installer) `server/eula.txt` dosyasını okuyun, EULA’yı kabul edip `eula=true` yapın; Fabric, Geyser-Fabric ve Floodgate-Fabric kullanın, yedek alın, Jarock router, firewall veya port forwarding değiştirmez.

Tam İngilizce kılavuza bakın: [../en/server-guide.md](../en/server-guide.md)


Jarock never moves, renames, deletes or replaces an existing world automatically. If Minecraft reports a world-integrity or generation error, stop safely, inspect the logs and crash report, and restore the world from a known-good backup. A fresh world is generated only after you deliberately delete the existing `world`, `world_nether` and `world_the_end` folders yourself. If only some of `world`, `world_nether` and `world_the_end` exist, Jarock refuses to start to prevent mixing old and new dimensions; restore all three from a backup or deliberately delete all three to create a new world. Java stores the Nether and End inside the configured `level-name` folder as `DIM-1` and `DIM1`. If that configured folder exists, Jarock leaves it untouched and lets Minecraft load it or report its integrity error. A new world is possible only when the configured folder is absent and no other possible old world folder remains; after a `level-name` change, Jarock refuses to start instead of silently replacing an existing world.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Show ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> Technical fallback note: Links In Chat is included in the pinned Fabric 26.2 server stack. It makes URLs in server chat clickable and adds `/link` and `/linkwhisper`; clients do not need to install it. Welcome Message 2.8 with its required Collective library is included as a verified server-side Minecraft 26.2 mod for Fabric and NeoForge; it sends configurable join messages. On the first Jarock-managed startup, Jarock applies its configured `welcomemessage.json5` template once and preserves later operator edits. Temizleme betiği izlenen şablonu korur ve doğrulanmış Lite paketi güncellemeleri şablonu yeniler.
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **Teknik not: Her zaman repository kökündeki `start-server.bat` dosyasını kullanın. `server.jar` dosyasına çift tıklamayın; Windows Java 8 veya Java 21 kullanabilir, ancak Minecraft 26.2 için 64 bit Java 25+ gerekir. [Tam İngilizce kılavuza](../en/server-guide.md) bakın.**



<!-- jarock-lan-addresses-tr -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> InvView 1.4.21 is a verified Minecraft 26.2 server-side Fabric mod. It requires Fabric API and lets authorized operators inspect and manage online or offline player inventories and ender chests; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> OfflineCommands 1.0.3 is a verified Minecraft 26.2 server-side Fabric mod for running commands on offline players. No compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

<!-- jarock-safe-shutdown -->

## Güvenli kapatma

> `stop` yazın ve pencereyi açık bırakın. Kapatmadan önce `CLEAN SHUTDOWN COMPLETE` ve ardından `SAFE TO CLOSE` mesajlarını bekleyin. İkinci mesaj yoksa günlüğü ve çökme raporunu kontrol edip gerekirse yedeği geri yükleyin.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-world-transfer -->

## World import and export

> English note: parameter-manager.bat option `I` (Import world) accepts the full path of a world folder containing `level.dat` or of a `.zip` world archive; the world is imported on the next `start-server.bat` run. If the configured world already exists you are asked to confirm and it is backed up first as `<name>_originalbkp`. The parameter manager asks whether to remember the source with `(Y/n)`; Enter accepts the default Yes. When remembered, the source stays saved and is reused only if the configured world is later deleted; normal restarts keep the existing world. If not remembered, the request is cleared after the one-shot import. Option `E` (Export world) accepts a destination folder outside `server/`; after every clean shutdown (`stop` + `SAFE TO CLOSE`) the world is copied there, overwriting the destination.

> Icon note: Jarock uses the tracked root `icon.png` only as the default icon for a world that has no custom icon, and preserves imported or customized world icons. The tracked `server/icon.png` is included in the server runtime, while `server/server-icon.png` is the multiplayer server-list icon. All three tracked icons are included in the Full and Lite release packages. The cleanup script also preserves the two tracked server icons; the repository-root icon.png and logo.png remain outside its cleanup scope.

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
