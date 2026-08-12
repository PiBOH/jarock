import { createCliRenderer, Text } from "@opentui/core"
// Force Bun to include the OpenTUI Windows native DLL in this standalone smoke binary.
import nativeWindowsBackend from "@opentui/core-win32-x64"

if (!nativeWindowsBackend) throw new Error("The OpenTUI Windows native backend is missing.")
const renderer = await createCliRenderer({ exitOnCtrlC: false, clearOnShutdown: true })
renderer.root.add(Text({ content: "Jarock TUI native renderer smoke test passed." }))
renderer.start()
setTimeout(() => renderer.destroy(), 250)
