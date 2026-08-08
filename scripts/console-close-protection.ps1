# Best-effort close warning for the classic Windows console host.
# Windows Terminal and Alacritty may use a pseudoconsole that cannot deliver
# CTRL_CLOSE_EVENT reliably. Windows also imposes a short timeout on handlers,
# so no process can guarantee blocking forced termination indefinitely.

$ConsoleCloseProtectionCSharp = @'
using System;
using System.Runtime.InteropServices;

public static class JarockConsoleCloseProtection
{
    private const uint CTRL_CLOSE_EVENT = 2;
    private const uint MB_OK = 0x00000000;
    private const uint MB_ICONWARNING = 0x00000030;

    [UnmanagedFunctionPointer(CallingConvention.Winapi)]
    private delegate bool HandlerRoutine(uint controlType);

    [DllImport("kernel32.dll", SetLastError = true)]
    private static extern bool SetConsoleCtrlHandler(HandlerRoutine handlerRoutine, bool add);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    private static extern int MessageBoxW(IntPtr windowHandle, string text, string caption, uint type);

    private static readonly HandlerRoutine Handler = HandleConsoleControl;
    private static bool handlerInstalled;

    private static bool HandleConsoleControl(uint controlType)
    {
        if (controlType == CTRL_CLOSE_EVENT)
        {
            MessageBoxW(
                IntPtr.Zero,
                "Jarock is still running. To avoid corrupting the world, type stop in the server console (or close the Minecraft GUI normally), then wait for SAFE TO CLOSE. The console cannot be closed safely while the server is running.",
                "Jarock - safe shutdown required",
                MB_OK | MB_ICONWARNING);
            return true;
        }
        return false;
    }

    public static bool Start()
    {
        if (!handlerInstalled)
        {
            handlerInstalled = SetConsoleCtrlHandler(Handler, true);
        }

        // The close button remains visible so CTRL_CLOSE_EVENT can show the
        // warning. Windows may still terminate a console process after its
        // short control-handler timeout; this is intentionally best-effort.
        return handlerInstalled;
    }

    public static void Stop()
    {
        if (handlerInstalled)
        {
            SetConsoleCtrlHandler(Handler, false);
        }
        handlerInstalled = false;
    }
}
'@

if ($null -eq ('JarockConsoleCloseProtection' -as [type])) {
    Add-Type -TypeDefinition $ConsoleCloseProtectionCSharp -Language CSharp -ErrorAction Stop
}

function Enable-JarockConsoleCloseProtection {
    return [JarockConsoleCloseProtection]::Start()
}

function Disable-JarockConsoleCloseProtection {
    [JarockConsoleCloseProtection]::Stop()
}
