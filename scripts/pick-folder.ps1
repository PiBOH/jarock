[CmdletBinding()]
param(
    [string]$Description = 'Select a folder'
)

# Small Windows folder picker used by parameter-manager.bat. Prints the selected
# folder path on success, or nothing when the user cancels. Kept in its own script
# so the batch FOR /F command line never has to embed parentheses or quoting.
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Windows.Forms
$Dialog = New-Object System.Windows.Forms.FolderBrowserDialog
$Dialog.Description = $Description
if ($Dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    Write-Output $Dialog.SelectedPath
}
