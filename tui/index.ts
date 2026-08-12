import {
  Box,
  Input,
  InputRenderableEvents,
  Select,
  SelectRenderableEvents,
  Text,
  createCliRenderer,
} from "@opentui/core"
// Keep the Windows native DLL in Bun's standalone bundle. OpenTUI resolves
// this package dynamically at runtime, which is easy for a compiler to miss.
import nativeWindowsBackend from "@opentui/core-win32-x64"
import { spawn, spawnSync } from "node:child_process"
import { existsSync, mkdirSync, readFileSync, unlinkSync, writeFileSync } from "node:fs"
import { dirname, join } from "node:path"

if (process.argv.includes("--help")) {
  console.log("Jarock TUI: use start-server.bat or parameter-manager.bat to open the menu.")
  process.exit(0)
}
const smokeMode = process.argv.includes("--smoke")
if (!nativeWindowsBackend) throw new Error("The OpenTUI Windows native backend is missing.")
const root = process.env.JAROCK_ROOT || dirname(process.execPath)
const settingsPath = join(root, "scripts", "server-launch-settings.ini")
const templatePath = join(root, "scripts", "server-launch-settings.ini.template")
const renderer = await createCliRenderer({ exitOnCtrlC: true, clearOnShutdown: true, useMouse: true, autoFocus: true })
const main = Box({ width: "100%", height: "100%", flexDirection: "column", padding: 1, gap: 1 })
const title = Text({ content: "Jarock TUI", fg: "#00d7ff" })
const subtitle = Text({ content: "Windows terminal menu | DedicatedPower keeps the server window", fg: "#888888" })
const status = Text({ content: "Use Up/Down and Enter to choose an action. Ctrl+C exits.", fg: "#ffffff" })
const menu = Select({
  id: "jarock-menu", width: "100%", height: 12, wrapSelection: true,
  options: [
    { name: "Start server", description: "Open the server console and return here after it exits.", value: "start" },
    { name: "Check / install updates", description: "Run the verified updater for this installed edition.", value: "update" },
    { name: "Import / export world", description: "Configure safe world transfer operations.", value: "world" },
    { name: "Open parameter manager", description: "Edit Jarock settings in this TUI.", value: "parameters" },
    { name: "Clean runtime", description: "Run the existing cleanup confirmation flow.", value: "clean" },
    { name: "Exit", description: "Close the Jarock TUI.", value: "exit" },
  ], selectedBackgroundColor: "#145a72", selectedTextColor: "#ffffff", showDescription: true,
})
main.add(title); main.add(subtitle); main.add(status); main.add(menu); renderer.root.add(main)
menu.focus()
// createCliRenderer configures raw terminal input but starts in the IDLE
// control state. Start the loop explicitly so keyboard and mouse events are
// processed in standalone Windows builds as well as during development.
renderer.start()

function entry(name: string): string { return join(root, name) }
function readSettings(): Map<string, string> {
  const source = existsSync(settingsPath) ? settingsPath : templatePath
  const values = new Map<string, string>()
  if (!existsSync(source)) return values
  for (const line of readFileSync(source, "utf8").split(/\r?\n/)) {
    const match = line.match(/^([A-Z_]+)=(.*)$/)
    if (match) values.set(match[1], match[2])
  }
  return values
}
function value(name: string, fallback: string): string { return readSettings().get(name) || fallback }
function saveSettings(values: Map<string, string>): boolean {
  try {
    const tempPath = join(root, ".cache", "jarock-tui-settings.ini")
    mkdirSync(join(root, ".cache"), { recursive: true })
    const source = existsSync(settingsPath) ? readFileSync(settingsPath, "utf8") : readFileSync(templatePath, "utf8")
    const lines = source.replace(/\r\n/g, "\n").split("\n")
    const output = lines.map((line) => {
      const match = line.match(/^([A-Z_]+)=/)
      return match && values.has(match[1]) ? `${match[1]}=${values.get(match[1])}` : line
    })
    for (const [name, setting] of values) if (!output.some((line) => line.startsWith(`${name}=`))) output.push(`${name}=${setting}`)
    writeFileSync(tempPath, output.join("\r\n"), "utf8")
    const result = spawnSync("powershell.exe", ["-NoProfile", "-ExecutionPolicy", "Bypass", "-File", join(root, "scripts", "validate-launch-settings.ps1"), "-SettingsPath", tempPath], { cwd: root, encoding: "utf8" })
    if (result.status !== 0) { status.content = (result.stderr || result.stdout || "Settings validation failed.").trim(); return false }
    writeFileSync(settingsPath, readFileSync(tempPath))
    return true
  } catch (error) { status.content = `Could not save settings: ${error instanceof Error ? error.message : String(error)}`; return false }
}
function updateSetting(name: string, setting: string): boolean { const values = readSettings(); values.set(name, setting); return saveSettings(values) }
function runClassicConsoleBatch(path: string, args: string[] = []): void {
  const helper = entry(join("scripts", "classic-console.bat"))
  if (!existsSync(path) || !existsSync(helper)) { status.content = `Missing entry point: ${path}`; return }
  status.content = `Running ${path} in a separate classic console ...`
  // The helper owns the Windows Terminal/classic-console selection. A temporary
  // wrapper carries arguments safely, including paths containing spaces.
  const wrapper = join(root, ".cache", `jarock-tui-operation-${Date.now()}-${Math.random().toString(16).slice(2)}.bat`)
  const command = ["@echo off", `call "${path}" ${args.map((arg) => `"${arg.replaceAll('"', '""')}"`).join(" ")}`, "exit /b %errorlevel%"].join("\r\n")
  try {
    mkdirSync(join(root, ".cache"), { recursive: true })
    writeFileSync(wrapper, command, "ascii")
  } catch { status.content = "Could not create the TUI operation wrapper."; return }
  const child = spawn("cmd.exe", ["/d", "/c", "call", helper, "Jarock operation", wrapper, "/wait"], {
    cwd: root, windowsHide: false, stdio: "ignore", env: {
      ...process.env,
      JAROCK_TUI_BYPASS: "1",
      _JAROCK_CLASSIC_CONSOLE: "1",
    },
  })
  child.on("close", (code) => { try { unlinkSync(wrapper) } catch {} ; status.content = code === 0 ? "Operation finished. Choose another action." : `Operation exited with code ${code ?? 1}. Check the opened console.`; menu.focus() })
  child.on("error", (error) => { try { unlinkSync(wrapper) } catch {} ; status.content = `Could not start the operation: ${error.message}`; menu.focus() })
}
function showInputScreen(label: string, current: string, onSubmit: (next: string) => void): void {
  menu.visible = false
  const prompt = Text({ content: `${label}\nCurrent: ${current}\nPress Enter to save; Ctrl+C cancels the TUI.`, fg: "#ffffff" })
  const input = Input({ width: "100%", value: current, placeholder: "Type a value...", focusedBackgroundColor: "#173847", cursorColor: "#00d7ff" })
  main.add(prompt); main.add(input); input.focus()
  input.on(InputRenderableEvents.ENTER, (next: string) => { input.destroy(); prompt.destroy(); menu.visible = true; onSubmit(next); menu.focus() })
}
function openCliParameterManager(): void {
  runClassicConsoleBatch(entry("parameter-manager.bat"), ["/cli"])
}
function showWorldSettingsScreen(): void {
  menu.visible = false
  const worldMenu = Select({
    width: "100%", height: 8, wrapSelection: true, showDescription: true, selectedBackgroundColor: "#145a72",
    options: [
      { name: "Import world", description: `Source: ${value("WORLD_IMPORT_SOURCE", "none")}`, value: "import" },
      { name: "Export world", description: `Destination: ${value("WORLD_EXPORT_DEST", "none")}`, value: "export" },
      { name: "Back", description: "Return to the parameter menu.", value: "back" },
    ],
  })
  main.add(worldMenu); worldMenu.focus()
  worldMenu.on(SelectRenderableEvents.ITEM_SELECTED, (_index, option) => {
    worldMenu.destroy()
    if (option.value === "back") { menu.visible = true; menu.focus(); return }
    if (option.value === "export") {
      showInputScreen("World export destination (empty clears it)", value("WORLD_EXPORT_DEST", ""), (next) => {
        if (updateSetting("WORLD_EXPORT_DEST", next.trim())) status.content = "World export destination saved and validated."
        showWorldSettingsScreen()
      })
      return
    }
    showInputScreen("World import source: folder or .zip (empty clears it)", value("WORLD_IMPORT_SOURCE", ""), (next) => {
      const values = readSettings()
      values.set("WORLD_IMPORT_SOURCE", next.trim())
      values.set("WORLD_IMPORT_APPLIED", "false")
      if (!next.trim()) values.set("WORLD_IMPORT_REMEMBER", "false")
      if (saveSettings(values)) {
        if (next.trim()) showRememberWorldScreen()
        else { status.content = "World import source cleared."; showWorldSettingsScreen() }
      } else showWorldSettingsScreen()
    })
  })
}
function showRememberWorldScreen(): void {
  menu.visible = false
  const rememberMenu = Select({
    width: "100%", height: 6, wrapSelection: true, selectedBackgroundColor: "#145a72",
    options: [
      { name: "Remember this world (default)", description: "Reuse it only if the configured world is later deleted.", value: "true" },
      { name: "Use once only", description: "Clear the source after the next successful import.", value: "false" },
    ],
  })
  main.add(rememberMenu); rememberMenu.focus()
  rememberMenu.on(SelectRenderableEvents.ITEM_SELECTED, (_index, option) => {
    rememberMenu.destroy()
    if (updateSetting("WORLD_IMPORT_REMEMBER", String(option.value))) status.content = "World import remember setting saved."
    showWorldSettingsScreen()
  })
}
function showSettingsScreen(): void {
  menu.visible = false
  const settingsMenu = Select({
    width: "100%", height: 16, wrapSelection: true, showDescription: true, selectedBackgroundColor: "#145a72",
    options: [
      { name: `Loader [${value("LOADER_TYPE", "none")}]`, description: "Switch between Fabric and NeoForge.", value: "loader" },
      { name: `RAM [${value("RAM_INITIAL", "4G")} / ${value("RAM_MAX", "4G")}]`, description: "Use the validated CLI editor for RAM values.", value: "ram" },
      { name: `Server mode [${value("GUI_MODE", "nogui")}]`, description: "Toggle between console and GUI server mode.", value: "mode" },
      { name: `GC profile [${value("GC_PROFILE", "default")}]`, description: "Toggle default and low-pause profiles.", value: "gc" },
      { name: `Java environment [${value("AUTO_CONFIGURE_JAVA", "true")}]`, description: "Toggle current-user Java environment setup.", value: "java" },
      { name: `Online mode [${value("ONLINE_MODE", "true")}]`, description: "Toggle Mojang authentication; true is recommended.", value: "online" },
      { name: `Ready banner [${value("SHOW_READY_BANNER", "true")}]`, description: "Show or hide the ASCII ready banner.", value: "banner" },
      { name: `Startup updates [${value("AUTO_UPDATE_MODE", "install")}]`, description: "Cycle install, check-only, and never.", value: "updates" },
      { name: "World import/export", description: "Configure source, destination and remembered-world behavior.", value: "world" },
      { name: "Open full CLI manager", description: "Use the existing validated parameter-manager screens.", value: "cli" },
      { name: "Back", description: "Return to the main menu.", value: "back" },
    ],
  })
  main.add(settingsMenu); settingsMenu.focus()
  settingsMenu.on(SelectRenderableEvents.ITEM_SELECTED, (_index, option) => {
    settingsMenu.destroy()
    if (option.value === "back") { menu.visible = true; menu.focus(); return }
    // The existing CLI manager remains the authoritative validated editor for
    // complex settings (RAM, world paths and loader changes).
    if (option.value === "world") { menu.visible = true; showWorldSettingsScreen(); return }
    if (option.value === "cli") { menu.visible = true; openCliParameterManager(); return }
    if (option.value === "ram") {
      menu.visible = true
      showInputScreen("RAM values as INITIAL,MAX (for example 4G,8G)", `${value("RAM_INITIAL", "4G")},${value("RAM_MAX", "4G")}`, (next) => {
        const parts = next.split(",").map((part) => part.trim())
        const values = readSettings()
        if (parts.length === 2) { values.set("RAM_INITIAL", parts[0]); values.set("RAM_MAX", parts[1]); status.content = saveSettings(values) ? "RAM settings saved and validated." : "RAM settings were not changed." }
        else status.content = "RAM was not changed: use INITIAL,MAX."
        showSettingsScreen()
      })
      return
    }
    const key = String(option.value)
    if (key === "loader") {
      const nextLoader = value("LOADER_TYPE", "none") === "fabric" ? "neoforge" : "fabric"
      status.content = updateSetting("LOADER_TYPE", nextLoader) ? "Loader setting saved and validated." : "Loader setting was not changed."
      menu.visible = true; showSettingsScreen(); return
    }
    const current = value(key === "mode" ? "GUI_MODE" : key === "gc" ? "GC_PROFILE" : key === "java" ? "AUTO_CONFIGURE_JAVA" : key === "online" ? "ONLINE_MODE" : key === "banner" ? "SHOW_READY_BANNER" : "AUTO_UPDATE_MODE", "")
    const next = key === "mode" ? (current === "gui" ? "nogui" : "gui")
      : key === "gc" ? (current === "default" ? "low-pause" : "default")
        : key === "updates" ? (["install", "check", "never"][(Math.max(0, ["install", "check", "never"].indexOf(current)) + 1) % 3])
          : current === "true" ? "false" : "true"
    const settingName = key === "mode" ? "GUI_MODE" : key === "gc" ? "GC_PROFILE" : key === "java" ? "AUTO_CONFIGURE_JAVA" : key === "online" ? "ONLINE_MODE" : key === "banner" ? "SHOW_READY_BANNER" : "AUTO_UPDATE_MODE"
    menu.visible = true
    if (updateSetting(settingName, next)) status.content = `${settingName} saved and validated.`
    menu.focus()
  })
}

menu.on(SelectRenderableEvents.ITEM_SELECTED, (_index, option) => {
  switch (option.value) {
    case "start": runClassicConsoleBatch(entry("start-server.bat")); break
    case "update": runClassicConsoleBatch(entry(join("scripts", "update-jarock.bat"))); break
    case "world": showSettingsScreen(); break
    case "parameters": showSettingsScreen(); break
    case "clean": runClassicConsoleBatch(entry("clean-server-runtime.bat")); break
    case "exit": renderer.destroy(); break
  }
})
if (process.argv.includes("--parameters")) showSettingsScreen()
if (smokeMode) setTimeout(() => renderer.destroy(), 250)
process.on("SIGINT", () => renderer.destroy())
