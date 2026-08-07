# Jarock 최초 실행

## loader 선택

64비트 Java 25 이상 JDK를 설치하고 Temurin 설치 프로그램에서 JAVA_HOME을 활성화한 뒤 터미널을 다시 여세요. 항상 루트의 `start-server.bat` en `scripts/server-launch-settings.ini`을 실행하고 `server/server.jar`을 직접 열지 마세요.

## 설치 및 EULA

`start-server.bat`을 실행하고 Fabric(권장), NeoForge(대체) 또는 Forge(Minecraft 26.2에서 현재 사용 불가)를 선택하세요. `parameter-manager.bat`에서 RAM, GUI/콘솔, GC, `online-mode`, 배너와 `AUTO_UPDATE_CHECK`를 설정할 수 있습니다. **Exit without saving**은 저장하지 않고 취소합니다.

## 안전한 종료

Jarock은 loader와 고정된 mod를 자동으로 다운로드합니다. 첫 실행은 `server/eula.txt`를 만들고 보통 중지합니다. Minecraft EULA를 읽고 동의할 때만 `eula=false`를 `eula=true`로 바꾸세요. 첫 성공 실행 전에는 `online-mode=false`를 사용하지 마세요.

## 안전한 종료

다시 실행하여 world, Geyser, Floodgate가 완료될 때까지 기다리세요. `stop`을 입력한 뒤 `CLEAN SHUTDOWN COMPLETE`와 `SAFE TO CLOSE`가 표시될 때까지 창을 닫지 마세요. 오류에는 Suggested fix를 따르고 loader가 섞이면 백업 후 `clean-server-runtime.bat`을 실행하며 공개 전 `TODO.md`를 읽으세요.

## 안전 참고

일반 인증을 사용하려면 첫 실행을 `online-mode=true`로 완료하세요.

## 안전 참고

업데이트를 설치하려면 서버를 안전하게 중지한 후 `scripts/update-jarock.bat`을 실행하세요.
