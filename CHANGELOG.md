# Changelog

## [0.0.123-beta]

- Fixed the GitHub Actions baseline TUI build on Windows runners by moving the isolated Bun compilation workspace to `C:\\jarock-tui-build`. Bun's baseline runtime download and cache now stay on the same volume, avoiding the known cross-device rename (`XDEV`) failure.
- Kept the baseline target and the normal `start-server.bat` entry point for every CLI/TUI and Full/Lite edition.

## [0.0.122-beta]

- Updated the Windows TUI release build from Bun 1.3.0 to Bun 1.3.14. Bun 1.3.0 successfully built the modern Windows target but failed consistently when compiling the `bun-windows-x64-baseline` target required by older CPUs.
- Kept `bun-windows-x64-baseline`, so TUI packages remain suitable for CPUs without AVX2, including Intel Westmere-era processors.

## [0.0.121-beta]

- Added readable TUI diagnostics alongside numeric Windows exit codes. The launchers now explain common failures such as `STATUS_ILLEGAL_INSTRUCTION` (`0xC000001D`, usually an incompatible CPU target) and missing native DLLs (`0xC0000135`) for both the server and parameter-manager TUI.
- Added reason and command context to Windows CI build and smoke-test failures so a failed TUI release run is easier to diagnose from the workflow summary.

## [0.0.120-beta]

- Fixed the Windows TUI icon build by generating a legacy BGRA/DIB ICO instead of a PNG-in-ICO wrapper. Bun can now embed the official Jarock icon reliably while compiling the baseline Windows executable for older CPUs.
- Kept both standalone TUI and native OpenTUI smoke builds on `bun-windows-x64-baseline` for CPUs without AVX2.

## [0.0.119-beta]

- Changed both Windows TUI compilations to Bun's `bun-windows-x64-baseline` target, avoiding AVX2-dependent `0xC000001D` Illegal Instruction crashes on older or less capable x64 CPUs.
- Kept the Jarock application icon and native OpenTUI smoke-test build on the compatibility target.

## [0.0.118-beta]

- Updated the Windows TUI build to use the official Jarock `icon.png` as the `jarock-tui.exe` application icon through Bun's `--windows-icon` option.
- Added a dependency-free PNG-to-ICO build helper and applied the same icon to the native TUI smoke executable.

## [0.0.117-beta]

- Fixed `start-server.bat` losing control after the startup update check by calling its isolated runner explicitly. Unexpected TUI exits now remain visible with an actionable error and pause instead of closing the console silently.
- Added the same visible failure handling to the TUI parameter manager and extended the startup-update regression checks.

## [0.0.116-beta]

- Fixed automatic release packaging so `jarock-tui-full` includes both bundled Java prerequisite installers, matching `jarock-cli-full`. Lite packages continue to exclude the installers.
- Added archive validation that rejects Full packages missing either installer or Lite packages containing prerequisites.

## [0.0.115-beta]

- Fixed TUI-launched `start-server.bat`, `parameter-manager.bat` and other operations from being relaunched asynchronously when Windows Terminal was the parent host. TUI child processes now explicitly carry the classic-console context, so startup updates finish before the server flow continues and the parameter manager receives control correctly.
- Added regression assertions for the TUI classic-console environment handoff.

## [Unreleased]

- Linked the README technology and environment badges to their official Minecraft, OpenJDK, Geyser, Fabric and NeoForge pages, and split the combined loader badge so each loader has its own destination.

## [0.0.114-beta]

- Fixed the standalone Windows TUI build by declaring OpenTUI's `web-tree-sitter@0.25.10` peer dependency explicitly, allowing Bun to resolve and embed `web-tree-sitter/tree-sitter.wasm` during compilation.
- Added a CI preflight that verifies the Tree-sitter WASM asset is installed before either standalone TUI compilation.
- Synchronized the TUI package version and lockfile with the release version.

## [0.0.113-beta]

- Fixed the Windows TUI release build by explicitly bundling OpenTUI's `@opentui/core-win32-x64` native backend in both the main executable and renderer smoke test.
- Updated the GitHub Actions build to compile from the TUI package directory, validate output files and report Bun compilation failures clearly; the workflow now consumes OpenTUI's prebuilt native DLL without an unnecessary Zig setup step.

## [0.0.112-beta]

- Completed the Windows CLI/TUI release integration: manual workflow-dispatch versions are now written into `scripts/version.txt` inside every generated package, so the installed package version always matches its release tag.
- Fixed the automatic-release TUI smoke test to launch `jarock-tui.exe --smoke`, initialize the renderer, and exit without waiting for interactive input.
- Kept the installed CLI/TUI and Full/Lite edition unchanged during verified updates, including legacy asset aliases for pre-TUI installations.

## [0.0.111-beta] - 2026-08-11

### Added

- Added Windows CLI and TUI release families: `jarock-cli-full`, `jarock-cli-lite`, `jarock-tui-full` and `jarock-tui-lite`.
- Added `scripts/jarock-edition.ini` so launchers and the updater preserve the installed interface and Full/Lite tier.
- Added the OpenTUI-based `jarock-tui.exe` central menu for server startup, updates, world operations, parameter management and runtime cleanup.
- Kept legacy `jarock-full` and `jarock-lite` asset aliases so pre-TUI installations remain updateable.

### Changed

- TUI packages route both `start-server.bat` and `parameter-manager.bat` through the Windows TUI; CLI packages retain the classic command-line flow.
- Automatic updates now select the matching `cli/tui` and `full/lite` package instead of always downloading a Lite CLI archive.

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.110-beta] - 2026-08-11

### Fixed

- Added a temporary legacy compatibility alias, `server/config/welcomemessage.json5.template-jarock`, to both Full and Lite release archives. This allows installations running the 0.0.108-beta updater to install the renamed `server/config/welcomemessage.json5.jarock` package successfully. The alias is generated only during release packaging and is removed automatically by the bootstrap after the update.
- Added release-package and updater regression checks for both Welcome Message filenames so future renames cannot break automatic updates from older installations.

## [0.0.109-beta] - 2026-08-11

### Changed

- Renamed the Jarock Welcome Message configuration template from `server/config/welcomemessage.json5.template-jarock` to `server/config/welcomemessage.json5.jarock` and updated every reference (bootstrap, updater, cleanup script, tests, GitHub workflows and documentation). The updater still treats the file as a committed project file that is always refreshed from the package: the always-refresh classification now also covers the `.jarock` suffix. Existing installations are migrated automatically: on the next start the bootstrap removes a stale legacy copy of the old file, keeping only the renamed template.

## [0.0.108-beta] - 2026-08-11

### Added

- Jarock now forces its launcher windows to open in the classic Windows Console Host (`cmd`) instead of Windows Terminal: when `start-server.bat`, `parameter-manager.bat`, `clean-server-runtime.bat` or `scripts/update-jarock.bat` detects that it is running inside Windows Terminal (the `WT_SESSION` variable), it temporarily points the documented `HKCU\Console\DelegationConsole` default-terminal value at the classic console CLSID, relaunches itself in a classic console window, and restores the previous value immediately. Windows that Jarock opens itself (the parameter manager from the first-run bootstrap, and the separate updater window) are created through the same mechanism. The console close-event protection therefore works reliably for Jarock windows; pseudo-terminals without a marker (for example Alacritty) are not auto-detected and are documented as such.

## [0.0.107-beta] - 2026-08-10

### Fixed

- Fixed remembered world imports prompting to overwrite the active world after the parameter manager saved the settings again. A remembered source is now always treated as a recovery source: it is used only when the configured world folder is absent, while an existing world is kept without a confirmation prompt. The regression test now covers the exact `WORLD_IMPORT_REMEMBER=true` and `WORLD_IMPORT_APPLIED=false` state produced by the parameter manager.

## [0.0.106-beta] - 2026-08-10

### Fixed

- Guaranteed that updates download and install `server/config/welcomemessage.json5.jarock` even when the file is not present among the installed server files: the updater now rejects a Lite package that does not contain the template before applying anything, and verifies after application that the template exists, restoring it from the stage if it is missing for any reason.
- Extended the committed updater regression test (`test-updater-protection.ps1`) to cover the package validation: a package containing the template is accepted, a package without it is rejected, and the rejection message identifies the missing template.

## [0.0.105-beta] - 2026-08-10

### Fixed

- Ensured `server/config/welcomemessage.json5.jarock` is always applied when updating from older versions: the updater now treats committed server templates and manifests as project files even when the current installation predates them, so the Welcome Message template is no longer mistaken for generated runtime configuration and left missing after an update.
- Made the server bootstrap self-healing: if the Welcome Message template is missing (for example after an update from a version created before the template existed), the bootstrap restores the standard Jarock template automatically at startup instead of failing.
- Extended the Windows update regression test to cover an older installation without the template and the bootstrap test to verify automatic template restoration.

## [0.0.104-beta] - 2026-08-10

### Fixed

- Preserved `server/config/welcomemessage.json5.jarock` during `clean-server-runtime.bat` cleanup.
- Updated the Lite-package updater so the Welcome Message project template is refreshed during verified updates instead of being treated as generated runtime configuration. Added cleanup and update regression coverage.

## [0.0.103-beta] - 2026-08-10

### Fixed

- Updated `clean-server-runtime.bat` and its PowerShell implementation so the tracked `server/icon.png` and `server/server-icon.png` are preserved during runtime cleanup; an optional `server/logo.png` is preserved too when present. The repository-root `icon.png` and `logo.png` remain outside the cleanup scope and are explicitly documented as preserved. Added a Windows regression test covering all server-scoped and root icon files while confirming generated runtime files are still removed.

## [0.0.102-beta] - 2026-08-10

### Added

- Added the tracked `server/icon.png` runtime icon and included it in both Full and Lite automatic release ZIPs. The workflow now requires the root world icon and validates both server-scoped icons (`server/icon.png` and `server/server-icon.png`) as 64×64 PNG files; the Windows bootstrap test also verifies the runtime icon.

## [0.0.101-beta] - 2026-08-10

### Added

- Added the experimental server-side `Async` mod for Minecraft 26.2 to both the Fabric and NeoForge manifests, with pinned Modrinth downloads and SHA-512 verification. Fabric uses the compatible build with its required Fabric API; NeoForge uses its dedicated build. Because Async is alpha software and can cause crashes or incorrect entity behavior, the localized documentation now warns operators to test it with a backup and remove it if the server becomes unstable.
- Fixed the Windows bootstrap regression harness so its Welcome Message validation state is initialized before idempotency checks run.

## [0.0.100-beta] - 2026-08-10

### Changed

- Changed `U. Check for Jarock updates` in `parameter-manager.bat` to open `scripts/update-jarock.bat` in a separate window. The existing updater now owns the complete check, confirmation, checksum, backup and rollback flow without starting the server from the parameter manager; the old parameter-manager session closes after the updater window is launched so it cannot save stale settings after a self-update.
- Updated the README and localized documentation to describe the separate updater window.

## [0.0.99-beta] - 2026-08-10

### Fixed

- Recreated `server/server-icon.png` as an optimized 64×64 RGB PNG, the native Minecraft multiplayer server-list icon resolution, while preserving the existing Jarock artwork.

## [0.0.98-beta] - 2026-08-10

### Fixed

- Fixed the auto-release validation so a push release commit must change `scripts/version.txt` and the changelog must contain a matching `## [version]` section, without requiring both files to change in the same commit.

## [0.0.97-beta] - 2026-08-10

### Added

- Added `U. Check for Jarock updates` to `parameter-manager.bat`. It checks GitHub without starting the server and asks `Download and install it now? (y/N)` before applying a verified compatible Lite package; Enter or `N` leaves the installation unchanged. The manager runs through an isolated runner so a self-update cannot corrupt the open batch session.

### Fixed

- Fixed the `parameter-manager.bat` main menu alignment so the current-value brackets line up in one consistent column for loader, RAM, banner, world import/export and startup update settings, including the longer option labels.

## [0.0.96-beta] - 2026-08-10

### Added

- Added the Jarock Welcome Message configuration template at `server/config/welcomemessage.json5.jarock`. During the first Jarock-managed startup it replaces the mod's generic `welcomemessage.json5` with the configured Jarock welcome messages and links, then preserves later operator edits through a local marker.

## [0.0.94-beta] - 2026-08-09

### Added

- Added Jarock icon defaults: the tracked root `icon.png` is copied to a new world's `icon.png` only when the world does not already have a custom icon, while the tracked `server/server-icon.png` is used for the Minecraft multiplayer server-list icon.
- The auto-release workflow now requires both icon files to be tracked and packages them in both Full and Lite ZIPs. Added bootstrap regression coverage and documented the icon behavior.

## [0.0.93-beta] - 2026-08-09

### Added

- Added a persistent world-import choice to `parameter-manager.bat`: after selecting a folder or `.zip`, Jarock asks `Remember this world for future starts? (Y/n)` with Yes as the default. When remembered, `WORLD_IMPORT_SOURCE` remains saved and restores the world only after the configured world is later deleted; normal restarts keep the active world and never overwrite it. Answering `n` preserves the previous one-shot import behavior.
- Extended the world-transfer regression test and all world-import documentation with remembered-source behavior, including `WORLD_IMPORT_REMEMBER` and the internal `WORLD_IMPORT_APPLIED` state.

## [0.0.92-beta] - 2026-08-09

### Fixed

- Fixed the three NeoForge manifest assertions in the Windows bootstrap test. Their version patterns used double-escaped dots (`\\.`), which searched for a literal backslash; they now correctly match the `26.2` filenames for Collective, Welcome Message and No Chat Reports.

## [0.0.91-beta] - 2026-08-09

### Fixed

- The Windows bootstrap regression test now checks the actual Welcome Message configuration generated by the mod: `server/config/welcomemessage.json5`.

## [0.0.90-beta] - 2026-08-09

### Fixed

- The Windows first-run bootstrap test no longer fails on a fresh checkout: `Confirm-LoaderChange` in `bootstrap-server.ps1` now keys the "previous runtime without a loader marker" guard on loader engine artifacts only (`server.jar`, `vanilla-server.jar`, `fabric-server-launch.jar`, `run.bat`, `libraries`). A stray `server/mods` folder or leftover jar no longer blocks startup, because the pinned mod manifest is re-verified and overwritten deterministically anyway. This also lets the CI harness seed the legacy `welcome_awa` artifact on a clean tree to verify its removal.

## [0.0.89-beta] - 2026-08-09

### Changed

- The `test.yml` and `test-world-transfer.yml` workflows now capture the full test output and, when a step fails, emit the last 60 log lines as workflow annotations so CI-only failures can be diagnosed from the run summary without downloading logs.

## [0.0.88-beta] - 2026-08-09

### Added

- The repository README now shows the Jarock logo (`logo.png`) and a set of status badges: latest release (beta channel), MIT license, the live GitHub Pages website, last commit, Minecraft 26.2 / Java 25 / Geyser cross-play / loader tags, and build status for the Windows bootstrap, update, world-transfer, console-close-protection and startup-update test workflows.

## [0.0.87-beta] - 2026-08-09

### Fixed

- The ready-status `seed:` line now works on Minecraft 26.2 worlds: the seed is read from `world/data/minecraft/world_gen_settings.dat` (`data.seed`), where 26.2 stores the world generation settings, with the legacy `level.dat` (`Data.WorldGenSettings.seed`) kept as a fallback for older worlds. Previously the launcher only looked inside `level.dat`, which no longer contains the seed in 26.2, so the banner always reported `unavailable`.
- The ready banner no longer overwrites an already-detected seed with `unavailable` when the NBT fallback cannot be read: a seed captured from the server log is preserved in that case.
- The Windows bootstrap regression test now asserts that the ready status prints a numeric `seed:` value.

## [0.0.86-beta] - 2026-08-09

### Added

- **World import and export** from `parameter-manager.bat`:
  - `I. Import world` accepts the full path of a world folder (containing `level.dat`) or of a `.zip` world archive. On the next `start-server.bat` run the world is imported into the configured `level-name` folder before the server starts. If a world already exists there, the operator is asked for confirmation and the existing world is first moved aside as `server/<name>_originalbkp` (with a timestamp suffix when that name is already taken); for a non-remembered import the request is cleared automatically so it never repeats; the new `Remember this world for future starts? (Y/n)` choice keeps the source when requested without overwriting an existing world on normal restarts. The source folder or archive is never modified.
  - `E. Export world` accepts a destination folder outside `server/`; after every clean shutdown (`stop` + `SAFE TO CLOSE`) the world is mirrored into that destination, overwriting it. Exports are refused for destinations inside the server folder so an export can never be mistaken for local world data.
  - Paths can be typed manually, removed with `CLEAR`, or picked with a Windows folder dialog when the input is left empty. They are stored locally in `scripts/server-launch-settings.ini` (`WORLD_IMPORT_SOURCE`, `WORLD_EXPORT_DEST`), which is ignored by Git and recognized by the settings validator and updater.
- Added `scripts/world-transfer.ps1` (shared import/export helpers with zip-traversal and destination safety checks), `scripts/pick-folder.ps1` (folder dialog helper), `scripts/test-world-transfer.ps1` and the `test-world-transfer.yml` workflow that exercises folder, zip, backup and export behavior on Windows PowerShell 5.1 and PowerShell 7 without Java or network access.
- Import backups (`<name>_originalbkp*`) are excluded from Git and are ignored by the launcher's orphan-world check, so the automatic backup can never be mistaken for previous world data on the next start.
- Documented world import/export in the English and Italian server guides, the root README, the documentation index and all 31 localized server guides.

## [0.0.85-beta] - 2026-08-09

### Fixed

- The final `SAFE TO CLOSE` confirmation is now printed directly in the server console (in both `gui` and `nogui` modes) as soon as the world save completes, instead of relying only on the launcher window after the process exits. When `stop` is detected, Jarock first prints a notice that the world is being saved so the operator keeps the window open.
- The shutdown detection now also recognizes additional Minecraft shutdown messages (`Saving players`, `Saving worlds`, `Stopping the server`) and still requires the completed `All dimensions are saved` save before authorizing a safe close. If the process exits with an unexpected code after the world save completed, Jarock still confirms the world is on disk and explains the exit code; if no completed save was observed, it prints `NOT SAFE TO CLOSE` with log guidance.
- In `gui` mode the ready status now reminds operators to type `stop` in the Minecraft GUI window (or use its Stop button), because the terminal window does not read commands while the Minecraft GUI is shown.
- The Windows bootstrap regression test now asserts that the server console prints the world-saving notice and the final `SAFE TO CLOSE` confirmation after a clean stop.
- Documented the in-console shutdown confirmation and the "do not close while saving" notice in the English, Italian and all localized guides and README.

## [0.0.84-beta] - 2026-08-08

### Changed

- Replaced the Fabric-only Welcome AWA mod with Welcome Message 2.8 for Minecraft 26.2 and its required Collective 8.39 library. Both pinned Modrinth artifacts are verified with SHA-512 during bootstrap and are installed for Fabric and NeoForge; clients do not need to install them.
- Updated the bootstrap regression test, loader manifests, English, Italian and localized documentation, and TODO checklist to reflect Welcome Message configuration and the removal of the old Welcome AWA references.

## [0.0.83-beta] - 2026-08-08

### Added

- Added OfflineCommands 1.0.3 for Minecraft 26.2 Fabric. This server-side mod runs commands on offline players; its pinned Modrinth artifact is verified with SHA-512 during bootstrap. No compatible NeoForge 26.2 build is available, so NeoForge does not install OfflineCommands.
- Extended the Windows bootstrap regression test and updated the English, Italian and localized documentation with OfflineCommands' Fabric-only scope and behavior.


## [0.0.82-beta] - 2026-08-08

### Added

- Added InvView 1.4.21 for Minecraft 26.2 Fabric. The server-side mod allows authorized operators to inspect and manage online or offline player inventories and ender chests; its pinned Modrinth artifact is verified with SHA-512 during bootstrap. No compatible NeoForge 26.2 build is available, so NeoForge does not install InvView.
- Extended the Windows bootstrap regression test and updated the English, Italian and localized documentation with InvView's Fabric-only scope and administrative behavior.


## [0.0.81-beta] - 2026-08-08

### Added

- Added Essential Commands 0.41.0 for Minecraft 26.2 Fabric, together with its required `ec-core` 1.3.0 component. Both Modrinth artifacts are pinned and verified with SHA-512 during bootstrap. No compatible NeoForge 26.2 build is available, so NeoForge does not install this Fabric-only mod.
- Extended the Windows bootstrap regression test to verify both Essential Commands artifacts and their checksums, and updated the English, Italian and localized documentation with the loader limitation and command-mod behavior.


## [0.0.80-beta] - 2026-08-08

### Added

- Added No Chat Reports v2.20.1 for Minecraft 26.2 to both the Fabric and NeoForge manifests, with pinned Modrinth URLs and SHA-512 verification. The server-side mod prevents forwarding signed chat-reporting data; Jarock does not automatically change `enforce-secure-profile`, and vanilla clients may still show unsigned-chat warnings.
- Updated the Windows bootstrap regression test and all supported documentation languages with the loader-specific installation and security caveats.


## [0.0.79-beta] - 2026-08-08

### Added

- Added the verified Better Multiplayer Sleep 1.1.0 datapack for Minecraft 26.2. Jarock downloads it with a pinned Modrinth URL and SHA-512, validates the ZIP structure, and installs it in the configured world's `datapacks/` folder for Fabric and NeoForge without replacing the world or other datapacks.
- Extended the Windows bootstrap test to verify the datapack manifest, download, checksum and configured-world installation.
- Updated the English, Italian and localized technical documentation with datapack behavior and `/reload` guidance.


## [0.0.78-beta] - 2026-08-08

### Added

- Added the server-side Fabric mod Welcome AWA 2.4 for Minecraft 26.2 (`welcome_awa-fabric-26.2-2.4.jar`). The pinned Modrinth download is verified with SHA-512 during bootstrap and provides configurable colored join messages using `%player%`, `&` color codes, `\n` line breaks and the `welcome reload` command. Fabric API is already included as its required dependency; clients do not need to install the mod.
- Documented Welcome AWA in the complete English and Italian Fabric guides, plus the localized technical summaries and fallback notes for all supported languages.

## [0.0.77-beta] - 2026-08-08

### Added

- Added the server-side Fabric mod Links In Chat for Minecraft 26.2 (`linksinchat-1.3.1+26.2.jar`). The pinned Modrinth download is verified with SHA-512 during bootstrap and provides clickable URLs plus `/link` and `/linkwhisper` commands without requiring client installation.
- Documented Links In Chat in the complete English and Italian Fabric guides, plus the localized technical summaries and fallback notes for all supported languages.

## [0.0.76-beta] - 2026-08-08

### Fixed

- Fixed automatic startup updates being blocked by the intentionally local `scripts/server-launch-settings.ini` file. The updater now preserves this user configuration and ignores only its Git status entry, while still refusing to overwrite other uncommitted project changes.
- Clarified the updater safety message so users do not need to commit or stash normal parameter-manager changes before updating Jarock. Project-file renames remain protected by the Git safety check.

## [0.0.75-beta] - 2026-08-08

### Added

- Added the generated world seed to the final ready-status message as `seed:`, immediately after `The Jarock server has finished loading.` and before the Java/Bedrock LAN addresses. Jarock reads the seed from the startup log when available and falls back to the generated world's `level.dat` NBT data.

## [0.0.74-beta] - 2026-08-08

### Fixed

- Fixed startup self-updates corrupting the still-running `start-server.bat`: the launcher now executes from an isolated `.cache/start-server-runner.bat` copy, so the updater can replace the real launcher without causing fragments such as `Internet` or `install` to be executed as commands. If the isolated runner cannot be created, startup stops instead of attempting an unsafe automatic update.
- Fixed mojibake in the ready ASCII banner under Windows PowerShell 5.1 by reading `server-ready-banner.txt` explicitly as UTF-8.
- Fixed the first update from older Jarock releases: startup updates now defer replacing `start-server.bat` until the current launcher process exits, so even an older launcher cannot be corrupted while it is executing. Lite packages now require the deferred-launcher helper, and its replacement waits for the parent command process to exit with a bounded ten-minute timeout.

## [0.0.73-beta] - 2026-08-08

### Changed

- Replaced the remaining active internal `auto` update-mode terminology with the explicit `install` name in the startup launcher and parameter manager. The supported values are now consistently `install`, `check` and `never`.
- Obsolete `AUTO_UPDATE_MODE=auto` settings are treated as invalid and safely fall back to `install`; the parameter manager displays and persists the corrected value instead of exposing the old name.

## [0.0.72-beta] - 2026-08-08

### Changed

- Changed the default startup update mode from `never` to `install`. New installations and legacy settings without an explicit update choice now check GitHub and install a verified compatible Lite package before startup. Users can still select `check` or `never` in `parameter-manager.bat`; explicit legacy `AUTO_UPDATE_CHECK=false` remains disabled for compatibility.
- Updated the English and localized documentation, settings template, parameter-manager fallback, startup parser, validator and regression test to describe and enforce `install` as the default.

## [0.0.71-beta] - 2026-08-08

### Fixed

- Fixed `.github/workflows/test-console-close.yml`: GitHub Actions does not allow the `matrix` expression in the step `shell` field used by the previous workflow. The workflow now runs the safe console-close smoke test explicitly with Windows PowerShell 5.1 and PowerShell 7.

## [0.0.70-beta] - 2026-08-08

### Fixed

- Fixed startup update mode detection in `start-server.bat` on Windows CRLF settings files. `install`, legacy `auto`, `check`, `never`, and legacy `AUTO_UPDATE_CHECK=true` values are now matched from the beginning of the line without the CRLF-sensitive end-of-line regex, so enabled startup checks actually run.
- Added `.github/workflows/test-startup-updates.yml` and `scripts/test-startup-update-settings.ps1` to verify all startup update modes with both CRLF and LF settings files without contacting GitHub or changing the installation.

## [0.0.69-beta] - 2026-08-08

### Added

- Added `.github/workflows/test-console-close.yml`, a manually runnable and push-triggered Windows matrix test for Windows PowerShell 5.1 and PowerShell 7.
- Added `scripts/test-console-close-protection.ps1`, which safely verifies the embedded native handler compiles, registers, remains idempotent, and unregisters without sending a destructive close event or opening a CI-blocking MsgBox. The workflow intentionally tests registration and lifecycle only; it does not simulate a real console close in CI.

## [0.0.68-beta] - 2026-08-08

### Added

- Added best-effort Windows console close protection to the managed server process. On the classic console host, clicking `X` can show a MsgBox instructing the operator to type `stop` or close the Minecraft GUI normally and wait for `SAFE TO CLOSE`. The protection is removed after shutdown, while the documentation explains the Windows timeout and Windows Terminal/Alacritty pseudoconsole limitations.
- Added the console-close warning and safe-shutdown limitation note to the root documentation and all localized guides that describe server shutdown.

## [0.0.67-beta] - 2026-08-08

### Changed

- Made the three startup update modes explicit in `start-server.bat`: `install` contacts GitHub and installs a verified compatible Lite package before bootstrap, `check` contacts GitHub and reports updates without changing files, and `never` skips GitHub entirely and proceeds directly to startup.

## [0.0.66-beta] - 2026-08-08

### Added

- Added `.github/workflows/test-update.yml`, a manually runnable Windows test that builds an isolated older installation from the previous commit, serves a current Lite package through a local mock release API, runs the current updater, and verifies checksum validation plus preservation of the world, server properties, Geyser configuration and local launch settings.

## [0.0.65-beta] - 2026-08-08

### Changed

- Renamed the automatic startup-install update mode from `auto` to `install` so its behavior is explicit. Existing local `auto` values and legacy `AUTO_UPDATE_CHECK=true/false` settings are still migrated for compatibility.
- Added a release-package guard that rejects non-ASCII PowerShell scripts, preventing Windows PowerShell 5.1 encoding regressions such as the broken `Ð...` parser error found in older Lite packages.

### Fixed

- Fixed the Windows CI bootstrap test when `run-server.ps1` is executed by PowerShell 5.1: shutdown detection no longer embeds non-ASCII regex literals, and the harness drains redirected output/error streams after an early process failure so the actual diagnostic is preserved.
- Fixed the Windows parameter manager when checked out with Unix line endings: `parameter-manager.bat` now keeps CRLF line endings, initializes missing settings safely, and no longer leaves `RAM_MAX` blank when reading the current configuration. Legacy update mode values are normalized to the official `install` value before display.
- Stop automatically moving or replacing existing worlds after an apparent integrity problem. Jarock now leaves the world in place and stops with guidance; a new world is generated only after the owner deliberately deletes all configured world folders and no possible old world data remains under another name.
- Protect custom `level-name` configurations and reject partial or orphaned world-directory layouts so Minecraft cannot silently mix old dimensions with a newly generated world.

## [0.0.61-beta] - 2026-08-08

### Added

- Print the configured LAN connection addresses immediately after the ready banner: Java players receive the `server-port` TCP address and Bedrock players receive Geyser's `bedrock.port` UDP address. The launcher does not change router or firewall settings.
- Add three explicit startup update modes to `parameter-manager.bat`: check and install automatically, check updates only, or do not check/install updates.

### Fixed

- Make `SAFE TO CLOSE` conservative: a previous startup save message no longer counts. Jarock now requires shutdown-specific save output after Minecraft begins stopping, in both GUI and `--nogui` modes, before reporting a normal close.

## [0.0.59-beta] - 2026-08-07

### Added

- Added a single ready-status message for Fabric and NeoForge that shows the detected LAN IPv4 address, the Java `server-port` over TCP, and the Geyser `bedrock.port` over UDP after the server is ready. When Geyser is absent, Bedrock is clearly reported as unavailable.

### Changed

- The address message remains visible when `Show ready banner` is disabled; only the ASCII-art banner is hidden.
- Centralized the post-start status output so Fabric and NeoForge use the same behavior and explicitly remind operators that public access requires their own network configuration.


- Moved the tracked version file, launch-settings template, updater launcher, and local launch-settings file under `scripts/`. Root launchers now migrate existing root-local settings automatically, while release and CI workflows use the new paths.

### Changed

- Replaced the old boolean startup update setting with `AUTO_UPDATE_MODE`: `install` checks and installs verified updates automatically, `check` checks without installing, and `never` disables the startup check. Older `AUTO_UPDATE_CHECK=true/false` local settings remain readable for compatibility. The obsolete `AUTO_UPDATE_MODE=auto` value is no longer supported and safely falls back to `install`.
- Replaced the fragile exact-line EULA check with a tolerant PowerShell validator, so harmless whitespace, casing and Windows/Unix line-ending differences do not make a valid `eula=true` appear to be rejected.
- Changed `scripts/update-jarock.ps1` to update existing installations from the matching Lite release package (`jarock-lite.zip` or `jarock-lite-<version>.zip`) while retaining SHA-512, version, channel, process, Git-safety and rollback checks. Existing Java prerequisites are preserved and are not reinstalled during updates.
- Clarified the parameter manager: `Show ready banner` controls the startup banner, while `Run startup update check` asks for confirmation when a newer compatible release is found. Lowercase `y` or `yes` installs the verified Lite package; `N` or Enter skips it. You can also use `scripts/update-jarock.bat` after safely stopping the server.

## [0.0.58-beta] - 2026-08-07

### Fixed

- Synchronized the interactive startup update instructions across the English and localized guides without changing the updater code: `y` or `yes` confirms the Lite installation, while `N` or Enter skips it.

## [0.0.57-beta] - 2026-08-07

### Fixed

- Changed the startup update prompt to `Download and install it now? (y/N)`, making the default choice visibly clear: lowercase `y`/`yes` installs, while `N` or Enter skips the update.
- Synchronized the English and localized documentation with the `y/N` prompt notation.

## [0.0.56-beta] - 2026-08-07

### Changed

- Added the interactive startup update prompt requested for `start-server.bat`: when `AUTO_UPDATE_CHECK=true` and a newer compatible release is found, `y` or `yes` installs the verified Lite package while `N` or Enter skips the update and continues normally.
- Updated the English and localized documentation to describe the startup `y/N` choice and the non-silent update behavior.

## [0.0.55-beta] - 2026-08-07

### Added

- Added a dedicated `scripts/validate-eula.ps1` helper for robust launcher-side EULA validation.

### Changed

- Updated the English and localized documentation to use the clearer parameter-manager labels `Show ready banner` and `Run startup update check`.
- Documented that existing installations use the Lite package for updates because Java prerequisites are already present.

## [0.0.54-beta] - 2026-08-07

### Added

- Localized the documentation index labels with the native guide titles for all supported languages.

## [0.0.53-beta] - 2026-08-07

### Added

- Documented the commit-and-push convention in `CONTRIBUTING.md`.

## [0.0.52-beta] - 2026-08-07

### Added

- Added an optional manual version input to `.github/workflows/auto-release.yml`. It is available only for manual workflow runs, accepts a SemVer value without the `v` prefix, and falls back to `scripts/version.txt` when left empty. The existing draft-release input and automatic push behavior remain unchanged.

## [0.0.51-beta] - 2026-08-07

### Added

- Added a complete `first-run.md` guide in English and every supported documentation locale, covering Java, loader selection, parameter management, EULA acceptance, safe shutdown and troubleshooting.

### Removed

- Removed the obsolete `scripts/bootstrap-fabric.ps1` legacy bootstrap; `scripts/bootstrap-server.ps1` is now the single maintained loader-aware bootstrap entry point.
- Removed the unused `scripts/mark-english-fallback.ps1` one-off documentation helper, which was not referenced by any launcher, workflow or maintenance command.
- Updated all localized `how-does-jarock-work.md` guides to reference the maintained unified bootstrap script.

## [0.0.50-beta] - 2026-08-07

### Changed

- Relocated the project version source to `scripts/version.txt` and moved the updater entry point and launch-settings files into `scripts/`. Existing installations are migrated automatically by the root launchers.

## [0.0.49-beta] - 2026-08-07

### Added

- Rebuilt the English interactive GitHub issue forms for bug reports and feature requests with Jarock-specific loader, Java, server, Geyser/Floodgate, updater, workflow and documentation fields.
- Added mandatory privacy and troubleshooting checklists plus GitHub Discussions, documentation and security contact links.

## [0.0.48-beta] - 2026-08-07

### Added

- **Safe Jarock updater**: added `scripts/update-jarock.bat` and `scripts/update-jarock.ps1`. The updater reads the installed SemVer from `scripts/version.txt`, checks GitHub releases in the same stable or beta channel, ignores drafts, requires the Full package and its published SHA-512 checksum, asks for confirmation, validates the archive before extraction, and creates a rollback backup before applying the update. It is intentionally an explicit manual action rather than a silent startup update.
- The updater preserves the generated `server/` runtime, world data, mods, libraries, server properties, EULA, Geyser/Floodgate keys, local launch settings, Java selection, logs and secrets. Tracked templates and manifests are updated, while generated runtime files remain protected; obsolete tracked project files are removed only after being backed up. It never changes router, firewall or port-forwarding settings.
- Added updater instructions to the English and translated documentation, including SHA-512 verification and the manual-update safety boundary. Existing dependencies are not proactively reinstalled; the next normal bootstrap verifies them and downloads only missing or invalid files. Releases without checksum assets are reported as requiring manual installation instead of being silently applied.

### Security

- The updater refuses to modify a running Jarock/Minecraft process and, for Git checkouts, refuses to overwrite uncommitted changes unless the explicit `-AllowLocalChanges` override is used.

## [0.0.47-beta] - 2026-08-07

### Added

- **Safe shutdown guidance**: `start-server.bat` now tells operators not to close the console immediately after entering `stop`, and prints `CLEAN SHUTDOWN COMPLETE` followed by `SAFE TO CLOSE` only after the Minecraft process exits normally. A non-zero exit is clearly marked as unsafe to assume and points to the logs and crash reports.
- Added the safe-shutdown instructions to the English and translated installation, loader-fallback, network and Jarock-operation guides. The instructions explain that force-closing the process or interrupting world saving can leave world data incomplete or corrupt.

### Changed

- The final shutdown message remains safe even when the post-shutdown Geyser configuration update reports a warning: the world-save confirmation is based on the Minecraft process exit, while the Geyser warning is reported separately.

## [0.0.46-beta] - 2026-08-07

### Fixed

- **Downloads page release buttons now work for prereleases**: the page fetched `/releases/latest`, which GitHub returns as HTTP 404 while the newest release is a prerelease (the whole beta channel), so the buttons would have stayed on the fallback message until a stable release existed. It now uses the releases list endpoint (`/releases?per_page=5`, newest first, prereleases included) and picks the newest release that actually carries the matching zip asset.
- The version label and download URL injected by the Downloads page are now HTML-escaped, matching the changelog box pattern.
- Removed the redundant explicit `git lfs pull` step from the release workflow (the checkout already enables Git LFS).

## [0.0.45-beta] - 2026-08-07

### Added

- **Release distribution packages**: the automatic release workflow now builds and attaches two packages to every release — `jarock-full.zip` (stable) / `jarock-full-<version>.zip` (prerelease), the recommended package that bundles the server code, templates, manifests, scripts, launchers, the documentation in all languages **and** the bundled Java installers from `prerequisites/` (real LFS binaries, so a fresh machine can auto-install Java offline); and `jarock-lite.zip` / `jarock-lite-<version>.zip` without the Java installers. The workflows (`.github/`), the website (`.website/`) and version-control metadata (`.gitattributes`, `.gitignore`) are excluded from both packages. The workflow now checks out with Git LFS enabled so the installers are packaged as real files.
- **Downloads page release buttons**: the website Downloads page now offers "Release package — Full" (recommended) and "Release package — Lite" download buttons that resolve the latest GitHub release through the API (same pattern as the changelog box) and link to the matching zip asset with its version and size, falling back to a message pointing at the releases page when no package asset exists.

## [0.0.44-beta] - 2026-08-07

### Fixed

- **CI test harness: the environment masking/restoring now removes variables instead of writing empty ones.** `Set-EnvTolerant` no longer coerces its value to `[string]`, so the `$null` used to mask or restore an unset `JAVA_HOME`/`Path` flows through unchanged and `[Environment]::SetEnvironmentVariable` deletes the variable, exactly like the original code. Previously the coercion turned `$null` into `''`, which wrote a stray empty `JAVA_HOME=` into the persistent user registry (and HKLM when run elevated, e.g. on CI).
- **CI test harness: the synchronous reader now tolerates a faulted pipe.** If the child process hard-crashes and its output pipe faults instead of reaching EOF, the `ReadLineAsync` result access is guarded and treated as end of stream, so the harness still reports a clean `FAIL`/`HARNESS ERROR` with exit code 1.

## [0.0.43-beta] - 2026-08-07

### Fixed

- **CI test harness: replaced the async output handlers with synchronous reading.** The harness previously used `Process` `DataReceived` event handlers whose scriptblock callback runs on a thread without a PowerShell runspace, so pwsh terminated with `PSInvalidOperationException: There is no Runspace available to run scripts in this thread`; on the CI runner this surfaced as the cryptic `0xE0434352` process crash that failed `test.yml` (and locally as exit 127). The server phase now reads stdout/stderr line by line on the main thread (15-minute deadline, `stop` sent when the ready banner appears), so every outcome is reported as a normal `FAIL`/`PASS` with a clean exit code.
- **CI test harness: tolerated non-elevated runs.** Masking and restoring the persistent user/machine environment variables now skip (with a warning) any write that requires elevation, so the harness can run end to end in a non-admin shell. On CI (elevated runner) the full mask still applies.
- **CI test harness: the bootstrap assertion now prints the child exit code** (`Bootstrap completes successfully (exit code N)`), so a future child crash is instantly diagnosable.

## [0.0.42-beta] - 2026-08-07

### Fixed

- **Download robustness**: `scripts/bootstrap-server.ps1` (and the retained `scripts/bootstrap-fabric.ps1`) now download through `curl.exe` when available (bundled with Windows 10 1803+ and every GitHub Actions Windows runner), with automatic retries on transient failures, falling back to `Invoke-WebRequest` only when `curl.exe` is missing. This prevents the intermittent Windows PowerShell 5.1 download crashes observed on the CI test runner (exit code `0xE0434352`, an unhandled .NET exception) and makes fresh installs more reliable against flaky CDN responses.
- **PowerShell 5.1 module-path hygiene**: `scripts/bootstrap-server.ps1` and `scripts/bootstrap-fabric.ps1` now put the standard Windows PowerShell 5.1 module folders first in `PSModulePath`. On machines where the Microsoft Store build of PowerShell 7 prepends its own module folders, Windows PowerShell 5.1 can load incompatible PS7 modules and lose cmdlets such as `Get-FileHash`, which broke mod hash verification ("The term 'Get-FileHash' is not recognized"). The bootstrap now always loads the correct modules.
- **CI test harness hardening**: `scripts/test-windows-bootstrap.ps1` wraps its phases in a top-level error handler and makes the async output handler exception-proof, so an unexpected failure is reported as a clean exit code with visible `FAIL`/`HARNESS ERROR` lines instead of the cryptic `0xE0434352` process crash.
- **CI workflow**: `test.yml` now uses `actions/setup-java@v5` (v4 is deprecated).

## [0.0.41-beta] - 2026-08-07

### Changed

- The whitelist is now **disabled by default**: `server/server.properties.template` ships with `white-list=false` and `enforce-whitelist=false` (with a comment explaining how to enable it before public access), so a freshly created server lets anyone join for testing. The local generated `server.properties` follows the same default.
- Updated the English and Italian server guides, the NeoForge fallback guides and the network-and-ports guide to state that the whitelist is off by default and must be turned on (`white-list=true`, `enforce-whitelist=true`) before opening the server to the public, adding every trusted player with `whitelist add <name>`.
- Attached the same whitelist note to all 31 fallback language summaries of the server guide and of the network-and-ports guide.

## [0.0.40-beta] - 2026-08-07

### Fixed

- Hardened the `test.yml` first-run bootstrap test after review: the Java masking now also covers the `java-home.txt` file and the `JAROCK_JAVA_HOME` variable (the two sources the discovery reads first), the harness stops the server on the ready-banner message with the vanilla `Done (...)!` line as a fallback so a slow or failing Geyser on CI cannot cause a spurious timeout, and the workflow skips doc-only pushes (each run pulls roughly 190 MB of Git LFS installers) while remaining available on demand.
- Raised the workflow job timeout to 45 minutes to leave room for the LFS pull, downloads and first world generation.

## [0.0.39-beta] - 2026-08-07

### Added

- Added a `test.yml` GitHub Actions workflow (also runnable manually) that simulates a fresh Windows PC without the Java prerequisites: it checks out the bundled installers via Git LFS, masks every Java source the bootstrap reads, verifies that Jarock detects the missing Java and would install the JRE 8 installer first and the Temurin JDK 25 MSI second, then restores Java, installs the Fabric runtime and mods, boots the real server and stops it automatically once the ready banner appears.
- Added `scripts/test-windows-bootstrap.ps1`, the end-to-end harness executed by the workflow (runnable locally with a 64-bit Java 25+ installed; the Java environment is restored afterwards).
- Added a `JAROCK_PREREQ_DRY_RUN` environment variable that makes the prerequisite installer launch sequence simulated instead of starting the interactive UAC installers, so the flow can be exercised on a headless CI runner.

## [0.0.38-beta] - 2026-08-07

### Fixed

- Corrected the legacy Java 8 installer name in the `0.0.35-beta` changelog entry: it is `jre-8-windows-x64.exe`, not `jre-81-windows-x64.exe`. No file, code or documentation change was required anywhere else, because every reference already used the correct name.

## [0.0.37-beta] - 2026-08-07

### Fixed

- Suppressed the stray `True`/`False` line that could appear in the console after the bundled Java installers ran: the prerequisite-install call in the bootstrap now discards its return value.

## [0.0.36-beta] - 2026-08-07

### Added

- When no compatible 64-bit Java 25+ runtime is found, `start-server.bat` now installs the bundled Java prerequisites automatically: it launches the legacy Java 8 installer (`prerequisites/jre-8-windows-x64.exe`) first, waits for it to finish, then launches the Eclipse Temurin JDK 25 MSI (`prerequisites/OpenJDK25U-jdk_x64_windows_hotspot.msi`) and re-checks Java afterwards. Each installer runs elevated and shows a UAC prompt. If the installers are missing, the bootstrap keeps the previous download guidance.

### Changed

- Renamed the bundled legacy Java 8 installer to `jre-8-windows-x64.exe` (same file, same SHA-256) and documented the automatic prerequisite installation in the guides in all supported languages.

## [0.0.35-beta] - 2026-08-07

### Changed

- Renamed the bundled Temurin JDK installer to `OpenJDK25U-jdk_x64_windows_hotspot.msi` (same file, same SHA-256) and replaced the legacy Java 8 installer with `jre-8-windows-x64.exe` (file version 8.0.5010.8). `prerequisites/README.md` documents the new names and checksums.

## [0.0.34-beta] - 2026-08-07

### Changed

- Synchronized the ready-banner documentation across all supported languages: the English and Italian detailed guides now mention the "Toggle ready banner" option in their parameter-manager sections, `docs/en/how-does-jarock-work.md` and `docs/README.md` include it in the manager's capabilities list, and all 29 fallback language summaries carry an English note pointing to the full English guide.

## [0.0.33-beta] - 2026-08-07

### Added

- Added a `SHOW_READY_BANNER` launch setting that controls the ASCII-art banner shown when the server finishes loading. It can be toggled from `parameter-manager.bat` (option 7, "Toggle ready banner") and defaults to `true`.

### Changed

- The ready banner is now fully suppressed at runtime when `SHOW_READY_BANNER=false`: `scripts/run-server.ps1` skips loading and printing it in both the Fabric and NeoForge launch paths.
- `scripts/validate-launch-settings.ps1` and `scripts/update-launch-setting.ps1` now recognize and validate the new setting, and the settings template ships with it documented.

## [0.0.32-beta] - 2026-08-07

### Changed

- The ready banner now waits for Geyser when it is installed: if a Geyser jar is present in `server/mods/`, the banner is shown after Geyser finishes starting (its `Fatto`/`Done ... /geyser help` line) instead of after the earlier Minecraft `Done` line. Without Geyser, the previous Minecraft-`Done` trigger is kept.
- Suppressed the stray `System.Management.Automation.RemoteException` line that could appear in the console when the server wrote empty lines to stderr.

## [0.0.31-beta] - 2026-08-07

### Changed

- Switched the ready banner to "Done!" in the ANSI Compact figlet style (block characters, 73 columns), which fits both the launcher console and the DedicatedPower server console without wrapping.

## [0.0.30-beta] - 2026-08-07

### Changed

- Narrowed the ready banner to the single word "JAROCK" (ANSI Regular figlet style, 49 columns) so it also fits inside the DedicatedPower server console without wrapping.

## [0.0.29-beta] - 2026-08-07

### Added

- The server console now prints an ASCII-art banner ("JAROCK SERVER" / "READY!" in the ANSI Regular figlet style) as soon as Minecraft finishes loading, detected from the standard `Done (x.xxxs)!` console line.

### Changed

- Marked the completed first-run and EULA/server.properties items as done in `TODO.md` and highlighted the two remaining blockers for public access (`online-mode` and `white-list`, both still `false`).

## [0.0.28-beta] - 2026-08-07

The active prerelease channel is now `beta`; new prerelease versions use the `-beta` suffix. Earlier `-alpha` entries are historical.

### Added

- The bootstrap now always downloads the latest DedicatedPower release from its GitHub releases page instead of a pinned version. It picks the asset matching the target Minecraft version (`dedicatedpower-<minecraft>-<mod>.jar`), verifies size and checksum after download, keeps a local version marker so unchanged releases are not re-downloaded, and removes stale DedicatedPower jars. DedicatedPower is a Fabric-only mod, so it is downloaded only when Fabric is the selected loader.
- Documented the Fabric-only nature of DedicatedPower in `how-does-jarock-work.md` in all 31 supported languages.

### Changed

- Documented the maintenance conventions in `CONTRIBUTING.md`: commits now require a detailed body explaining what and why, and `CHANGELOG.md` is updated with every change under `[Unreleased]` instead of only at release time.
- The parameter manager now renders a two-column main menu: the options are listed on the left and the current value of each setting (or an action hint) is shown on the right.
- The auto-release workflow now publishes release notes with a summary of the commits since the previous release followed by the changelog section of the released version.

### Planned

- Complete the public-release checklist in `TODO.md`.
- Keep all localized documentation synchronized with the English explanation.
- Continue testing Fabric and NeoForge loader selection on clean Windows checkouts.
- Add an official Forge 26.2 installer and manifest only after the official build is available and verified.

## [0.0.27-beta] - 2026-08-07

### Fixed

- Added automatic world-integrity repair in the launch flow: an incomplete world folder (for example a small `level.dat` or missing world generation settings, which makes Minecraft stop with "Overworld settings missing") is moved aside and a fresh world is generated on the next start.
- Restricted `.gitignore` so runtime-generated configuration files under `server/config/` are no longer accidentally tracked; only the committed templates remain visible to Git.

### Added

- The parameter manager now shows the current settings summary when it opens (loader, RAM, mode, GC profile, Java auto-setup and online-mode), including an explicit warning when `online-mode=false` is active.

### Changed

- Raised the minimum allowed RAM from 512M to 1G across the parameter manager and the launch validation scripts, reducing the risk of interrupted world generation on low initial memory.
- Added a world-corruption troubleshooting entry to `server-guide.md` in all 31 supported languages.

## [0.0.26-beta] - 2026-08-06

### Changed

- Set the visible release workflow name to `auto-release.yml`.
- Prepared the next beta release after the workflow and documentation maintenance updates.

## [0.0.25-beta] - 2026-08-06

### Fixed

- Fixed the GitHub Pages deployment workflow YAML indentation so `deploy.yml` can be parsed and run manually.
- Fixed the auto-release workflow YAML indentation so manual releases and `v`-prefixed release commits are recognized.

### Changed

- Reduced the GitHub Pages deployment timeout from 10 minutes to 2 minutes.
- Improved the website icon display by removing internal white padding and filling the icon square correctly.
- The website changelog now loads automatically from the repository's raw `CHANGELOG.md` URL and provides a GitHub fallback link when loading fails.
- Removed unnecessary `canonical` wording from documentation and website text.

## [0.0.24-beta] - 2026-08-06

### Added

- Added explicit "Set JAVA_HOME variable" installation warning to all Java setup instructions across every supported language.

### Changed

- Updated `README.md`, `prerequisites/README.md`, and all translated `server-guide.md`, `how-does-jarock-work.md`, and `network-and-ports.md` files (31 languages) with the JAVA_HOME checkbox note.

### Removed

- Removed the unused `deploy.yml` CI workflow.

## [0.0.23-beta] - 2026-08-06

### Added

- Added interactive issue templates in English and Italian (bug report and feature request).
- Added a comprehensive network, firewall and router configuration guide (`network-and-ports.md`) in all 31 supported languages.

### Changed

- Removed all website files from `docs/`; the multilingual documentation now lives without a published GitHub Pages site.
- Deleted the `.website` source folder after confirming `docs/` is the single source for multilingual documentation.
- Added a network configuration reference from `TODO.md` to the new dedicated guide.

## [0.0.22-beta] - 2026-08-06

### Fixed

- Fixed the Fabric metadata verification on Windows by normalizing CRLF file endings before checking `serverJar=vanilla-server.jar`.

## [0.0.21-beta] - 2026-08-06

### Fixed

- Fabric bootstrap now creates missing `fabric-server-launcher.properties` metadata after the official installer completes.
- Existing Fabric installations are repaired automatically before launch, with `serverJar=vanilla-server.jar` verified before startup.

## [0.0.20-beta] - 2026-08-06

### Fixed

- Fixed the Fabric launcher metadata so `server.jar` loads the vanilla game from `vanilla-server.jar` instead of referring to itself.
- Existing Fabric installations are repaired automatically before launch; missing launcher metadata is recreated locally when the launcher and vanilla game are valid.

## [0.0.19-beta] - 2026-08-06

### Fixed

- Handled `Exit without saving` as a clean first-run cancellation instead of reporting it as a bootstrap error.
- `start-server.bat` now shows a cancellation message and preserves the cancellation exit code without attempting to start the server.

## [0.0.18-beta] - 2026-08-06

### Added

- Added `Exit without saving` to `parameter-manager.bat`.

### Changed

- The parameter manager now edits a temporary settings copy and commits changes only through `Save and exit` or `Save and start`.
- Cancelling from the first-run manager restores the original loader settings and stops the bootstrap cleanly.

## [0.0.17-beta] - 2026-08-06

### Fixed

- Fixed the first-run `parameter-manager.bat` launch by opening it through a dedicated Windows command process, including repository paths with spaces or shell special characters.
- The bootstrap now waits for the parameter manager to close, checks its exit code, and rereads the saved settings before continuing.

## [0.0.16-beta] - 2026-08-06

### Added

- Added an optional loader reset to `clean-server-runtime.bat`; choosing `Y` clears `LOADER_TYPE` so the next start asks for Fabric or NeoForge again.

### Changed

- Kept the default cleanup behavior unchanged when loader reset is declined.

## [0.0.15-beta] - 2026-08-06

### Added

- Added first-run selection for Fabric, Forge or NeoForge.
- Added loader-specific NeoForge runtime installation and pinned NeoForge 26.2 mod manifest.
- Made `server.jar` a generated local loader entry point instead of a tracked vanilla binary.
- Added optional first-run access to `parameter-manager.bat`.

### Changed

- Fabric copies its loader launcher to `server.jar` and retains the vanilla engine as `vanilla-server.jar`.
- NeoForge uses its official generated `run.bat`, libraries and JVM arguments.
- Forge selection now reports the unavailable official Minecraft 26.2 build instead of creating an incompatible runtime.

## [0.0.14-beta] - 2026-08-06

### Added

- Added the server-side I'm Fast 1.0.3 Fabric mod for Minecraft 26.2 with pinned SHA-512 verification.
- Added `clean-server-runtime.bat` and its PowerShell implementation for safe manual pre-commit cleanup.
- Added Git LFS tracking for the intentionally versioned vanilla `server/server.jar`.

### Changed

- Preserved `server.jar` while keeping generated worlds, mods, libraries, configs, logs and credentials out of commits.


## [0.0.13-beta] - 2026-08-06

### Changed

- Continued prerelease development on the beta channel.
- Made `0.0.13-beta` the current version after the channel transition.

## [0.0.12-beta] - 2026-08-06

### Added

- Added an online-mode option to `parameter-manager.bat`, persisted in local launch settings and applied to `server.properties` before startup.
- Added explicit warnings and validation for unsafe offline mode.

## [0.0.11-alpha] - 2026-08-06

### Added

- Added the optional `prerequisites/` directory with the recommended Windows x64 Temurin JDK 25.0.4 installer.
- Added a clearly labeled legacy Java 8 installer for older software only; it is not suitable for the Minecraft 26.2 server.
- Added Git LFS tracking and SHA-256 documentation for the bundled installers.

## [0.0.10-alpha] - 2026-08-06

### Fixed

- Fixed Java 25 discovery under Windows PowerShell 5.1 when Java writes normal `-version` output to stderr.
- Java output is now converted safely to text while preserving the existing exit-code and 64-bit checks.

## [0.0.9-alpha] - 2026-08-06

### Fixed

- Included Java executables directly under vendor roots such as `Java\\bin\\java.exe`.
- Continued to support both vendor-root and nested JDK installation layouts.

## [0.0.8-alpha] - 2026-08-06

### Fixed

- Expanded Java discovery to include persistent user/machine `JAVA_HOME` and `PATH` values.
- Added Adoptium, AdoptOpenJDK and Windows Java application-path registry discovery.
- Recognized registry properties such as `JavaHome`, `Path`, `InstallationPath` and `Home`.
- Improved diagnostics when Java candidates exist but cannot be inspected.
- Added the ignored `java-home.txt` and `JAROCK_JAVA_HOME` overrides for custom JDK folders or direct `java.exe` paths.

## [0.0.7-alpha] - 2026-08-06

### Fixed

- Improved the Java prerequisite error so it lists detected incompatible runtimes, including Java 8 and Java 21.
- Added a direct Windows x64 Java 25 JDK installation link to the remediation message.
- Clarified that `server.jar` must not be double-clicked or launched with an older Java association; use the repository-root `start-server.bat` entry point.

## [0.0.6-alpha] - 2026-08-06

### Fixed

- Fixed PowerShell 5.1 Java discovery when the candidate collection starts empty.
- Made Java candidate binding explicit and safe for empty lists.
- Improved the no-compatible-Java remediation message.

## [0.0.5-alpha] - 2026-08-05

### Added

- Added `parameter-manager.bat` for safe RAM, GUI/console, GC profile and Java environment configuration.
- Added persistent local launch settings and user-scoped `JAVA_HOME`/`PATH` automation.
- Added installation and NeoForge fallback guide summaries for all requested locales, with English fallback summaries explicitly labeled in the documentation index and detailed English/Italian guides retained.

### Changed

- Made Fabric the first-choice ready-to-run server stack and kept NeoForge as the last loader fallback.
- Changed automatic release tags to use the plain semantic version without a `v` prefix.
- Removed project-version literals from documentation; `scripts/version.txt` is the single source for the current project version.

## [0.0.4-alpha] - 2026-08-05

### Added

- Added `CONTRIBUTING.md` with English maintenance, validation and release guidelines.
- Added Java runtime discovery that searches `JAVA_HOME`, all `PATH` candidates, common Windows installation folders and Java registry entries.

### Fixed

- Prevented Java 8 earlier on `PATH` from blocking a separately installed compatible Java runtime.
- The bootstrap now selects and reports an absolute 64-bit Java 25+ executable and the server launcher reuses that exact executable.

## [0.0.3-alpha] - 2026-08-05

### Added

- Added the full English `how-does-jarock-work.md` architecture document.
- Added translated `how-does-jarock-work.md` documents for all requested locales.
- Added documentation index links for every translation.

### Changed

- Clarified the actual Geyser/Floodgate first-start and restart sequence.

## [0.0.2-alpha] - 2026-08-05

### Added

- Added `how-does-jarock-work.md` in English and all requested translations.
- Documented the actual bootstrap, verification, EULA, Geyser, Floodgate, path and error-handling flow.

### Changed

- Made the Windows bootstrap resolve paths from the repository location instead of a fixed folder.
- Added actionable remediation messages after bootstrap, Geyser, Java and server-process failures.
- Added long-path detection and an elevated `LongPathsEnabled` helper for deep Windows paths.
- Kept router, firewall and port-forwarding operations out of the bootstrap.

### Fixed

- Preserved spaces, Unicode characters and nested repository paths in launcher and PowerShell path handling.

## [0.0.1-alpha] - 2026-08-05

### Added

- Fabric server documentation in English and Italian.
- NeoForge fallback documentation in English and Italian.
- One-click Windows bootstrap and start entry point.
- Pinned Fabric mod manifest with SHA-512 verification.
- Safe server and Geyser configuration templates.
- English public-release checklist in `TODO.md`.
- Semantic version file in `scripts/version.txt`.
- GitHub Actions autorelease workflow.

### Security

- Runtime worlds, logs, secrets, player lists and downloaded binaries are excluded from Git.
- The bootstrap never opens router ports or changes firewall settings.

[Unreleased]: https://github.com/PiBOH/jarock/compare/0.0.95-beta...HEAD
[0.0.95-beta]: https://github.com/PiBOH/jarock/compare/0.0.94-beta...0.0.95-beta
[0.0.94-beta]: https://github.com/PiBOH/jarock/compare/0.0.93-beta...0.0.94-beta
[0.0.93-beta]: https://github.com/PiBOH/jarock/compare/0.0.92-beta...0.0.93-beta
[0.0.92-beta]: https://github.com/PiBOH/jarock/compare/0.0.91-beta...0.0.92-beta
[0.0.87-beta]: https://github.com/PiBOH/jarock/compare/0.0.86-beta...0.0.87-beta
[0.0.86-beta]: https://github.com/PiBOH/jarock/compare/0.0.85-beta...0.0.86-beta
[0.0.84-beta]: https://github.com/PiBOH/jarock/compare/0.0.83-beta...0.0.84-beta
[0.0.83-beta]: https://github.com/PiBOH/jarock/compare/0.0.82-beta...0.0.83-beta
[0.0.82-beta]: https://github.com/PiBOH/jarock/compare/0.0.81-beta...0.0.82-beta
[0.0.81-beta]: https://github.com/PiBOH/jarock/compare/0.0.80-beta...0.0.81-beta
[0.0.78-beta]: https://github.com/PiBOH/jarock/compare/0.0.77-beta...0.0.78-beta
[0.0.77-beta]: https://github.com/PiBOH/jarock/compare/0.0.76-beta...0.0.77-beta
[0.0.76-beta]: https://github.com/PiBOH/jarock/compare/0.0.75-beta...0.0.76-beta
[0.0.72-beta]: https://github.com/PiBOH/jarock/compare/0.0.71-beta...0.0.72-beta
[0.0.71-beta]: https://github.com/PiBOH/jarock/compare/0.0.70-beta...0.0.71-beta
[0.0.70-beta]: https://github.com/PiBOH/jarock/compare/0.0.69-beta...0.0.70-beta
[0.0.69-beta]: https://github.com/PiBOH/jarock/compare/0.0.68-beta...0.0.69-beta
[0.0.68-beta]: https://github.com/PiBOH/jarock/compare/0.0.67-beta...0.0.68-beta
[0.0.67-beta]: https://github.com/PiBOH/jarock/compare/0.0.66-beta...0.0.67-beta
[0.0.66-beta]: https://github.com/PiBOH/jarock/compare/0.0.65-beta...0.0.66-beta
[0.0.65-beta]: https://github.com/PiBOH/jarock/compare/0.0.64-beta...0.0.65-beta
[0.0.64-beta]: https://github.com/PiBOH/jarock/compare/0.0.63-beta...0.0.64-beta
[0.0.63-beta]: https://github.com/PiBOH/jarock/compare/0.0.62-beta...0.0.63-beta
[0.0.62-beta]: https://github.com/PiBOH/jarock/compare/0.0.61-beta...0.0.62-beta
[0.0.61-beta]: https://github.com/PiBOH/jarock/compare/0.0.60-beta...0.0.61-beta
[0.0.60-beta]: https://github.com/PiBOH/jarock/compare/0.0.59-beta...0.0.60-beta
[0.0.59-beta]: https://github.com/PiBOH/jarock/compare/0.0.58-beta...0.0.59-beta
[0.0.58-beta]: https://github.com/PiBOH/jarock/compare/0.0.57-beta...0.0.58-beta
[0.0.57-beta]: https://github.com/PiBOH/jarock/compare/0.0.56-beta...0.0.57-beta
[0.0.56-beta]: https://github.com/PiBOH/jarock/compare/0.0.55-beta...0.0.56-beta
[0.0.55-beta]: https://github.com/PiBOH/jarock/compare/0.0.54-beta...0.0.55-beta
[0.0.54-beta]: https://github.com/PiBOH/jarock/compare/0.0.53-beta...0.0.54-beta
[0.0.53-beta]: https://github.com/PiBOH/jarock/compare/0.0.52-beta...0.0.53-beta
[0.0.52-beta]: https://github.com/PiBOH/jarock/compare/0.0.51-beta...0.0.52-beta
[0.0.51-beta]: https://github.com/PiBOH/jarock/compare/0.0.50-beta...0.0.51-beta
[0.0.50-beta]: https://github.com/PiBOH/jarock/compare/0.0.49-beta...0.0.50-beta
[0.0.49-beta]: https://github.com/PiBOH/jarock/compare/0.0.48-beta...0.0.49-beta
[0.0.48-beta]: https://github.com/PiBOH/jarock/compare/0.0.47-beta...0.0.48-beta
[0.0.47-beta]: https://github.com/PiBOH/jarock/compare/0.0.46-beta...0.0.47-beta
[0.0.46-beta]: https://github.com/PiBOH/jarock/compare/0.0.45-beta...0.0.46-beta
[0.0.40-beta]: https://github.com/PiBOH/jarock/compare/0.0.39-beta...0.0.40-beta
[0.0.39-beta]: https://github.com/PiBOH/jarock/compare/0.0.38-beta...0.0.39-beta
[0.0.38-beta]: https://github.com/PiBOH/jarock/compare/0.0.37-beta...0.0.38-beta
[0.0.37-beta]: https://github.com/PiBOH/jarock/compare/0.0.36-beta...0.0.37-beta
[0.0.36-beta]: https://github.com/PiBOH/jarock/compare/0.0.35-beta...0.0.36-beta
[0.0.35-beta]: https://github.com/PiBOH/jarock/compare/0.0.34-beta...0.0.35-beta
[0.0.34-beta]: https://github.com/PiBOH/jarock/compare/0.0.33-beta...0.0.34-beta
[0.0.33-beta]: https://github.com/PiBOH/jarock/compare/0.0.32-beta...0.0.33-beta
[0.0.32-beta]: https://github.com/PiBOH/jarock/compare/0.0.31-beta...0.0.32-beta
[0.0.31-beta]: https://github.com/PiBOH/jarock/compare/0.0.30-beta...0.0.31-beta
[0.0.30-beta]: https://github.com/PiBOH/jarock/compare/0.0.29-beta...0.0.30-beta
[0.0.29-beta]: https://github.com/PiBOH/jarock/compare/0.0.28-beta...0.0.29-beta
[0.0.28-beta]: https://github.com/PiBOH/jarock/compare/0.0.27-beta...0.0.28-beta
[0.0.27-beta]: https://github.com/PiBOH/jarock/compare/0.0.26-beta...0.0.27-beta
[0.0.26-beta]: https://github.com/PiBOH/jarock/compare/0.0.25-beta...0.0.26-beta
[0.0.25-beta]: https://github.com/PiBOH/jarock/compare/0.0.24-beta...0.0.25-beta
[0.0.24-beta]: https://github.com/PiBOH/jarock/compare/0.0.23-beta...0.0.24-beta
[0.0.23-beta]: https://github.com/PiBOH/jarock/compare/0.0.22-beta...0.0.23-beta
[0.0.22-beta]: https://github.com/PiBOH/jarock/compare/0.0.21-beta...0.0.22-beta
[0.0.21-beta]: https://github.com/PiBOH/jarock/compare/0.0.20-beta...0.0.21-beta
[0.0.20-beta]: https://github.com/PiBOH/jarock/compare/0.0.19-beta...0.0.20-beta
[0.0.19-beta]: https://github.com/PiBOH/jarock/compare/0.0.18-beta...0.0.19-beta
[0.0.18-beta]: https://github.com/PiBOH/jarock/compare/0.0.17-beta...0.0.18-beta
[0.0.17-beta]: https://github.com/PiBOH/jarock/compare/0.0.16-beta...0.0.17-beta
[0.0.16-beta]: https://github.com/PiBOH/jarock/compare/0.0.15-beta...0.0.16-beta
[0.0.15-beta]: https://github.com/PiBOH/jarock/compare/0.0.14-beta...0.0.15-beta
[0.0.14-beta]: https://github.com/PiBOH/jarock/compare/0.0.13-beta...0.0.14-beta
[0.0.13-beta]: https://github.com/PiBOH/jarock/compare/0.0.12-beta...0.0.13-beta
[0.0.12-beta]: https://github.com/PiBOH/jarock/compare/0.0.11-alpha...0.0.12-beta
[0.0.11-alpha]: https://github.com/PiBOH/jarock/compare/0.0.10-alpha...0.0.11-alpha
[0.0.10-alpha]: https://github.com/PiBOH/jarock/compare/0.0.9-alpha...0.0.10-alpha
[0.0.9-alpha]: https://github.com/PiBOH/jarock/compare/0.0.8-alpha...0.0.9-alpha
[0.0.8-alpha]: https://github.com/PiBOH/jarock/compare/0.0.7-alpha...0.0.8-alpha
[0.0.7-alpha]: https://github.com/PiBOH/jarock/compare/0.0.6-alpha...0.0.7-alpha
[0.0.6-alpha]: https://github.com/PiBOH/jarock/compare/0.0.5-alpha...0.0.6-alpha
[0.0.5-alpha]: https://github.com/PiBOH/jarock/compare/0.0.4-alpha...0.0.5-alpha
[0.0.4-alpha]: https://github.com/PiBOH/jarock/compare/v0.0.3-alpha...v0.0.4-alpha
[0.0.3-alpha]: https://github.com/PiBOH/jarock/compare/v0.0.2-alpha...v0.0.3-alpha
[0.0.2-alpha]: https://github.com/PiBOH/jarock/compare/v0.0.1-alpha...v0.0.2-alpha
[0.0.1-alpha]: https://github.com/PiBOH/jarock/releases/tag/v0.0.1-alpha
