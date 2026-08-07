# Fabric 서버 안내서

64비트 Java 25를 설치하고 `start-server.bat`을 실행한 뒤 `parameter-manager.bat`으로 RAM과 GUI 또는 `nogui`를 설정합니다. (enable "Set JAVA_HOME variable" in the Temurin installer) `server/eula.txt`를 읽고 EULA에 동의하여 `eula=true`로 바꾸며 Fabric, Geyser-Fabric, Floodgate-Fabric을 사용하고 백업을 만드세요. Jarock은 라우터, 방화벽 또는 port forwarding을 변경하지 않습니다.

영어 전체 안내서를 참조하세요: [../en/server-guide.md](../en/server-guide.md)


> Jarock repairs an incomplete world automatically: if the world folder is missing required world-generation data, Jarock moves it aside (for example to server\world-corrupt-<date>) and generates a fresh world on the next start. If the moved folder contains data you need, stop the server and restore it from a backup.

> Do not set online-mode=false before the first server startup; let server.properties be created with online-mode=true first.
> The parameter manager also has a "Toggle ready banner" option: it shows or hides the ASCII-art banner printed when the server finishes loading. See the [full English guide](../en/server-guide.md).
> **기술 참고: 항상 저장소 루트의 `start-server.bat`을 사용하세요. `server.jar`를 두 번 클릭하지 마세요. Windows가 Java 8 또는 Java 21을 사용할 수 있지만 Minecraft 26.2에는 64비트 Java 25 이상이 필요합니다. [전체 영어 안내서](../en/server-guide.md)를 참조하세요.**
