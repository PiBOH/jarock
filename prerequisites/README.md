# Bundled Java prerequisites

This directory contains optional Windows installers for the Java runtime required by Jarock.

## Recommended installer

- `OpenJDK25U-jdk_x64_windows_hotspot.msi` — Eclipse Temurin JDK 25.0.4, Windows x64, recommended for Minecraft 26.2.
- SHA-256: `6e9d08f214b0b284c2d8a58a980761d976c6588145af9e3c75b22fc2982b6636`
- Official source: [Eclipse Adoptium Temurin releases](https://adoptium.net/temurin/releases/)

Install the JDK installer, not only a Java Runtime Environment. Jarock requires a 64-bit Java 25 or newer runtime. **During installation, enable the "Set JAVA_HOME variable" option** — it appears as a red X icon in the Custom Setup screen; click it and select "Will be installed on local hard drive". Without `JAVA_HOME`, Jarock may not find Java.

## Legacy installer

- `jre-8-windows-x64.exe` — legacy Java 8 x64 runtime (file version 8.0.5010.8).
- SHA-256: `d99eb213b11b84fed4d0ffbb7595c77c7b952035a9025ed062c2d9c95ea22a8e`
- Official source: [Oracle Java SE downloads](https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html)

This Java 8 installer is retained only for compatibility with older software. It is **not suitable for the Jarock Minecraft 26.2 server** and should not be used to start the server. Redistribution of this installer must comply with the applicable Oracle license and distribution terms; the maintainer has confirmed those rights for this repository.

## Installation

1. Close the server if it is running.
2. Run the recommended Temurin JDK 25 MSI installer.
3. Keep the default installation options unless you have a specific reason to change them.
4. Close and reopen Command Prompt or File Explorer after installation.
5. Run `start-server.bat` from the repository root.

Jarock validates the selected executable itself and does not rely on the Java version associated with `.jar` files. If automatic discovery still cannot find the JDK, place its JDK folder or its `bin\\java.exe` path in `java-home.txt` at the repository root.

The installers are tracked with Git LFS. A Git client without Git LFS may download pointer files instead of the binary installers; install Git LFS and run `git lfs pull` if an installer is unexpectedly only a small text file.
