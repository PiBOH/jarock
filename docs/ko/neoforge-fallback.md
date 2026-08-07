# NeoForge 대체 안내서

Fabric이 맞지 않을 때만 NeoForge를 마지막 대안으로 사용합니다. Forge와 NeoForge는 다른 loader이고 mod는 NeoForge에 맞아야 합니다. 필요하면 Geyser/Floodgate를 추가하고 먼저 복사본에서 테스트하세요.

영어 전체 안내서를 참조하세요: [../en/neoforge-fallback.md](../en/neoforge-fallback.md)

<!-- jarock-safe-shutdown -->

## 안전한 종료

> `stop`을 입력하고 창을 열어 두세요. 닫기 전에 `CLEAN SHUTDOWN COMPLETE`와 `SAFE TO CLOSE`를 기다리세요. 두 번째 메시지가 없으면 로그와 충돌 보고서를 확인하고 필요하면 백업을 복원하세요.

<!-- jarock-updater -->


## Jarock 업데이트

> `scripts/version.txt`를 확인하고 서버를 중지한 뒤 `SAFE TO CLOSE`가 표시될 때까지 기다리세요. 그런 다음 `scripts/update-jarock.bat`을 실행합니다. 같은 베타/안정 채널의 새 릴리스를 찾고 확인 후 롤백 백업을 만듭니다. 월드, 런타임, 모드, 라이브러리와 로컬 설정은 유지되며 의존성은 없거나 유효하지 않을 때만 복구됩니다.

> 전체 패키지와 게시된 SHA-512 체크섬은 설치 전에 검증됩니다.

<!-- jarock-auto-update-check -->

## 시작 시 업데이트 확인

parameter-manager.bat에서 AUTO_UPDATE_CHECK=true로 설정하면 start-server.bat이 GitHub 릴리스를 읽기 전용으로 확인합니다. 호환되는 최신 Jarock을 알려 주지만 자동 설치는 하지 않습니다. 서버를 중지하고 SAFE TO CLOSE를 기다린 뒤 scripts/update-jarock.bat을 실행하세요. 기본값은 AUTO_UPDATE_CHECK=false입니다.
