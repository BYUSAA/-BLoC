# iOS Flutter-generated configuration

This directory contains Flutter-generated iOS build configuration and plugin integration files. These files are produced by the Flutter tool and should not be treated as the source of application business logic.

## Generated files

Depending on the Flutter SDK and build state, this directory may contain:
- Generated.xcconfig and other build configuration outputs.
- Plugin registrant and plugin build support files.
- Environment files used by Xcode and CocoaPods integration.

Do not hand-edit generated files unless a documented Flutter or plugin troubleshooting procedure specifically requires it. Generated files may be replaced by Flutter commands.

## Regeneration

From the repository root, on macOS with the required tools installed:

~~~bash
flutter pub get
flutter build ios
~~~

If CocoaPods dependencies need to be refreshed, use the project's supported CocoaPods workflow from the iOS directory. Review generated changes before committing them.

## Platform requirements

Building or running iOS requires macOS, Xcode, a valid Apple development setup, and the iOS Simulator or a registered device. Android CI does not validate iOS compilation.

Keep signing certificates, provisioning profiles, private keys, and machine-specific Xcode settings out of version control.