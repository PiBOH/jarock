import { createCliRenderer, Text } from "@opentui/core"

const renderer = await createCliRenderer({ exitOnCtrlC: false, clearOnShutdown: true })
renderer.root.add(Text({ content: "Jarock TUI native renderer smoke test passed." }))
setTimeout(() => renderer.destroy(), 250)
