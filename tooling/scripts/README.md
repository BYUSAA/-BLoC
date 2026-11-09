# Windows developer scripts

Run from the repository root in PowerShell.

## Verify the project

~~~powershell
.\tooling\scripts\verify.ps1
~~~

This resolves packages, checks Dart formatting, runs fatal static analysis, executes unit/widget tests with coverage and builds the Android release APK. Use `-SkipBuild` to skip only APK packaging.

## Generate platform scaffolding

~~~powershell
.\tooling\scripts\bootstrap-platforms.ps1
~~~

This checks for SDK-generated project files and creates them when missing. Use `-Force` only to intentionally regenerate native platform folders; the script requires typed confirmation before deleting any files.

Never put credentials or secrets in committed scripts.