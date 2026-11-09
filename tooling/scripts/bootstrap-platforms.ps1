[CmdletBinding()]
param([switch]$Force)

$ErrorActionPreference = 'Stop'
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    throw 'Flutter is not on PATH. Configure the Flutter SDK before running this script.'
}

$requiredPaths = @(
    'android/gradle/wrapper/gradle-wrapper.jar',
    'ios/Runner.xcodeproj/project.pbxproj',
    'macos/Runner.xcodeproj/project.pbxproj',
    'windows/runner',
    'linux/runner'
)
$missing = @($requiredPaths | Where-Object { -not (Test-Path $_) })

if ($missing.Count -eq 0 -and -not $Force) {
    Write-Host 'All platform scaffolding is already present.'
    exit 0
}

if ($Force) {
    Write-Warning 'Force mode removes existing native platform folders before regenerating them.'
    $confirmation = Read-Host 'Type REGENERATE to continue'
    if ($confirmation -ne 'REGENERATE') {
        Write-Host 'Cancelled. No files were changed.'
        exit 0
    }
    @('android', 'ios', 'web', 'windows', 'linux', 'macos') | ForEach-Object {
        if (Test-Path $_) { Remove-Item -Recurse -Force $_ }
    }
}

flutter create --project-name=bloc_assignment_app --platforms=android,ios,web,windows,linux,macos .
if ($LASTEXITCODE -ne 0) { throw "flutter create failed with exit code $LASTEXITCODE." }
flutter pub get
if ($LASTEXITCODE -ne 0) { throw "flutter pub get failed with exit code $LASTEXITCODE." }
Write-Host 'Flutter platform scaffolding and dependencies are ready.' -ForegroundColor Green