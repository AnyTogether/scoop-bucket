# Installs bucket/anyps5-desktop.json with Scoop, checks what it put in place and uninstalls it.
# The launcher itself is never started.
$ErrorActionPreference = 'Stop'

$app = 'anyps5-desktop'
$manifest = Join-Path $PSScriptRoot "..\..\bucket\$app.json" | Resolve-Path
$version = (Get-Content $manifest -Raw | ConvertFrom-Json).version

scoop install $manifest
$prefix = scoop prefix $app
if (-not $prefix -or -not (Test-Path (Join-Path $prefix 'anyps5_desktop.exe'))) {
    throw "anyps5_desktop.exe is not in the install folder ($prefix)"
}
foreach ($file in 'flutter_windows.dll', 'SDL2.dll', 'vcruntime140.dll', 'data\app.so') {
    if (-not (Test-Path (Join-Path $prefix $file))) { throw "$file is missing from $prefix" }
}
$installed = (Get-Content (Join-Path $prefix 'manifest.json') -Raw | ConvertFrom-Json).version
if ($installed -ne $version) { throw "Scoop installed $installed, the manifest says $version" }
$shortcut = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Scoop Apps\AnyPS5 Desktop.lnk'
if (-not (Test-Path $shortcut)) { throw "The Start menu shortcut is missing ($shortcut)" }
"Installed $app $version in $prefix, shortcut $shortcut"

scoop uninstall $app
if (Test-Path $prefix) { throw "$prefix is still there after the uninstall" }
if (Test-Path $shortcut) { throw "The shortcut is still there after the uninstall" }
"Uninstalled $app"
