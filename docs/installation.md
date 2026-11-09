# Installation and local setup

## Requirements

- Flutter 3.47.2 with its bundled Dart SDK (the package supports Flutter 3.32+ and Dart 3.6+).
- Android Studio, Android SDK, and an Android emulator or physical Android device.
- Firebase project with Email/Password and Google Authentication enabled, plus Cloud Firestore.
- Google OAuth web/server client ID for Google Sign-In.

## 1. Resolve dependencies

Open the repository root in Android Studio. Run in its terminal or PowerShell:

~~~powershell
flutter pub get
flutter doctor
flutter devices
~~~

When native project scaffolding is incomplete, run:

~~~powershell
.\tooling\scripts\bootstrap-platforms.ps1
~~~

To deliberately remove and regenerate all native platform folders, use the script's -Force switch. It requires typed confirmation before deleting anything. Flutter generates platform project files and the Gradle wrapper. iOS/macOS builds require macOS and Xcode; Windows desktop builds require Visual Studio C++ tools. Android is the assignment's primary run target.

## 2. Configure Firebase

Create a Firebase project, register Android package com.example.bloc_assignment_app, enable Email/Password and Google sign-in in Authentication, and create a Cloud Firestore database.

Create an untracked firebase.local.json in the project root:

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

The file is ignored by Git. Never commit Firebase service-account private keys, OAuth secrets, Android signing keystores or passwords.

For Google Sign-In, add the Android SHA-1 and SHA-256 fingerprints to the Firebase app and use the OAuth web/server client ID as GOOGLE_SERVER_CLIENT_ID.

Start on an Android emulator or connected Android phone:

~~~powershell
flutter run --dart-define-from-file=firebase.local.json
~~~

Without the four required Firebase values (API key, app ID, sender ID and project ID), the app opens the Firebase setup screen. Authentication and Firestore operations are unavailable until Firebase is configured.

## 3. Deploy Firebase rules and indexes

Install the Firebase CLI, authenticate and select the intended project:

~~~powershell
firebase use YOUR_FIREBASE_PROJECT_ID
firebase deploy --only firestore:rules,firestore:indexes,storage
~~~

Review and test the rules against a non-production or emulator project before using real user data.

## 4. Run quality checks

~~~powershell
.\tooling\scripts\verify.ps1
~~~

The script performs package resolution, formatting validation, static analysis, unit/widget tests with coverage and Android release packaging. To skip only APK packaging:

~~~powershell
.\tooling\scripts\verify.ps1 -SkipBuild
~~~

Run the integration test on a connected Android device:

~~~powershell
flutter test integration_test/app_test.dart -d <android-device-id>
~~~

Do not claim zero warnings or a successful build until these commands or an equivalent successful CI run confirm it.
