# 네트워크, 방화벽 및 라우터 가이드

64비트 Java 25를 설치하고 `start-server. (enable "Set JAVA_HOME variable" in the Temurin installer) (abilita Set JAVA_HOME nell’installer Temurin)bat`를 실행한 후 포트를 열기 전에 `TODO.md`를 완료하세요. 고정 LAN IP를 설정하고 Windows 방화벽에서 TCP `25565`(Java)와 UDP `19132`(Bedrock)를 열고 라우터에서 포트 포워딩을 구성하거나 playit.gg와 같은 UDP 호환 터널을 사용하세요. `online-mode=true`와 `white-list=true`가 활성화되어 있는지 확인하고 `key.pem`을 절대 공개하지 마세요. CGNAT의 경우 터널을 사용하세요. [영어 가이드](../en/network-and-ports.md)를 참조하세요.

> 항상 `start-server.bat`를 사용하고 `server.jar`를 더블 클릭하지 마세요.

> The whitelist is disabled by default in server.properties (white-list=false, enforce-whitelist=false); enable it (white-list=true, enforce-whitelist=true) before opening the server to the public.
