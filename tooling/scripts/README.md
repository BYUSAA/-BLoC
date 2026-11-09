# Tooling scripts

Repeatable Windows developer scripts are stored here.

## Verify the project

Run from the repository root in PowerShell:

```powershell
.\\tooling\\scripts\\verify.ps1
```

This resolves dependencies, checks formatting, runs static analysis, executes unit/widget tests with coverage and builds the Android release APK. Use `-SkipBuild` to skip only APK packaging.

## Generate platform scaffolding

```powershell
.\\tooling\\scripts\\bootstrap-platforms.ps1
```

This checks for SDK-generated Android, iOS, macOS, Windows and Linux project files and creates them when missing. Use `-Force` only when you intentionally want to remove and regenerate native platform folders; it asks for explicit typed confirmation first.

Run scripts from the repository root. Never place credentials or secrets in committed scripts.
