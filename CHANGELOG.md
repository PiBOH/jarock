# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned

- Complete the public-release checklist in `TODO.md`.
- Keep all localized documentation synchronized with the English canonical documentation.

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
- Documented the actual bootstrap, verification, EULA, Geyser, Floodgate, path and error-handling flow, including the extra restart needed after Geyser generates its configuration.

### Changed

- Made the Windows bootstrap resolve paths from the repository location instead of a fixed folder.
- Added actionable remediation messages after bootstrap, Geyser, Java and server-process failures.
- Added long-path detection and an elevated `LongPathsEnabled` helper for deep Windows paths.
- Kept router, firewall and port-forwarding operations out of the bootstrap.

### Fixed

- Preserved spaces, Unicode characters and nested repository paths in launcher and PowerShell path handling.

### Planned

- Complete the public-release checklist in `TODO.md`.
- Keep all localized documentation synchronized with the English canonical documentation.

## [0.0.1-alpha] - 2026-08-05

### Added

- Fabric 26.2 server documentation in English and Italian.
- NeoForge fallback documentation in English and Italian.
- One-click Windows bootstrap and start entry point.
- Pinned Fabric 26.2 mod manifest with SHA-512 verification.
- Safe server and Geyser configuration templates.
- English public-release checklist in `TODO.md`.
- Semantic version file in `version.txt`.
- GitHub Actions autorelease workflow.

### Security

- Runtime worlds, logs, secrets, player lists and downloaded binaries are excluded from Git.
- The bootstrap never opens router ports or changes firewall settings.

[Unreleased]: https://github.com/PiBOH/jarock/compare/v0.0.3-alpha...HEAD
[0.0.3-alpha]: https://github.com/PiBOH/jarock/compare/v0.0.2-alpha...v0.0.3-alpha
[0.0.2-alpha]: https://github.com/PiBOH/jarock/compare/v0.0.1-alpha...v0.0.2-alpha
[0.0.1-alpha]: https://github.com/PiBOH/jarock/releases/tag/v0.0.1-alpha
