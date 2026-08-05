# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned

- Complete the public-release checklist in `TODO.md`.
- Keep all localized documentation synchronized with the English canonical documentation.

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

[Unreleased]: https://github.com/PiBOH/jarock/compare/0.0.6-alpha...HEAD
[0.0.6-alpha]: https://github.com/PiBOH/jarock/compare/0.0.5-alpha...0.0.6-alpha
[0.0.5-alpha]: https://github.com/PiBOH/jarock/compare/0.0.4-alpha...0.0.5-alpha
[0.0.4-alpha]: https://github.com/PiBOH/jarock/compare/v0.0.3-alpha...v0.0.4-alpha
[0.0.3-alpha]: https://github.com/PiBOH/jarock/compare/v0.0.2-alpha...v0.0.3-alpha
[0.0.2-alpha]: https://github.com/PiBOH/jarock/compare/v0.0.1-alpha...v0.0.2-alpha
[0.0.1-alpha]: https://github.com/PiBOH/jarock/releases/tag/v0.0.1-alpha
