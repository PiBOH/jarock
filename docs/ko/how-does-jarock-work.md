# Jarock은 어떻게 작동하나요?

## 서버 작동 방식 쉽게 이해하기

**Minecraft:** Java Edition `26.2` (enable "Set JAVA_HOME variable" in the Temurin installer)
**로더:** Fabric
**주요 플랫폼:** Windows 10/11

이 문서는 Jarock을 다운로드한 뒤 실제로 어떤 일이 일어나는지 설명합니다.


> Technical fallback note: DedicatedPower is a Fabric-only mod: it is updated automatically from its latest GitHub release, while the other server mods are pinned and verified with SHA-512. Links In Chat is also included as a verified server-side Fabric 26.2 mod; it makes chat URLs clickable and adds `/link` and `/linkwhisper`, without requiring client installation. Welcome Message 2.8 with its required Collective library is included as a verified server-side Minecraft 26.2 mod for Fabric and NeoForge; it sends configurable join messages.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> **유지 관리 참고:** 실행기는 `PATH`의 첫 번째 `java.exe`만 사용하지 않고 호환되는 64비트 Java 25 이상 런타임을 검색합니다. `scripts/java-runtime.ps1`을 사용하고 선택한 실행 파일을 `server/java-path.txt`에 저장하며 시작 전에 다시 확인합니다. Java 8은 설치된 상태로 둘 수 있습니다.

## 1. 요약

사용자는 지원되는 64비트 Java를 설치하고 이 repository를 다운로드한 뒤 `start-server.bat`을 실행합니다. 프로그램은 자신의 폴더를 찾고 Java와 경로를 확인합니다. 필요한 경우 Windows 긴 경로 지원을 요청하고, 고정된 Fabric installer와 mods를 다운로드한 다음 각 파일을 SHA-512로 검증합니다.

Fabric은 `server/`에 runtime을 만듭니다. 첫 실행에서는 `server/eula.txt`가 `eula=false`로 생성되고 중지됩니다. 사용자는 <https://www.minecraft.net/eula>를 읽고 동의할 경우 `eula=true`로 바꾼 뒤 다시 실행해야 합니다. Geyser는 Bedrock 트래픽을 변환하고 Floodgate는 Bedrock 인증을 처리합니다.

Jarock은 router, firewall 또는 port forwarding을 **설정하지 않습니다**.

## 2. 파일과 실행 흐름

repository에는 scripts, 템플릿, manifest가 있지만 월드나 생성된 `.jar` 파일은 포함되지 않습니다.

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

runtime은 `server/`에 생성됩니다. 월드, logs, 라이브러리, 개인 키와 로컬 목록은 Git에서 제외됩니다.

`start-server.bat`은 `C:\MinecraftServer` 같은 고정 경로가 아니라 자신의 위치를 사용합니다. 따라서 공백, Unicode, `!`, 중첩 폴더가 포함된 접근 가능한 경로를 지원합니다. 긴 경로에서는 다음 값을 확인합니다.

```text
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled
```

필요하면 관리자 권한을 요청하고 `scripts\enable-long-paths.ps1`을 실행합니다. 이 변경은 시스템 전체에 적용되며 오래된 프로그램은 Windows 재시작이 필요할 수 있습니다.

## 3. EULA, Geyser와 오류

첫 실행은 `server/eula.txt`를 `eula=false`로 만들고 중지합니다. EULA를 읽고 동의한다면 `eula=true`로 변경한 뒤 다시 실행합니다.

Geyser는 첫 번째 실제 서버 실행 중 전체 설정을 생성합니다. 파일이 만들어진 후 스크립트는 다음에 설정합니다.

```text
server\config\Geyser-Fabric\config.yml
```

```yaml
auth-type: floodgate
```

Java는 보통 TCP `25565`, Bedrock은 UDP `19132`를 사용합니다. Jarock은 포트를 열지 않습니다. `key.pem`은 비밀 파일이므로 공개하지 마세요.

오류가 발생하면 `ERROR:` 또는 `WARNING:`을 읽고 `Suggested fix:`를 따르세요. Java가 종료되면 `server\logs\latest.log` 또는 `server\crash-reports\`에서 첫 번째 `Caused by:`를 확인하세요. 남은 작업은 `TODO.md`에 있습니다.

> **기술 참고: 항상 저장소 루트의 `start-server.bat`을 사용하세요. `server.jar`를 두 번 클릭하지 마세요. Windows가 Java 8 또는 Java 21을 사용할 수 있지만 Minecraft 26.2에는 64비트 Java 25 이상이 필요합니다. [전체 영어 안내서](../en/how-does-jarock-work.md)를 참조하세요.**

> Better Multiplayer Sleep is a verified Minecraft 26.2 datapack. Jarock installs it into the configured world's `datapacks` folder for Fabric and NeoForge without replacing the world or other datapacks; use `/reload` after manual changes.

> No Chat Reports is a verified Minecraft 26.2 server-side mod for Fabric and NeoForge. It prevents the server from forwarding signed chat-reporting data; vanilla clients may still show unsigned-chat warnings, and Jarock does not automatically change `enforce-secure-profile`.

> Essential Commands 0.41.0 with its required `ec-core` 1.3.0 component is verified for Minecraft 26.2 on Fabric only. It adds useful server commands; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> InvView 1.4.21 is a verified Minecraft 26.2 server-side Fabric mod. It requires Fabric API and lets authorized operators inspect and manage online or offline player inventories and ender chests; no compatible NeoForge 26.2 build is available, so NeoForge does not install it.

> OfflineCommands 1.0.3 is a verified Minecraft 26.2 server-side Fabric mod for running commands on offline players. No compatible NeoForge 26.2 build is available, so NeoForge does not install it.

<!-- jarock-safe-shutdown -->

## 안전한 종료

> `stop`을 입력하고 창을 열어 두세요. 닫기 전에 `CLEAN SHUTDOWN COMPLETE`와 `SAFE TO CLOSE`를 기다리세요. 두 번째 메시지가 없으면 로그와 충돌 보고서를 확인하고 필요하면 백업을 복원하세요.
> Technical fallback note: When `stop` is detected, Jarock prints a notice that the world is being saved, then prints the final `SAFE TO CLOSE` confirmation directly in the server console as soon as the save completes, in both `gui` and `nogui` modes. Keep the window open until that message appears.

<!-- jarock-updater -->


## Jarock 업데이트

> `scripts/version.txt`를 확인하고 서버를 중지한 뒤 `SAFE TO CLOSE`가 표시될 때까지 기다리세요. 그런 다음 `scripts/update-jarock.bat`을 실행합니다. 같은 베타/안정 채널의 새 릴리스를 찾고 확인 후 롤백 백업을 만듭니다. 월드, 런타임, 모드, 라이브러리와 로컬 설정은 유지되며 의존성은 없거나 유효하지 않을 때만 복구됩니다.

> 전체 패키지와 게시된 SHA-512 체크섬은 설치 전에 검증됩니다.

> You can also choose `U. Check for Jarock updates` in `parameter-manager.bat` to run the same check without starting the server. If a verified compatible Lite package is available, the updater asks `Download and install it now? (y/N)`; Enter or `N` leaves the installation unchanged.

<!-- jarock-auto-update-check -->

## 시작 시 업데이트 확인

Startup update modes: AUTO_UPDATE_MODE=install checks for a compatible release and installs the verified Lite package automatically; AUTO_UPDATE_MODE=check checks for updates only and never installs; AUTO_UPDATE_MODE=never does not check for updates and does not install updates. The default is AUTO_UPDATE_MODE=install; choose check or never in parameter-manager.bat to override it.

<!-- jarock-console-close-protection -->

> **Windows 콘솔 닫기 보호:** While Jarock is running, the classic Windows console may show a warning when X is clicked. stop을 입력하고 SAFE TO CLOSE를 기다리세요. 월드 저장 중에는 강제 종료하지 마세요. This is best effort only: Windows Terminal and Alacritty pseudoconsole tabs may not deliver the close event, and Windows can force-terminate the process after its short handler timeout.
