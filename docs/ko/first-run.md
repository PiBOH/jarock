> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

# Jarock 최초 실행

## loader 선택

64비트 Java 25 이상 JDK를 설치하고 Temurin 설치 프로그램에서 JAVA_HOME을 활성화한 뒤 터미널을 다시 여세요. 항상 루트의 `start-server.bat` en `scripts/server-launch-settings.ini`을 실행하고 `server/server.jar`을 직접 열지 마세요.

## 설치 및 EULA

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

## 안전한 종료

Jarock은 loader와 고정된 mod를 자동으로 다운로드합니다. 첫 실행은 `server/eula.txt`를 만들고 보통 중지합니다. Minecraft EULA를 읽고 동의할 때만 `eula=false`를 `eula=true`로 바꾸세요. 첫 성공 실행 전에는 `online-mode=false`를 사용하지 마세요.

## 안전한 종료

다시 실행하여 world, Geyser, Floodgate가 완료될 때까지 기다리세요. `stop`을 입력한 뒤 `CLEAN SHUTDOWN COMPLETE`와 `SAFE TO CLOSE`가 표시될 때까지 창을 닫지 마세요. 오류에는 Suggested fix를 따르고 loader가 섞이면 백업 후 `clean-server-runtime.bat`을 실행하며 공개 전 `TODO.md`를 읽으세요.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

## 안전 참고

일반 인증을 사용하려면 첫 실행을 `online-mode=true`로 완료하세요.

## 안전 참고

업데이트를 설치하려면 서버를 안전하게 중지한 후 `scripts/update-jarock.bat`을 실행하세요.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-lan-addresses-ko -->

## LAN connection addresses

Technical note: after startup, Jarock prints the local LAN IPv4 address. Java players use server-port over TCP; Bedrock players use Geyser bedrock.port over UDP. If Geyser is absent, Bedrock is unavailable. The addresses are still printed when the ASCII ready banner is disabled. Public access requires separate manual router and firewall configuration.

<!-- jarock-console-close-protection -->

> **Windows 콘솔 닫기 보호:** While Jarock is running, the classic Windows console may show a warning when X is clicked. stop을 입력하고 SAFE TO CLOSE를 기다리세요. 월드 저장 중에는 강제 종료하지 마세요. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
