# Contributing to Jarock

Thank you for helping maintain Jarock. This project is a beginner-friendly Windows bootstrap for a Minecraft Java 26.2 modded server, with Fabric as the first choice, NeoForge as fallback, optional Forge detection, and Java/Bedrock cross-play through Geyser and Floodgate.

## Project principles

- Keep the default architecture simple and loader-native; Fabric remains the first choice.
- Do not add router configuration, port forwarding, firewall changes or public-network automation to the bootstrap.
- Prefer a small, reproducible change over a large collection of optional components.
- Never commit generated server data, loader runtimes, downloaded mod `.jar` files, worlds, logs, credentials or Floodgate private keys. `server.jar` is a local runtime entry point and is intentionally ignored.
- Treat commands, paths, configuration keys, URLs, hashes and version numbers as technical literals: change them deliberately and document why.
- English is the Project language. Keep translated documentation synchronized with the English source when documentation changes.

## Repository layout

- `start-server.bat` — the single Windows entry point.
- `scripts/bootstrap-server.ps1` — the unified loader selection, Java discovery, installer downloads, SHA-512 verification and runtime setup entry point.
- `server/mods-manifest.ps1` and `server/mods-manifest-neoforge.ps1` — loader-specific pinned mod manifests.
- `scripts/java-runtime.ps1` — PowerShell 5.1-compatible Java runtime discovery.
- `scripts/configure-geyser.ps1` — safe Floodgate authentication configuration after Geyser generates its config.
- `server/` — templates and loader-specific manifests; generated `server.jar`, loader runtimes and downloaded mods are ignored.
- `docs/en/` — English guides.
- `docs/<locale>/` — localized guides.
- `TODO.md` — work required before public release.
- `scripts/version.txt` — current SemVer version, including its pre-release suffix.
- `CHANGELOG.md` — release notes in Keep a Changelog format.
- `.github/workflows/auto-release.yml` — release automation.

## Before changing code

1. Read the relevant script, template and documentation first.
2. Check the current `scripts/version.txt`, `CHANGELOG.md` and `.gitignore`.
3. Confirm that a change works on Windows PowerShell 5.1 as well as newer PowerShell where practical.
4. Preserve repository-relative paths. Do not introduce a fixed drive letter or working directory.
5. Preserve support for spaces, Unicode characters, `!` and deeply nested repository paths.
6. Keep error output actionable: every failure should explain what happened and provide a concrete `Suggested fix`.

## Java and bootstrap changes

- The configured Minecraft 26.2 setup requires a supported 64-bit Java 25 or newer runtime unless the selected official loader tooling states otherwise.
- Java selection must not trust only the first `java.exe` on `PATH`. Check the selected executable and version explicitly.
- When invoking Java from PowerShell or batch, use the selected absolute executable path and quote it so paths such as `C:\Program Files\...` work.
- Do not silently change or remove the Java requirement just to make Java 8 start.
- Do not download a Java runtime automatically unless the security, licensing, distribution and update behavior have been reviewed first.
- Do not store secrets or credentials in the repository. A generated `java-path.txt` is local runtime state and must remain ignored.

## Updating mods or Fabric

1. Confirm that the component explicitly supports Minecraft 26.2 and the selected loader.
2. Update the matching loader-specific manifest deliberately.
3. Record the exact URL and SHA-512 hash.
4. Check dependencies and whether the mod is server-side, client-side or both.
5. Start with a clean disposable runtime or backup.
6. Test startup, shutdown, Java joining, Bedrock joining, logs and the relevant gameplay.
7. Update the English guide and affected translations if behavior or instructions change.

Never add Sodium, Litematica, MiniHUD, Tweakeroo or another client-only mod to the dedicated server manifest without verifying that it truly supports server use.

## Documentation and translations

- Write the explanation in English first.
- Keep filenames, commands, paths, YAML/properties keys, URLs, hashes and code blocks unchanged when translating.
- Translate explanatory prose accurately; do not invent compatibility claims.
- If a translation is incomplete or temporarily behind English, label it clearly in `docs/README.md`.
- Update the documentation index whenever a guide is added, removed or renamed.

## Validation checklist

Before opening a pull request or release commit, run the checks available in the repository and verify at minimum:

- PowerShell parsing succeeds for every changed `.ps1` file.
- `git diff --check` succeeds.
- Markdown code fences are balanced.
- Relative Markdown links resolve.
- No generated runtime files, `server.jar` or secrets are staged.
- The bootstrap contains no router, firewall or port-forwarding commands.
- Version and changelog entries agree.
- The release workflow's required files changed together when preparing a release.

Do not claim that a full server start was tested unless the required Java runtime, downloads and environment were actually available. If a test cannot run, report the limitation and explain how another maintainer can reproduce it.

## Commit messages

Write descriptive commits so the history can be read without opening diffs:

1. Start with a concise subject line in the imperative mood, ideally under 72 characters, that names the change, for example `fix: auto-repair incomplete world data before server start`.
2. Add a blank line and then a body that explains what changed and why, the user-facing effect, and anything a reviewer must know. Do not repeat the whole diff; summarize the behavior.
3. Use a conventional prefix when it helps: `feat:`, `fix:`, `docs:`, `ci:`, `website:`, `refactor:`, `chore:`.
4. A one-line subject is acceptable only for truly trivial commits; otherwise always include the body.
5. Release commits keep the `v` prefix (for example `v0.0.28-beta`) as the subject and put the release details in the body.
6. After each user-requested repository change, create a commit and push it to `main` after validation. Prefer a detailed `v`-prefixed subject for code, documentation and maintenance changes. For changes limited exclusively to the website or GitHub workflows, a normal descriptive subject without `v` is acceptable.

## Versioning, changelog and release commits

Jarock uses Semantic Versioning in `scripts/version.txt`, for example:

```text
MAJOR.MINOR.PATCH-prerelease
```

Update `CHANGELOG.md` with every change, not only at release time: record user-facing changes under `[Unreleased]` in the same commit that introduces them, then fold them into the dated release section when the version is bumped.

Use `CHANGELOG.md` according to Keep a Changelog. The current prerelease channel is `beta`; use `-beta` for new prerelease versions unless the maintainer explicitly changes the channel. Keep the current project version in `scripts/version.txt`; do not duplicate it in general documentation:

- `Added` for new capabilities;
- `Changed` for changes to existing behavior;
- `Fixed` for corrections;
- `Security` for security-relevant changes;
- `Deprecated` or `Removed` when applicable.

For a release-test or release commit:

1. Bump `scripts/version.txt` deliberately.
2. Move the accumulated `[Unreleased]` entries into the matching dated section of `CHANGELOG.md`.
3. Ensure the version tag does not already exist.
4. Use a subject beginning with `v`, such as `v0.0.28-beta`, and describe the release in the commit body. Historical `-alpha` entries remain in the changelog; new prerelease commits should use the current `-beta` channel.
5. Push to `main` only after validation. The GitHub Actions workflow then validates the version and changelog and creates the prerelease.

To run `.github/workflows/auto-release.yml` manually, keep the existing **Create the release as a draft** option as needed and optionally fill in **Manual release version without the v prefix**. Enter only a SemVer value such as `0.0.52-beta`; do not type `v`. If the field is left empty, the workflow uses `scripts/version.txt`. This manual override applies only to `workflow_dispatch`; automatic release pushes continue to use `scripts/version.txt`.

`server/server.jar` is generated locally and ignored. Do not add it, loader runtimes, downloaded mods or generated files to a commit.

Do not rewrite published history or force-push unless the repository owner explicitly requests it.

## Security and privacy

Report suspected credential exposure, malicious downloads, hash mismatches or unsafe network behavior privately to the project maintainer before publishing details. Never attach `key.pem`, world data containing private information, or unredacted logs with personal addresses.

## Review expectations

Changes should be small enough to review, explain the user-facing effect, include remediation for likely failures and avoid unrelated refactors. A maintainer may request additional testing or documentation before merging.
