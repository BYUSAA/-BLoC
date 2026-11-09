# Installation and local setup

## Requirements
- Flutter stable and matching Dart SDK.
- Android Studio, Android SDK, and Android emulator or physical device.
- Firebase project with Email/Password and Google Authentication, Firestore.

## Generate complete native platform projects
From repository root run:

```bash
flutter create --platforms=android,ios,web,windows,linux,macos .
```

Flutter generates platform-specific project files, wrappers, registrants and
native IDE projects. iOS/macOS require macOS and Xcode; Windows requires
Windows and Visual Studio C++ tools.

## Configure Firebase
The app accepts Firebase options as compile-time Dart defines. Obtain app
configuration from Firebase Console / FlutterFire:

```bash
flutter pub get
flutter run -d <android-device-id> \
  --dart-define=FIREBASE_API_KEY=<api-key> \
  --dart-define=FIREBASE_APP_ID=<app-id> \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=<sender-id> \
  --dart-define=FIREBASE_PROJECT_ID=<project-id>
```

Optional: FIREBASE_AUTH_DOMAIN, FIREBASE_STORAGE_BUCKET and GOOGLE_SERVER_CLIENT_ID (the OAuth web/server client ID used by Google Sign-In).
Register Android application ID `com.example.bloc_assignment_app` in Firebase
and configure SHA-1/SHA-256 for Google sign-in. Never commit service-account keys.

Deploy rules with `firebase deploy --only firestore:rules,firestore:indexes,storage`.

## Validate on Android
```bash
dart format .
flutter analyze
flutter test
flutter devices
flutter run -d <android-device-id>
```

Without Firebase options, the app displays a setup screen instead of crashing.
Cloud authentication and data operations require Firebase configuration.
