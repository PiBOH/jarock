# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned

- Complete the public-release checklist in `TODO.md`.
- Add additional translations from the English canonical documentation.

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

[Unreleased]: https://github.com/PiBOH/jarock/compare/v0.0.1-alpha...HEAD
[0.0.1-alpha]: https://github.com/PiBOH/jarock/releases/tag/v0.0.1-alpha
