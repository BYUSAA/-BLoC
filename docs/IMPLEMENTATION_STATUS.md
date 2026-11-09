# Implementation status

## Repository structure
- Flutter application source, feature-first folders, shared/core folders.
- Android Gradle configuration and Kotlin entry point.
- iOS Podfile, Runner plist/delegate and launch screen.
- Web entry point and manifest.
- Linux, macOS and Windows target directories with generation instructions.
- Assets, Firebase rules/indexes, docs, tests, tooling and CI workflow.

## Implemented app capabilities
- Cubit-based authentication and preferences.
- Email/password registration/login, Google sign-in, password reset, logout.
- Firestore record create/read/update/delete with live updates.
- Three persisted preferences.
- Owner-scoped Firestore rules.
- Graceful Firebase configuration screen if options are missing.

## Must still be completed on a machine with Flutter
1. Run `flutter create --platforms=android,ios,web,windows,linux,macos .` to generate SDK-version-specific native project files, Gradle wrapper JAR, platform runners and registrants.
2. Run `flutter pub get` to generate the real `pubspec.lock`.
3. Configure Firebase options and Google OAuth client IDs.
4. Run format, analyze, tests and Android device build; fix any diagnostics.
5. Capture genuine device screenshots and demo evidence.

## Assignment-specific inputs still missing
- Approved Figma link/export and app-specific entities/screens.
- Group number and members' GitHub usernames.
- Firebase project details / team access.

This document intentionally does not claim that native builds, Firebase deployment,
test coverage targets, or the final assignment design have already been verified.
