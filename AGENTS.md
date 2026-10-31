# AGENTS.md

Instructions for AI coding agents working in this repository.

## 1. Project overview

**Jarock** is an open-source (MIT) Windows bootstrap and launcher for a modded
Minecraft Java dedicated server. It is not a mod: it downloads, verifies and
starts the server, keeps the world safe, and documents every step for a
beginner operator.

- **Language/runtime:** Windows PowerShell 5.1 scripts, `.bat` launchers, no build step.
- **Server stack:** Fabric (primary) or NeoForge (fallback), Java 25, Geyser and
  Floodgate for Bedrock cross-play.
- **Services:** GitHub Releases (updates), Modrinth CDN and Maven (server mods and
  installers), maven.neoforged.net and maven.fabricmc.net (loaders).
- **Layout:** launchers at the repository root, all logic under `scripts/`, all
  server-side templates and manifests under `server/`.

## 2. Architecture and file map

| Path | Role |
|---|---|
| `scripts/jarock.ini` | **single source of truth**: `JAROCK_VERSION`, `MINECRAFT_VERSION` and every launch setting |
| `scripts/jarock-config.ps1` | the only reader/writer for `jarock.ini` |
| `scripts/jarock-edition.ini` | packaging marker (CLI/Full or Lite); rewritten by the release job |
| `start-server.bat` | operator entry point: update check, bootstrap, EULA, server |
| `parameter-manager.bat` | interactive settings menu; edits a temporary copy, then saves |
| `scripts/bootstrap-server.ps1` | Java, loader, mods, datapack and world preparation |
| `scripts/run-server.ps1` | starts the server, reads its output, decides SAFE TO CLOSE |
| `scripts/console-interpreter.ps1` | Aternos-style `minecraft:` namespace for typed console ids |
| `scripts/registry-ids.txt` | vanilla block/item id list used by the interpreter |
| `scripts/update-jarock.ps1` | verified self-update from GitHub Releases |
| `server/mods-manifest*.ps1` | pinned mod builds per Minecraft line and loader |
| `server/datapacks-manifest.ps1` | pinned datapack builds |
| `.github/workflows/auto-release.yml` | publishes the CLI packages from `main` |

## 3. Branch and release policy

A branch per Minecraft line:

- `mc-26.2` - the Minecraft 26.2 source, including the TUI sources that are no
  longer published.
- `mc-26.3` - the Minecraft 26.3 line.
- `main` - the default branch, newest line, carries the release workflow.

Rules:

- **Only `main` publishes releases.** A `v` commit on `main` makes
  `auto-release.yml` build and publish the CLI packages. `mc-26.2` and
  `mc-26.3` only run the test workflows and never create a release.
- **Two Minecraft lines never share one server folder.** The installed engine,
  loader and mod set belong to the line recorded in
  `server/config/.jarock-minecraft-version`; switching lines requires
  `clean-server-runtime.bat`.
- Do not create scratch branches. Do the work on the branch that owns it.
- `main` and `mc-26.3` no longer ship TUI sources or a `jarock-tui.exe` asset.
  The TUI is unmaintained: CLI is the only published edition.

## 4. Versioning, changelog and commits

### `scripts/jarock.ini` is the single version source

`JAROCK_VERSION` holds a SemVer release such as `0.1.0-beta`. The release
workflow reads that line, uses it as the tag and the release title, and refuses
a release commit that does not change it. `MINECRAFT_VERSION` holds the
supported Minecraft line (`26.2` or `26.3`), is asked once on the first start,
and is stored back into the same file; `M. Choose Minecraft version` in
`parameter-manager.bat` writes the same line later, and
`scripts/validate-launch-settings.ps1` rejects any other value.

**Do not add a second copy of the version anywhere**, and do not edit the
package name by hand.

- **MINOR**: new features or a new Minecraft line.
- **PATCH**: compatible fixes and documentation-only program changes.
- **MAJOR**: only for genuinely breaking changes.
- The Minecraft target never goes into a release tag or title: only
  `JAROCK_VERSION` is used for those.

### `CHANGELOG.md`

Keep a Changelog format, newest first, sections `Added`, `Changed`, `Fixed`,
`Removed`, `Security` (omit empty ones). Every program change gets an entry
under the version being prepared. The section is what `Auto Release` publishes,
so write it for the operator: what Jarock does differently, in English.

### Commits

- **Every commit that changes program code starts with `v`**, for example
  `v: read the version from scripts/jarock.ini`.
- **English only**, title and body.
- **No co-author, no attribution footer.** Never add `Co-Authored-By:` or
  "Generated with" lines, and never credit the agent or the client.
- Put the details (what changed and why) in the body after a blank line.
- Documentation-only commits may use `docs:` and do not release anything.

## 5. Code conventions

- **Golden rule: if it works, do not touch it.** Change only what the task
  needs. No drive-by refactors, reformatting or renames.
- **`scripts/jarock.ini` is the only settings source.** Every script reads it
  through `jarock-config.ps1`. Do not reintroduce a settings file, and do not
  parse a setting inline when a helper exists.
- **PowerShell sources stay ASCII.** The release workflow rejects a `.ps1` file
  containing a byte above 127, because Windows PowerShell 5.1 misreads it.
- **Write config explicitly as UTF-8 without BOM.** `Get-Content -Encoding UTF8`
  for reads and `[IO.File]::WriteAllText(..., [Text.UTF8Encoding]::new($false))`
  for writes. Default ANSI reads corrupt accented world paths and the MOTD.
- **Never lose a byte of `server.properties`.** Rewrites go through
  `server-properties.ps1`, which preserves encoding and line endings.
- **Verification before trust.** Every downloaded artifact is checked against a
  pinned SHA-512 and removed when it does not match. Keep it that way.
- **The mod update path only touches Jarock's own files.** A jar in `server/mods`
  is refreshed only when its hash matches the value Jarock wrote in
  `server/config/.jarock-mods`; anything else is a manual change and is left alone.
- **Console input goes through `ConvertTo-NamespacedCommand`.** It qualifies only
  known registry ids and never the command name, selectors, numbers or free text.
- **SAFE TO CLOSE is a contract.** Only an explicit shutdown line starts the
  sequence, the world save must complete, and only then may the window close.
  Do not weaken it and do not let an autosave authorize it.
- **No long dash (em dash).** Use a hyphen, comma, colon, parentheses or a full stop.
- **Keep comments factual and in English.**

## 6. Build and verification

There is no build. The Windows test scripts are the verification:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/tests/test-windows-bootstrap.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/tests/test-updater-protection.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/tests/test-server-properties.ps1
```

Verification rules:

- A parse check is not a test of behaviour. Run the script that covers the
  changed path, and say what was actually run.
- A change to the console, the EULA handling, the settings file or the update
  path must be checked against the matching test script.
- Report a check that could not run as a limitation, never as a pass. A real
  Minecraft server cannot be started in CI, so a mod or loader change is
  verified only as far as downloads, hashes and manifests.

## 7. Installed skills

Community skills live under `.agents/skills/` (gitignored, local to the machine):

| Skill | Source | Use |
|---|---|---|
| `ponytail` | `dietrichgebert/ponytail` | smallest working solution, reuse before writing |
| `minecraft-fabric-dev` | `mcdxai/meteor-mcp-addon` | Fabric mod development conventions |
| `port-a-mod` | `rehan-remade/universal-modder` | porting mods between Minecraft versions |
| `minecraft-agent-skills` | `jahrome907/minecraft-agent-skills` | server administration and operations |

- `ponytail` applies to every coding task: prefer the smallest working change,
  reuse what exists, PowerShell and .NET before new code or dependencies. It
  never overrides an explicit request from the owner.
- `minecraft-fabric-dev` is installed from `mcdxai/meteor-mcp-addon` because
  `mcdxai/meteor-rejects-v2` does not exist (404).
- Install or update a skill with `npx skills add <owner/repo> -s <skill> -y -a '*'`.

## 8. Behaviour that must not regress

**The version was duplicated.** `scripts/version.txt` and
`scripts/server-launch-settings.ini` were merged into `scripts/jarock.ini`.
Nothing may read the old paths, and the updater must keep the operator's
settings while taking `JAROCK_VERSION` from the package.

**A fresh install required editing `server/eula.txt`.** The bootstrap now writes
`eula=true` itself and the template ships accepted, so a first start never stops
on the EULA prompt. The operator is still responsible for reading the EULA.

**Typed console ids needed a namespace.** `give @p oak_button` is sent as
`give @p minecraft:oak_button`, like the Aternos console. Only known registry
ids are touched.

**Mods pinned in a manifest never moved forward.** The bootstrap now refreshes
the builds it installed itself when Modrinth publishes a newer one for the same
Minecraft line and loader.

**The TUI was published and unmaintained.** TUI sources and `jarock-tui.exe` are
no longer part of `main`, and the release workflow publishes only CLI full and
lite packages.

## 9. Do not touch

- The SAFE TO CLOSE sequence in `run-server.ps1`.
- The `--nogui` handling and the classic console relaunch in the `.bat` files.
- The pinned SHA-512 values without downloading and verifying the replacement.
- `LICENSE` (MIT). Do not change it.

## 10. Security and legal

- Never log, print or commit credentials, tokens, server secrets or personal data.
- `scripts/jarock.ini` is tracked: never put a path or a secret in it that must
  stay private; world import/export paths are local values by design.
- Only use APIs and content the project is allowed to use; when a request
  involves third-party content or an unclear license, stop and ask the owner.
- The runtime data under `server/` stays local and gitignored.
