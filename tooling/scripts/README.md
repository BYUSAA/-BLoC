# Developer scripts

This directory contains PowerShell scripts for repeatable local verification and Flutter platform scaffolding. Run commands from the repository root unless a script explicitly says otherwise.

## Verify the project

~~~powershell
.\tooling\scripts\verify.ps1
~~~

The verification script performs these steps and stops when a command fails:
1. Confirms that Flutter and Dart are available on PATH.
2. Resolves packages with flutter pub get.
3. Checks Dart formatting without modifying files.
4. Runs flutter analyze with infos and warnings treated as failures.
5. Runs the Flutter test suite with coverage.
6. Builds a release Android APK unless -SkipBuild is supplied.

To run the checks but omit APK packaging:

~~~powershell
.\tooling\scripts\verify.ps1 -SkipBuild
~~~

The script's success message means each command it invoked returned a successful exit code. It does not deploy Firebase rules, run an integration test on a physical device, or validate other desktop/mobile platform builds.

## Bootstrap platform scaffolding

~~~powershell
.\tooling\scripts\bootstrap-platforms.ps1
~~~

The bootstrap script checks for core native platform files and invokes Flutter's platform generator when required. It then resolves dependencies.

Force mode intentionally removes and regenerates native platform directories after an explicit typed confirmation:

~~~powershell
.\tooling\scripts\bootstrap-platforms.ps1 -Force
~~~

Do not use Force mode casually. Review and back up any custom native configuration before regeneration; the script replaces Android, iOS, web, Windows, Linux, and macOS platform folders.

## Safety and maintenance

- Never put passwords, tokens, service-account files, signing keys, or other secrets in scripts.
- Keep scripts deterministic and fail fast on non-zero command exit codes.
- Update this README when script behavior or parameters change.
- Validate scripts on a clean checkout and supported PowerShell/Flutter environment before relying on them in CI.