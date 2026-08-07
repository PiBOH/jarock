# Fabric 서버 안내서

64비트 Java 25를 설치하고 `start-server.bat`을 실행한 뒤 `parameter-manager.bat`으로 RAM과 GUI 또는 `nogui`를 설정합니다. (enable "Set JAVA_HOME variable" in the Temurin installer) `server/eula.txt`를 읽고 EULA에 동의하여 `eula=true`로 바꾸며 Fabric, Geyser-Fabric, Floodgate-Fabric을 사용하고 백업을 만드세요. Jarock은 라우터, 방화벽 또는 port forwarding을 변경하지 않습니다.

영어 전체 안내서를 참조하세요: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The whitelist is disabled by default (white-list=false, enforce-whitelist=false in server.properties). Before opening the server to the public, set both to true and add players with: whitelist add <name>.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> If no compatible Java 25+ is found, start-server.bat launches the bundled Java installers in order: the legacy Java 8 runtime (jre-8-windows-x64.exe) first, then the Eclipse Temurin JDK 25 MSI (OpenJDK25U-jdk_x64_windows_hotspot.msi). Accept each UAC prompt and let the installers finish.
> **기술 참고: 항상 저장소 루트의 `start-server.bat`을 사용하세요. `server.jar`를 두 번 클릭하지 마세요. Windows가 Java 8 또는 Java 21을 사용할 수 있지만 Minecraft 26.2에는 64비트 Java 25 이상이 필요합니다. [전체 영어 안내서](../en/server-guide.md)를 참조하세요.**

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
