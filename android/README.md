# Android platform

This directory contains the native Android host project for the Flutter application. Android is the primary assignment and development target.

## Application identity

- Flutter package: bloc_assignment_app
- Android application ID: com.example.bloc_assignment_app
- Entry point: the Dart application in the repository's lib directory

The Android package/application ID must match the Android app registered in Firebase. If it changes, update the Firebase Android registration and any associated OAuth configuration.

## Open and run

Open the repository root (not only the android directory) in Android Studio. Confirm that the Android SDK, Gradle JDK, and an emulator or connected device are configured.

From the repository root, run:

~~~powershell
flutter pub get
flutter devices
flutter run --dart-define-from-file=firebase.local.json
~~~

Build a release APK:

~~~powershell
flutter build apk --release --dart-define-from-file=firebase.local.json
~~~

The generated APK is normally written to build/app/outputs/flutter-apk/app-release.apk.

## Firebase and local configuration

Register the Android application ID with the intended Firebase project. Enable the Authentication providers used by the app and add the appropriate Android SHA-1 and SHA-256 fingerprints.

Do not commit google-services.json unless the project explicitly requires a public client configuration file and the team has reviewed the repository policy. Never commit service-account credentials, signing keystores, passwords, or key.properties. Keep machine-specific local.properties out of version control.

## Native project maintenance

The Android project uses Gradle Kotlin DSL files. Keep the Android Gradle Plugin, Gradle wrapper, Kotlin plugin, JDK, and Flutter versions compatible. Prefer Flutter's generated configuration over arbitrary version upgrades.

Use the platform bootstrap script only when native scaffold files are missing:

~~~powershell
.\tooling\scripts\bootstrap-platforms.ps1
~~~

Review native changes after regeneration. Avoid Force mode unless you intentionally want to replace native platform folders; the script requests confirmation before doing so.

## Validation

The repository verification script includes dependency resolution, formatting, Dart analysis, tests, and an Android release APK build:

~~~powershell
.\tooling\scripts\verify.ps1
~~~

An Android build result from CI or a local build should be recorded separately; the presence of this directory alone does not prove that the application has been built or installed successfully.