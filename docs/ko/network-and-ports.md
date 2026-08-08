# 네트워크, 방화벽 및 라우터 가이드

64비트 Java 25를 설치하고 `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat`를 실행한 후 포트를 열기 전에 `TODO.md`를 완료하세요. 고정 LAN IP를 설정하고 Windows 방화벽에서 TCP `25565`(Java)와 UDP `19132`(Bedrock)를 열고 라우터에서 포트 포워딩을 구성하거나 playit.gg와 같은 UDP 호환 터널을 사용하세요. `online-mode=true`와 `white-list=true`가 활성화되어 있는지 확인하고 `key.pem`을 절대 공개하지 마세요. CGNAT의 경우 터널을 사용하세요. [영어 가이드](../en/network-and-ports.md)를 참조하세요.

> 항상 `start-server.bat`를 사용하고 `server.jar`를 더블 클릭하지 마세요.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.

<!-- jarock-safe-shutdown -->

## 안전한 종료

> `stop`을 입력하고 창을 열어 두세요. 닫기 전에 `CLEAN SHUTDOWN COMPLETE`와 `SAFE TO CLOSE`를 기다리세요. 두 번째 메시지가 없으면 로그와 충돌 보고서를 확인하고 필요하면 백업을 복원하세요.

<!-- jarock-updater -->


## Jarock 업데이트

> `scripts/version.txt`를 확인하고 서버를 중지한 뒤 `SAFE TO CLOSE`가 표시될 때까지 기다리세요. 그런 다음 `scripts/update-jarock.bat`을 실행합니다. 같은 베타/안정 채널의 새 릴리스를 찾고 확인 후 롤백 백업을 만듭니다. 월드, 런타임, 모드, 라이브러리와 로컬 설정은 유지되며 의존성은 없거나 유효하지 않을 때만 복구됩니다.

> 전체 패키지와 게시된 SHA-512 체크섬은 설치 전에 검증됩니다.

<!-- jarock-auto-update-check -->

## 시작 시 업데이트 확인

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=never.
