# Documentation

The canonical guide is written in English:

- [Minecraft Java 26.2 Fabric Server — English guide](en/server-guide.md)
- [Minecraft Java 26.2 NeoForge fallback — English guide](en/neoforge-fallback.md)

Italian companion translations are also available:

- [Guida italiana Fabric](it/server-guide.md)
- [Guida italiana NeoForge](it/neoforge-fallback.md)

## Translation policy

English is the source of truth for commands, file names, configuration keys, version numbers and links. Translations should preserve those items exactly and translate the explanations around them.

Requested locales:

- Afrikaans (`af`)
- Arabic (`ar`)
- Catalan (`ca`)
- Chinese, Simplified (`zh-CN`)
- Chinese, Traditional (`zh-TW`)
- Croatian (`hr`)
- Czech (`cs`)
- Dutch (`nl`)
- Farsi/Persian (`fa`)
- French (`fr`)
- Galician (`gl`)
- German (`de`)
- Hebrew (`he`)
- Hungarian (`hu`)
- Indonesian (`id`)
- Italian (`it`) — [Fabric available](it/server-guide.md), [NeoForge available](it/neoforge-fallback.md)
- Japanese (`ja`)
- Korean (`ko`)
- Latvian (`lv`)
- Malay (`ms`)
- Mongolian (`mn`)
- Polish (`pl`)
- Portuguese (`pt`)
- Romanian (`ro`)
- Russian (`ru`)
- Spanish (`es`)
- Swedish (`sv`)
- Slovenian (`sl`)
- Tamil (`ta`)
- Thai (`th`)
- Turkish (`tr`)
- Ukrainian (`uk`)

Each completed translation should contain both guides at:

```text
docs/<locale>/server-guide.md
docs/<locale>/neoforge-fallback.md
```

The English guides are intentionally complete before additional translations are added. This avoids translating obsolete instructions and makes it possible to update all languages from one canonical source. The Fabric guide remains the default; the NeoForge guide is the fallback when a required mod is unavailable for Fabric.

## Translation requirements

- Keep code blocks unchanged unless a comment is ordinary prose.
- Keep commands, paths, property keys, YAML keys, filenames and URLs unchanged.
- Keep warnings about authentication, backups, client-only mods, UDP ports and version matching.
- Use the English guide's date and version review information as the baseline.
- If a translation is behind the English guide, label it clearly as out of date rather than silently changing technical instructions.
