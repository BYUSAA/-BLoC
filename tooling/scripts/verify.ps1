[CmdletBinding()]
param([switch]$SkipBuild)

$ErrorActionPreference = 'Stop'

function Invoke-CheckedCommand {
    param([string]$Executable, [string[]]$Arguments)
    Write-Host "`n>>> $Executable $($Arguments -join ' ')" -ForegroundColor Cyan
    & $Executable @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Command failed with exit code $LASTEXITCODE : $Executable $($Arguments -join ' ')"
    }
}

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    throw 'Flutter is not on PATH. Configure the Flutter SDK before running this script.'
}
if (-not (Get-Command dart -ErrorAction SilentlyContinue)) {
    throw 'Dart is not on PATH. Dart is included in the Flutter SDK.'
}

Invoke-CheckedCommand -Executable 'flutter' -Arguments @('pub', 'get')
Invoke-CheckedCommand -Executable 'dart' -Arguments @('format', '--output=none', '--set-exit-if-changed', '.')
Invoke-CheckedCommand -Executable 'flutter' -Arguments @('analyze', '--fatal-infos', '--fatal-warnings')
Invoke-CheckedCommand -Executable 'flutter' -Arguments @('test', '--coverage')
if (-not $SkipBuild) {
    Invoke-CheckedCommand -Executable 'flutter' -Arguments @('build', 'apk', '--release')
}
Write-Host "`nAll requested checks completed successfully." -ForegroundColor Green