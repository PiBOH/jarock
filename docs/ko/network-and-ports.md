# 네트워크, 방화벽 및 라우터 가이드

64비트 Java 25를 설치하고 `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat`를 실행한 후 포트를 열기 전에 `TODO.md`를 완료하세요. 고정 LAN IP를 설정하고 Windows 방화벽에서 TCP `25565`(Java)와 UDP `19132`(Bedrock)를 열고 라우터에서 포트 포워딩을 구성하거나 playit.gg와 같은 UDP 호환 터널을 사용하세요. `online-mode=true`와 `white-list=true`가 활성화되어 있는지 확인하고 `key.pem`을 절대 공개하지 마세요. CGNAT의 경우 터널을 사용하세요. [영어 가이드](../en/network-and-ports.md)를 참조하세요.

> 항상 `start-server.bat`를 사용하고 `server.jar`를 더블 클릭하지 마세요.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

> Technical note: Async is an experimental server-side Minecraft 26.2 mod installed for both Fabric and NeoForge. It processes entities in parallel, requires Java 25+, and may cause crashes, incorrect entity behavior or incompatibilities. Test it with a backup before public use; disable or remove its jar if the server becomes unstable.

<!-- jarock-safe-shutdown -->

## 안전한 종료

> `stop`을 입력하고 창을 열어 두세요. 닫기 전에 `CLEAN SHUTDOWN COMPLETE`와 `SAFE TO CLOSE`를 기다리세요. 두 번째 메시지가 없으면 로그와 충돌 보고서를 확인하고 필요하면 백업을 복원하세요.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Jarock 업데이트

> `scripts/version.txt`를 확인하고 서버를 중지한 뒤 `SAFE TO CLOSE`가 표시될 때까지 기다리세요. 그런 다음 `scripts/update-jarock.bat`을 실행합니다. 같은 베타/안정 채널의 새 릴리스를 찾고 확인 후 롤백 백업을 만듭니다. 월드, 런타임, 모드, 라이브러리와 로컬 설정은 유지되며 의존성은 없거나 유효하지 않을 때만 복구됩니다.

> 전체 패키지와 게시된 SHA-512 체크섬은 설치 전에 검증됩니다.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window without starting the server. The updater performs the check and asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## 시작 시 업데이트 확인

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified package matching scripts/jarock-edition.ini automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows 콘솔 닫기 보호:** While Jarock is running, the classic Windows console may show a warning when X is clicked. stop을 입력하고 SAFE TO CLOSE를 기다리세요. 월드 저장 중에는 강제 종료하지 마세요. Jarock relaunches its launchers in the classic Windows Console Host when they are started from Windows Terminal, so the close-event protection works there; other pseudo-terminals without a marker (for example Alacritty) are not auto-detected, and Windows can still force-terminate a console process after its short handler timeout.
