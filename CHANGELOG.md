# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

The active prerelease channel is now `beta`; new prerelease versions use the `-beta` suffix. Earlier `-alpha` entries are historical.

### Changed

- Documented the maintenance conventions in `CONTRIBUTING.md`: commits now require a detailed body explaining what and why, and `CHANGELOG.md` is updated with every change under `[Unreleased]` instead of only at release time.
- The parameter manager now renders a two-column main menu: the options are listed on the left and the current value of each setting (or an action hint) is shown on the right.

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
- Removed project-version literals from documentation; `version.txt` is the single source for the current project version.

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
- Semantic version file in `version.txt`.
- GitHub Actions autorelease workflow.

### Security

- Runtime worlds, logs, secrets, player lists and downloaded binaries are excluded from Git.
- The bootstrap never opens router ports or changes firewall settings.

[Unreleased]: https://github.com/PiBOH/jarock/compare/0.0.26-beta...HEAD
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
