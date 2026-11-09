# BLoC Assignment — Flutter application

A mobile-first Flutter application foundation built with Cubit/BLoC, Clean Architecture, Firebase Authentication, Cloud Firestore and SharedPreferences.

> **Project status:** This repository contains an implementation foundation, not yet the final product-specific submission. The approved Figma design, app domain requirements, Firebase project details and group member information have not been supplied. The generic Records workspace must not be presented as the final approved app design.

## Implemented features

- Email/password registration and sign-in, including email verification.
- Google sign-in with cancellation handled as an unauthenticated result.
- Password-reset email and sign-out.
- Authenticated, owner-scoped Firestore records: create, live read, update and delete.
- Records presentation state managed through RecordsCubit.
- Three persisted preferences: dark theme, notifications setting and compact layout.
- Firestore and Storage security rules, plus the records query index.
- Firebase setup screen when compile-time Firebase options are missing.
- Unit, widget and integration-test targets.
- GitHub Actions checks for formatting, analysis, tests and Android release APK builds.

## Architecture

The code is feature-first and follows presentation / domain / data separation.

```text
lib/
  app/                 App shell, theme and startup routing
  core/                Firebase configuration and persisted preferences
  features/
    auth/
      data/            Firebase Authentication adapter
      domain/          Authentication contract
      presentation/    AuthCubit and sign-in UI
    records/
      data/            Firestore repository implementation
      domain/          Record entity and repository contract
      presentation/    RecordsCubit, workspace UI and widgets
```

The UI calls Cubits; Cubits depend on repository contracts; data implementations communicate with Firebase. See the architecture guide and Firestore contract in docs.

## Requirements

- Flutter 3.47.2 (or a compatible newer stable release) and its bundled Dart SDK.
- Android Studio with Android SDK and an Android emulator or physical Android device.
- Firebase project with Email/Password and Google providers enabled, plus Cloud Firestore.
- Google OAuth web/server client ID for Google sign-in.

GitHub Actions generates complete Android, iOS, web, Windows, Linux and macOS platform scaffolding when required runner files are missing. iOS/macOS builds require macOS and Xcode; Windows desktop builds require Visual Studio with C++ tools. Android is the primary assignment run target.

## Setup on Windows

Open the repository root in Android Studio. In PowerShell or Android Studio's terminal, run:

```powershell
flutter pub get
flutter doctor
flutter devices
```

Create a local, untracked firebase.local.json file in the repository root:

```json
{
  "FIREBASE_API_KEY": "your-firebase-api-key",
  "FIREBASE_APP_ID": "your-firebase-app-id",
  "FIREBASE_MESSAGING_SENDER_ID": "your-sender-id",
  "FIREBASE_PROJECT_ID": "your-project-id",
  "FIREBASE_AUTH_DOMAIN": "your-project.firebaseapp.com",
  "FIREBASE_STORAGE_BUCKET": "your-project.firebasestorage.app",
  "GOOGLE_SERVER_CLIENT_ID": "your-google-web-client-id"
}
```

The file is ignored by Git. Never commit Firebase service-account keys, signing credentials or private backend credentials.

Register the Android application ID com.example.bloc_assignment_app in Firebase. Enable Email/Password and Google in Authentication, add Android SHA-1 and SHA-256 fingerprints to the Firebase app, and use the OAuth web client ID as GOOGLE_SERVER_CLIENT_ID.

Run on an Android emulator or connected Android phone:

```powershell
flutter run --dart-define-from-file=firebase.local.json
```

Without the local Firebase configuration, the app deliberately opens the setup screen. Authentication and cloud CRUD require Firebase configuration.

## Quality checks

Run the repeatable PowerShell verification script:

```powershell
.\tooling\scripts\verify.ps1
```

It resolves dependencies, checks formatting, runs static analysis and tests with coverage, and builds the Android release APK. Use the SkipBuild switch to skip only APK packaging. Equivalent commands are:

```powershell
dart format .
flutter analyze --fatal-infos --fatal-warnings
flutter test --coverage
flutter build apk --release
```

A green CI or local run must be confirmed before claiming that the project is build-verified.

## Firebase deployment

Install the Firebase CLI, authenticate, select the intended project, then:

```powershell
firebase use YOUR_FIREBASE_PROJECT_ID
firebase deploy --only firestore:rules,firestore:indexes,storage
```

Review and test the rules against your project before enabling production data.

## Assignment completion still needed

1. Replace the generic Records workspace with the approved Figma screens and the actual app domain.
2. Add the team's ERD and any additional collections/entities required by the chosen app.
3. Confirm the Firebase project, Android package registration and Google OAuth configuration.
4. Add the real group number, member names and each member's genuine GitHub contributions.
5. Complete the report, capture genuine Android evidence and record the 10–15 minute demonstration.

See docs/IMPLEMENTATION_STATUS.md, docs/installation.md, docs/report-and-demo.md, CONTRIBUTING.md and SECURITY.md.
