# Jarock interface support policy

## CLI — strongly recommended and maintained

The Jarock CLI editions (`jarock-cli-full` and `jarock-cli-lite`) are the **strongly recommended and maintained** interface. Use the CLI for new installations, regular server administration, parameter management, updates, cleanup and troubleshooting.

The CLI is the supported path for which Jarock actively maintains behavior, documentation and compatibility fixes.

## TUI — unmaintained, still distributed

The TUI editions (`jarock-tui-full` and `jarock-tui-lite`) and the standalone `jarock-tui.exe` will continue to be included in future releases so existing users can keep downloading the same edition family.

However, the TUI is **unmaintained** and provided **as-is**. It does not have an active compatibility or bug-fix guarantee. Problems with keyboard input, mouse input, terminal hosts or OpenTUI compatibility may remain unresolved. New users should choose a CLI edition instead.

The release workflow and automatic update system continue to preserve the selected CLI/TUI and Full/Lite edition. Choosing the CLI is therefore recommended, but existing TUI installations are not removed or automatically converted.

## Edition summary

| Edition | Support status | Recommendation |
|---|---|---|
| `jarock-cli-full` | Maintained | Strongly recommended for a fresh Full installation |
| `jarock-cli-lite` | Maintained | Strongly recommended for a fresh Lite installation |
| `jarock-tui-full` | Unmaintained, as-is | Keep using it only if you already need the TUI |
| `jarock-tui-lite` | Unmaintained, as-is | Keep using it only if you already need the TUI |

This policy does not change the server runtime, Fabric/NeoForge support, DedicatedPower behavior, release asset availability or the normal `start-server.bat` entry point.
