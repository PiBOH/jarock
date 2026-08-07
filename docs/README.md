# Documentation

## English guides

- [Minecraft Java Fabric Server — installation guide](en/server-guide.md)
- [Minecraft Java NeoForge fallback](en/neoforge-fallback.md)
- [How does Jarock work?](en/how-does-jarock-work.md)

The English guides are the source of truth for the technical procedure. The current project version is stored only in the root `version.txt` file.

## Runtime and launch configuration

- `parameter-manager.bat` configures the loader, RAM, GUI/console mode, a conservative GC profile, online-mode, the ready banner and user-scoped Java environment setup. It edits a temporary copy and includes `Exit without saving` to discard all pending changes.
- `server-launch-settings.ini.template` is the tracked safe default.
- `server-launch-settings.ini` is local and ignored by Git.
- `java-home.txt` is an optional local override for a custom JDK folder and is ignored by Git; `JAROCK_JAVA_HOME` is the advanced equivalent.
- `scripts/java-runtime.ps1` finds a compatible 64-bit Java 25+ runtime even when Java 8 or Java 21 appears first on `PATH`; if none is available, the launcher lists the detected incompatible candidates and gives a Java 25 installation link.
- `scripts/configure-java-environment.ps1` updates only the current user's `JAVA_HOME` and `PATH`, preserving unrelated entries.

## How Jarock works translations

Each requested locale has a concise translated `how-does-jarock-work.md`. The English file is the complete explanation; localized files preserve essential technical steps and literals.

| Locale | Guide |
|---|---|
| `af` | [Afrikaans](af/how-does-jarock-work.md) |
| `ar` | [Arabic](ar/how-does-jarock-work.md) |
| `ca` | [Catalan](ca/how-does-jarock-work.md) |
| `zh-CN` | [Chinese Simplified](zh-CN/how-does-jarock-work.md) |
| `zh-TW` | [Chinese Traditional](zh-TW/how-does-jarock-work.md) |
| `hr` | [Croatian](hr/how-does-jarock-work.md) |
| `cs` | [Czech](cs/how-does-jarock-work.md) |
| `nl` | [Dutch](nl/how-does-jarock-work.md) |
| `fa` | [Farsi](fa/how-does-jarock-work.md) |
| `fr` | [French](fr/how-does-jarock-work.md) |
| `gl` | [Galician](gl/how-does-jarock-work.md) |
| `de` | [German](de/how-does-jarock-work.md) |
| `he` | [Hebrew](he/how-does-jarock-work.md) |
| `hu` | [Hungarian](hu/how-does-jarock-work.md) |
| `id` | [Indonesian](id/how-does-jarock-work.md) |
| `it` | [Italian](it/how-does-jarock-work.md) |
| `ja` | [Japanese](ja/how-does-jarock-work.md) |
| `ko` | [Korean](ko/how-does-jarock-work.md) |
| `lv` | [Latvian](lv/how-does-jarock-work.md) |
| `ms` | [Malay](ms/how-does-jarock-work.md) |
| `mn` | [Mongolian](mn/how-does-jarock-work.md) |
| `pl` | [Polish](pl/how-does-jarock-work.md) |
| `pt` | [Portuguese](pt/how-does-jarock-work.md) |
| `ro` | [Romanian](ro/how-does-jarock-work.md) |
| `ru` | [Russian](ru/how-does-jarock-work.md) |
| `es` | [Spanish](es/how-does-jarock-work.md) |
| `sv` | [Swedish](sv/how-does-jarock-work.md) |
| `sl` | [Slovenian](sl/how-does-jarock-work.md) |
| `ta` | [Tamil](ta/how-does-jarock-work.md) |
| `th` | [Thai](th/how-does-jarock-work.md) |
| `tr` | [Turkish](tr/how-does-jarock-work.md) |
| `uk` | [Ukrainian](uk/how-does-jarock-work.md) |

## Installation and fallback translations

Every requested locale has both an installation guide and a NeoForge fallback guide. The English files are ; localized files are concise summaries; files whose prose remains English are explicitly English fallback summaries and link to the complete English procedure. They do not include a project version; consult root `version.txt`.

Each local file has the same names:

- `docs/<locale>/server-guide.md`
- `docs/<locale>/neoforge-fallback.md`

The English guides remain authoritative for detailed network setup, troubleshooting, backup paths, compatibility checks and security warnings. The Italian guides are also detailed translations. Other localized files are concise summaries and are labeled accordingly; keep technical literals, commands, paths, keys and URLs unchanged when improving translations.

## Loader policy

Fabric is the first choice for native optimization and technical mods. NeoForge is the final loader fallback when a required mod is unavailable or unsuitable on Fabric. Forge is currently displayed as unavailable until an official Minecraft 26.2 server build is verified. Forge and NeoForge are distinct loaders; never install a Forge mod on NeoForge unless the mod author explicitly provides compatibility.
