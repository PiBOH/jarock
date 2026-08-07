# Ağ, Güvenlik Duvarı ve Yönlendirici Kılavuzu

64-bit Java 25 kurun, `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat` dosyasını çalıştırın ve portları açmadan önce `TODO.md`'yi tamamlayın. Sabit bir LAN IP atayın, Windows Güvenlik Duvarı'nda TCP `25565` (Java) ve UDP `19132` (Bedrock) portlarını açın, yönlendiricide port yönlendirme yapılandırın veya playit.gg gibi UDP uyumlu bir tünel kullanın. `online-mode=true` ve `white-list=true`'un etkin olduğundan emin olun ve `key.pem`'i asla yayınlamayın. CGNAT için tünel kullanın. [İngilizce kılavuza](../en/network-and-ports.md) bakın.

> Her zaman `start-server.bat` kullanın; `server.jar`'a çift tıklamayın.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.
