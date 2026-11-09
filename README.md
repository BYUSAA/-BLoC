# BLoC Assignment — Flutter application

A mobile-first Flutter application foundation built with Cubit/BLoC, Clean Architecture, Firebase Authentication, Cloud Firestore and SharedPreferences.

> **Project status:** This repository contains a working implementation foundation, not yet the final product-specific submission. The approved Figma design, app domain requirements, Firebase project credentials and group member details have not been provided. Do not present the generic Records workspace as the approved final design.

## What is implemented

- Email/password registration and sign-in, including email verification.
- Google sign-in with cancellation handled as an unauthenticated result.
- Password-reset email and sign-out.
- Authenticated, owner-scoped Firestore records: create, live read, update and delete.
- Records presentation state managed through `RecordsCubit`.
- Three persisted preferences: dark theme, notifications setting and compact layout.
- Firestore and Storage security rules, plus the records query index.
- A Firebase setup screen when compile-time Firebase options are missing.
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
      presentation/    AuthCubit and sign-in UI
    records/
      data/            Firestore repository implementation
      domain/          Record entity and repository contract
      presentation/    RecordsCubit, workspace UI and widgets
```

The UI calls Cubits; Cubits depend on repository contracts; data implementations communicate with Firebase. See [architecture](docs/architecture.md) and the [Firestore contract](docs/api-contract.md).

## Requirements

- Flutter stable and its bundled Dart SDK.
- Android Studio with Android SDK and an Android emulator or physical Android device.
- A Firebase project with Email/Password and Google providers enabled, plus Cloud Firestore.
- A Google OAuth web/server client ID for the Google sign-in flow.

The CI workflow generates complete Android, iOS, web, Windows, Linux and macOS platform scaffolding when any required runner file is missing. iOS/macOS builds require macOS and Xcode; Windows desktop builds require Visual Studio with C++ tools. The assignment's primary run target is Android.

## Setup on Windows

Open the repository root in Android Studio, then run:

```powershell
flutter pub get
flutter doctor
flutter devices
```

Create a local, untracked `firebase.local.json` file in the repository root:

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

The file is listed in `.gitignore`. Do not commit private service-account keys or other credentials.

Register the Android application ID `com.example.bloc_assignment_app` in Firebase. Enable Email/Password and Google in Authentication, add the Android SHA-1 and SHA-256 fingerprints to the Firebase Android app, and use the OAuth web client ID as `GOOGLE_SERVER_CLIENT_ID`.

Run on an Android emulator or connected Android phone:

```powershell
flutter run --dart-define-from-file=firebase.local.json
```

Without the local Firebase configuration, the app deliberately opens the setup screen. Authentication and cloud CRUD cannot work until Firebase has been configured.

## Quality checks

```powershell
dart format .
flutter analyze --fatal-infos --fatal-warnings
flutter test --coverage
flutter build apk --release
```

GitHub Actions runs the format, analyzer, test and Android release-build checks. The CI job can publish the generated Android release APK as a workflow artifact. A green local or CI run must be confirmed before claiming the project is build-verified.

## Firebase deployment

Install the Firebase CLI, authenticate, select the correct Firebase project, then deploy:

```powershell
firebase use YOUR_FIREBASE_PROJECT_ID
firebase deploy --only firestore:rules,firestore:indexes,storage
```

Review the rules and test them against your actual Firebase project before enabling production data.

## Assignment completion still needed

1. Replace the generic Records workspace with the approved Figma screens and the actual app domain.
2. Add the team's ERD and any additional collections/entities required by the chosen app.
3. Confirm the Firebase project, Android package registration and Google OAuth configuration.
4. Add the real group number, members and each member's genuine GitHub contributions.
5. Complete the assignment report, capture genuine Android evidence and record the 10–15 minute demo.

See [implementation status](docs/IMPLEMENTATION_STATUS.md), [installation](docs/installation.md), and [report/demo checklist](docs/report-and-demo.md).
