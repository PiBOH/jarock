# Documentation

## Interface support status

The **CLI is strongly recommended and maintained**. Use `jarock-cli-full` or `jarock-cli-lite` for the supported command-line experience. The TUI remains available in future releases, but it is **unmaintained**, provided as-is, and may not receive fixes for input or compatibility problems.

## Release editions and TUI

Every release continues to provide four Windows ZIP families: `jarock-cli-full`, `jarock-cli-lite`, `jarock-tui-full` and `jarock-tui-lite`. CLI editions use the maintained classic command-line flow. TUI editions include the standalone `jarock-tui.exe`; both `start-server.bat` and `parameter-manager.bat` open the central terminal menu, while DedicatedPower continues to manage the server window. Full editions include the Java installers; Lite editions preserve the existing Lite behavior. `scripts/jarock-edition.ini` records the installed interface and tier, and verified updates never switch between CLI/TUI or Full/Lite. Use `clean-cache.bat` to remove inactive updater downloads, rollback backups and temporary wrappers without removing the server runtime; the same action is available from both CLI and TUI menus.

## English guides

- [Minecraft Java Fabric Server — installation guide](en/server-guide.md)
- [Minecraft Java NeoForge fallback](en/neoforge-fallback.md)
- [How does Jarock work?](en/how-does-jarock-work.md)
- [First run guide](en/first-run.md)

The English guides are the source of truth for the technical procedure. The current project version is stored only in the `scripts/version.txt` file.

## Runtime and launch configuration

- `parameter-manager.bat` configures the loader, RAM, GUI/console mode, a conservative GC profile, online-mode, the ready banner, world import/export (`I` imports a world folder or `.zip` on the next start and asks `Remember this world for future starts? (Y/n)`; `E` exports the world to a destination folder after every clean shutdown), the optional interactive startup update check and user-scoped Java environment setup. A remembered source is reused only when the configured world is later deleted; normal restarts keep the active world. It edits a temporary copy and includes `Exit without saving` to discard all pending changes.
- `scripts/server-launch-settings.ini.template` is the tracked safe default.
- `scripts/server-launch-settings.ini` is local and ignored by Git.
- `java-home.txt` is an optional local override for a custom JDK folder and is ignored by Git; `JAROCK_JAVA_HOME` is the advanced equivalent.
- `scripts/java-runtime.ps1` finds a compatible 64-bit Java 25+ runtime even when Java 8 or Java 21 appears first on `PATH`; if none is available and the bundled installers are present in `prerequisites/`, `start-server.bat` runs them automatically (legacy Java 8 first, then the Temurin JDK 25 MSI); otherwise it lists the detected incompatible candidates and gives a Java 25 installation link.
- `scripts/configure-java-environment.ps1` updates only the current user's `JAVA_HOME` and `PATH`, preserving unrelated entries.
Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified package matching scripts/jarock-edition.ini automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## How Jarock works translations

Each requested locale has a concise translated `how-does-jarock-work.md`. The English file is the complete explanation; localized files preserve essential technical steps and literals.

| Locale | Guide |
|---|---|
| `af` | [Hoe werk Jarock?](af/how-does-jarock-work.md) |
| `ar` | [كيف يعمل Jarock؟](ar/how-does-jarock-work.md) |
| `ca` | [Com funciona Jarock?](ca/how-does-jarock-work.md) |
| `zh-CN` | [Jarock 是如何工作的？](zh-CN/how-does-jarock-work.md) |
| `zh-TW` | [Jarock 如何運作？](zh-TW/how-does-jarock-work.md) |
| `hr` | [Kako Jarock radi?](hr/how-does-jarock-work.md) |
| `cs` | [Jak Jarock funguje?](cs/how-does-jarock-work.md) |
| `nl` | [Hoe werkt Jarock?](nl/how-does-jarock-work.md) |
| `fa` | [Jarock چگونه کار می‌کند؟](fa/how-does-jarock-work.md) |
| `fr` | [Comment fonctionne Jarock ?](fr/how-does-jarock-work.md) |
| `gl` | [Como funciona Jarock?](gl/how-does-jarock-work.md) |
| `de` | [Wie funktioniert Jarock?](de/how-does-jarock-work.md) |
| `he` | [איך Jarock עובד?](he/how-does-jarock-work.md) |
| `hu` | [Hogyan működik a Jarock?](hu/how-does-jarock-work.md) |
| `id` | [Bagaimana Jarock bekerja?](id/how-does-jarock-work.md) |
| `it` | [Come funziona Jarock?](it/how-does-jarock-work.md) |
| `ja` | [Jarock はどのように動作しますか？](ja/how-does-jarock-work.md) |
| `ko` | [Jarock은 어떻게 작동하나요?](ko/how-does-jarock-work.md) |
| `lv` | [Kā darbojas Jarock?](lv/how-does-jarock-work.md) |
| `ms` | [Bagaimanakah Jarock berfungsi?](ms/how-does-jarock-work.md) |
| `mn` | [Jarock хэрхэн ажилладаг вэ?](mn/how-does-jarock-work.md) |
| `pl` | [Jak działa Jarock?](pl/how-does-jarock-work.md) |
| `pt` | [Como funciona o Jarock?](pt/how-does-jarock-work.md) |
| `ro` | [Cum funcționează Jarock?](ro/how-does-jarock-work.md) |
| `ru` | [Как работает Jarock?](ru/how-does-jarock-work.md) |
| `es` | [¿Cómo funciona Jarock?](es/how-does-jarock-work.md) |
| `sv` | [Hur fungerar Jarock?](sv/how-does-jarock-work.md) |
| `sl` | [Kako deluje Jarock?](sl/how-does-jarock-work.md) |
| `ta` | [Jarock எவ்வாறு செயல்படுகிறது?](ta/how-does-jarock-work.md) |
| `th` | [Jarock ทำงานอย่างไร?](th/how-does-jarock-work.md) |
| `tr` | [Jarock nasıl çalışır?](tr/how-does-jarock-work.md) |
| `uk` | [Як працює Jarock?](uk/how-does-jarock-work.md) |

## First-run translations

Every supported locale has a `first-run.md` guide. The English guide is the complete version; localized guides preserve all commands, paths, configuration keys and safety messages. Technical names and launcher output literals remain unchanged where users must match them exactly.

| Locale | Guide |
|---|---|
| `af` | [Eerste Jarock-beginloop](af/first-run.md) |
| `ar` | [التشغيل الأول لـ Jarock](ar/first-run.md) |
| `ca` | [Primera execució de Jarock](ca/first-run.md) |
| `zh-CN` | [Jarock 首次启动](zh-CN/first-run.md) |
| `zh-TW` | [Jarock 首次啟動](zh-TW/first-run.md) |
| `hr` | [Prvo pokretanje Jarocka](hr/first-run.md) |
| `cs` | [První spuštění Jarock](cs/first-run.md) |
| `nl` | [Eerste start van Jarock](nl/first-run.md) |
| `fa` | [اجرای نخست Jarock](fa/first-run.md) |
| `fr` | [Premier démarrage de Jarock](fr/first-run.md) |
| `gl` | [Primeiro arranque de Jarock](gl/first-run.md) |
| `de` | [Erster Start von Jarock](de/first-run.md) |
| `he` | [הפעלה ראשונה של Jarock](he/first-run.md) |
| `hu` | [A Jarock első indítása](hu/first-run.md) |
| `id` | [Penggunaan pertama Jarock](id/first-run.md) |
| `it` | [Primo avvio di Jarock](it/first-run.md) |
| `ja` | [Jarock の初回起動](ja/first-run.md) |
| `ko` | [Jarock 최초 실행](ko/first-run.md) |
| `lv` | [Jarock pirmā palaišana](lv/first-run.md) |
| `ms` | [Pelancaran pertama Jarock](ms/first-run.md) |
| `mn` | [Jarock-ийн анхны ажиллуулалт](mn/first-run.md) |
| `pl` | [Pierwsze uruchomienie Jarock](pl/first-run.md) |
| `pt` | [Primeira execução do Jarock](pt/first-run.md) |
| `ro` | [Prima pornire Jarock](ro/first-run.md) |
| `ru` | [Первый запуск Jarock](ru/first-run.md) |
| `es` | [Primer arranque de Jarock](es/first-run.md) |
| `sv` | [Första starten av Jarock](sv/first-run.md) |
| `sl` | [Prvi zagon Jarocka](sl/first-run.md) |
| `ta` | [Jarock முதல் தொடக்கம்](ta/first-run.md) |
| `th` | [การเริ่มต้น Jarock ครั้งแรก](th/first-run.md) |
| `tr` | [Jarock ilk çalıştırma](tr/first-run.md) || `uk` | [Перший запуск Jarock](uk/first-run.md) |

## Installation and fallback translations

Every supported locale has translated visible document titles for the server, network, and NeoForge fallback guides. Technical filenames remain stable so links, release packages and maintenance scripts continue to work.

| Locale | Server guide | NeoForge fallback | Network guide |
|---|---|---|---|
| `af` | [Fabric-bedienergids](af/server-guide.md) | [NeoForge-terugvalgids](af/neoforge-fallback.md) | [Gids vir netwerk, firewall en router](af/network-and-ports.md) |
| `ar` | [دليل خادم Fabric](ar/server-guide.md) | [دليل NeoForge الاحتياطي](ar/neoforge-fallback.md) | [دليل الشبكة وجدار الحماية والموجّه](ar/network-and-ports.md) |
| `ca` | [Guia del servidor Fabric](ca/server-guide.md) | [Guia alternativa NeoForge](ca/neoforge-fallback.md) | [Guia de xarxa, tallafocs i router](ca/network-and-ports.md) |
| `zh-CN` | [Fabric 服务器指南](zh-CN/server-guide.md) | [NeoForge 后备指南](zh-CN/neoforge-fallback.md) | [网络、防火墙和路由器指南](zh-CN/network-and-ports.md) |
| `zh-TW` | [Fabric 伺服器指南](zh-TW/server-guide.md) | [NeoForge 備用指南](zh-TW/neoforge-fallback.md) | [網路、防火牆和路由器指南](zh-TW/network-and-ports.md) |
| `hr` | [Vodič za Fabric poslužitelj](hr/server-guide.md) | [NeoForge rezervni vodič](hr/neoforge-fallback.md) | [Vodič za mrežu, vatrozid i usmjerivač](hr/network-and-ports.md) |
| `cs` | [Průvodce serverem Fabric](cs/server-guide.md) | [Záložní průvodce NeoForge](cs/neoforge-fallback.md) | [Průvodce sítí, firewallem a routerem](cs/network-and-ports.md) |
| `nl` | [Fabric-serverhandleiding](nl/server-guide.md) | [NeoForge-terugvalhandleiding](nl/neoforge-fallback.md) | [Gids voor netwerk, firewall en router](nl/network-and-ports.md) |
| `fa` | [راهنمای سرور Fabric](fa/server-guide.md) | [راهنمای پشتیبان NeoForge](fa/neoforge-fallback.md) | [راهنمای شبکه، فایروال و روتر](fa/network-and-ports.md) |
| `fr` | [Guide du serveur Fabric](fr/server-guide.md) | [Guide de secours NeoForge](fr/neoforge-fallback.md) | [Réseau, pare-feu et routeur](fr/network-and-ports.md) |
| `gl` | [Guía do servidor Fabric](gl/server-guide.md) | [Guía de reserva NeoForge](gl/neoforge-fallback.md) | [Guía de rede, firewall e router](gl/network-and-ports.md) |
| `de` | [Fabric-Serverhandbuch](de/server-guide.md) | [NeoForge-Ausweichhandbuch](de/neoforge-fallback.md) | [Netzwerk-, Firewall- und Router-Konfiguration](de/network-and-ports.md) |
| `he` | [מדריך שרת Fabric](he/server-guide.md) | [מדריך חלופי NeoForge](he/neoforge-fallback.md) | [מדריך רשת, חומת אש ונתב](he/network-and-ports.md) |
| `hu` | [Fabric szerver útmutató](hu/server-guide.md) | [NeoForge tartalék útmutató](hu/neoforge-fallback.md) | [Hálózati, tűzfal és router útmutató](hu/network-and-ports.md) |
| `id` | [Panduan server Fabric](id/server-guide.md) | [Panduan cadangan NeoForge](id/neoforge-fallback.md) | [Panduan jaringan, firewall, dan router](id/network-and-ports.md) |
| `it` | [Server Minecraft Java 26.2 con Fabric](it/server-guide.md) | [Fallback NeoForge per Minecraft Java 26.2](it/neoforge-fallback.md) | [Guida a rete, firewall e router](it/network-and-ports.md) |
| `ja` | [Fabric サーバーガイド](ja/server-guide.md) | [NeoForge フォールバックガイド](ja/neoforge-fallback.md) | [ネットワーク、ファイアウォール、ルーターガイド](ja/network-and-ports.md) |
| `ko` | [Fabric 서버 안내서](ko/server-guide.md) | [NeoForge 대체 안내서](ko/neoforge-fallback.md) | [네트워크, 방화벽 및 라우터 가이드](ko/network-and-ports.md) |
| `lv` | [Fabric servera rokasgrāmata](lv/server-guide.md) | [NeoForge rezerves rokasgrāmata](lv/neoforge-fallback.md) | [Tīkla, ugunsmūra un maršrutētāja rokasgrāmata](lv/network-and-ports.md) |
| `ms` | [Panduan pelayan Fabric](ms/server-guide.md) | [Panduan sandaran NeoForge](ms/neoforge-fallback.md) | [Panduan rangkaian, firewall dan penghala](ms/network-and-ports.md) |
| `mn` | [Fabric серверийн гарын авлага](mn/server-guide.md) | [NeoForge нөөц гарын авлага](mn/neoforge-fallback.md) | [Сүлжээ, галт хана болон чиглүүлэгчийн гарын авлага](mn/network-and-ports.md) |
| `pl` | [Poradnik serwera Fabric](pl/server-guide.md) | [Poradnik awaryjny NeoForge](pl/neoforge-fallback.md) | [Przewodnik po sieci, zaporze i routerze](pl/network-and-ports.md) |
| `pt` | [Guia do servidor Fabric](pt/server-guide.md) | [Guia de fallback NeoForge](pt/neoforge-fallback.md) | [Guia de rede, firewall e router](pt/network-and-ports.md) |
| `ro` | [Ghid pentru server Fabric](ro/server-guide.md) | [Ghid de rezervă NeoForge](ro/neoforge-fallback.md) | [Ghid de rețea, firewall și router](ro/network-and-ports.md) |
| `ru` | [Руководство сервера Fabric](ru/server-guide.md) | [Резервное руководство NeoForge](ru/neoforge-fallback.md) | [Руководство по сети, брандмауэру и роутеру](ru/network-and-ports.md) |
| `es` | [Guía del servidor Fabric](es/server-guide.md) | [Guía alternativa de NeoForge](es/neoforge-fallback.md) | [Guía de red, firewall y router](es/network-and-ports.md) |
| `sv` | [Fabric-serverguide](sv/server-guide.md) | [NeoForge-reservguide](sv/neoforge-fallback.md) | [Guide för nätverk, brandvägg och router](sv/network-and-ports.md) |
| `sl` | [Vodnik za strežnik Fabric](sl/server-guide.md) | [Rezervni vodnik NeoForge](sl/neoforge-fallback.md) | [Vodnik za omrežje, požarni zid in usmerjevalnik](sl/network-and-ports.md) |
| `ta` | [Fabric சேவையக வழிகாட்டி](ta/server-guide.md) | [NeoForge மாற்று வழிகாட்டி](ta/neoforge-fallback.md) | [பிணையம், ஃபயர்வால் மற்றும் ரௌட்டர் வழிகாட்டி](ta/network-and-ports.md) |
| `th` | [คู่มือเซิร์ฟเวอร์ Fabric](th/server-guide.md) | [คู่มือทางเลือก NeoForge](th/neoforge-fallback.md) | [คู่มือเครือข่าย ไฟร์วอลล์ และเราเตอร์](th/network-and-ports.md) |
| `tr` | [Fabric sunucu kılavuzu](tr/server-guide.md) | [NeoForge yedek kılavuzu](tr/neoforge-fallback.md) | [Ağ, Güvenlik Duvarı ve Yönlendirici Kılavuzu](tr/network-and-ports.md) |
| `uk` | [Посібник сервера Fabric](uk/server-guide.md) | [Резервний посібник NeoForge](uk/neoforge-fallback.md) | [Посібник із мережі, брандмауера та маршрутизатора](uk/network-and-ports.md) |

The English guides remain authoritative for detailed network setup, troubleshooting, backup paths, compatibility checks and security warnings. Localized files preserve technical literals, commands, paths, keys and URLs.

## Loader policy

Fabric is the first choice for native optimization and technical mods. NeoForge is the final loader fallback when a required mod is unavailable or unsuitable on Fabric. Forge is currently displayed as unavailable until an official Minecraft 26.2 server build is verified. Forge and NeoForge are distinct loaders; never install a Forge mod on NeoForge unless the mod author explicitly provides compatibility.
