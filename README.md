# BLoC Assignment — Flutter application

A mobile-first Flutter application built with Cubit/BLoC, feature-first Clean Architecture, Firebase Authentication, Cloud Firestore and SharedPreferences.

> **Project scope:** The current app is a technical foundation with an authenticated Records workspace. The approved Figma prototype and final app-specific requirements have not been supplied, so the Records example is not claimed to be the finished product design.

## Implemented

- Email/password registration and sign-in with email verification.
- Google sign-in, including cancellation and OAuth error handling.
- Password-reset email and sign-out.
- Authenticated Firestore records: create, live read, update and delete.
- Records state managed by RecordsCubit; Firebase access is isolated in the data repository.
- Three persisted preferences: dark theme, notification preference and compact layout.
- Firestore owner checks, field validation and a query index.
- User-owned Firebase Storage rules with file type and size limits.
- Firebase setup screen when compile-time options are missing.
- Unit, widget and integration-test targets.
- GitHub Actions checks for formatting, static analysis, tests and Android release APK creation.

## Architecture

~~~text
lib/
  app/                 App constants, theme and app shell
  core/                Firebase config, errors, preferences, validators and widgets
  data/                Shared data-layer extension points only
  features/
    auth/
      data/            Firebase Authentication implementation
      domain/          Auth contract and application exception
      presentation/    AuthCubit and sign-in screen
    records/
      data/            Firestore repository and RecordDto
      domain/          Record entity and repository contract
      presentation/    RecordsCubit, workspace and empty state
  shared/              Cross-feature helpers, models and widgets
~~~

The UI talks to Cubits, Cubits depend on repository contracts, and data implementations communicate with Firebase. See the architecture guide, ERD and Firebase contract in docs.

## Requirements

- Flutter 3.47.2 and its bundled Dart SDK (the package constraint accepts compatible Flutter 3.27+ / Dart 3.6+).
- Android Studio with Android SDK and an Android emulator or physical Android device.
- Firebase project with Email/Password and Google sign-in providers enabled, plus Cloud Firestore.
- Google OAuth web/server client ID for Google sign-in.

Android is the primary assignment target. The CI workflow generates complete Android, iOS, web, Windows, Linux and macOS project scaffolding when SDK-generated files are missing. iOS/macOS require Xcode on macOS; Windows desktop requires Visual Studio C++ tools.

## Setup on Windows / Android Studio

Clone the repository and open its root folder in Android Studio. Run from its terminal:

~~~powershell
flutter pub get
flutter doctor
flutter devices
~~~

Create a local, untracked firebase.local.json in the repository root:

~~~json
{
  "FIREBASE_API_KEY": "your-firebase-api-key",
  "FIREBASE_APP_ID": "your-firebase-app-id",
  "FIREBASE_MESSAGING_SENDER_ID": "your-sender-id",
  "FIREBASE_PROJECT_ID": "your-project-id",
  "FIREBASE_AUTH_DOMAIN": "your-project.firebaseapp.com",
  "FIREBASE_STORAGE_BUCKET": "your-project.firebasestorage.app",
  "GOOGLE_SERVER_CLIENT_ID": "your-google-web-client-id"
}
~~~

This local file is ignored by Git. Firebase client configuration identifies the app; Firebase Authentication and security rules protect data. Never commit service-account private keys, signing keystores or private backend credentials.

Register Android package com.example.bloc_assignment_app in Firebase. Enable Email/Password and Google providers, add the Android SHA-1 and SHA-256 fingerprints to the Firebase app, and set the OAuth web client ID as GOOGLE_SERVER_CLIENT_ID.

Start the app on an Android emulator or connected Android phone:

~~~powershell
flutter run --dart-define-from-file=firebase.local.json
~~~

Without Firebase options, the app deliberately opens a setup screen. Authentication and Firestore operations need a configured Firebase project.

## Quality checks

Run the project verification script from the repository root:

~~~powershell
.\tooling\scripts\verify.ps1
~~~

This checks dependencies, formatting, analysis, unit/widget tests and Android release packaging. Use -SkipBuild to skip APK packaging.

Equivalent commands:

~~~powershell
dart format .
flutter analyze --fatal-infos --fatal-warnings
flutter test --coverage
flutter build apk --release
~~~

Run the integration test on a connected Android device:

~~~powershell
flutter test integration_test/app_test.dart -d <android-device-id>
~~~

A build or test is only considered passed when a local run or GitHub Actions result actually confirms it.

## Firebase deployment

Install and authenticate with the Firebase CLI, select the correct project, then deploy:

~~~powershell
firebase use YOUR_FIREBASE_PROJECT_ID
firebase deploy --only firestore:rules,firestore:indexes,storage
~~~

Test rules against the intended Firebase project before using production data.

## Still required for final assignment alignment

1. Replace the generic Records workspace with the screens and flows in the approved Figma prototype.
2. Replace/extend the example ERD with the actual app entities and relationships.
3. Confirm the Firebase project, Android app registration and Google OAuth configuration.
4. Add the correct group number and team roster; preserve genuine individual branches, commits and pull requests.
5. Complete the PDF report, capture real Android evidence and record the 10–15 minute demo.

See implementation status, installation, report/demo checklist, contribution guide and security policy in the docs and repository root.
