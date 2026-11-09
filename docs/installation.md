# Installation and local setup

## Requirements

- Flutter stable with its matching Dart SDK.
- Android Studio, Android SDK and Android emulator or physical Android device.
- Firebase project with Email/Password and Google Authentication enabled, plus Cloud Firestore.
- Google OAuth web/server client ID for Google sign-in.

## 1. Resolve dependencies

From the repository root in Android Studio's terminal or PowerShell:

```powershell
flutter pub get
flutter doctor
flutter devices
```

The CI workflow generates any missing native project scaffolding and the dependency lockfile. To generate locally when needed:

```powershell
flutter create --overwrite --project-name=bloc_assignment_app --platforms=android,ios,web,windows,linux,macos .
flutter pub get
```

Flutter generates native IDE projects, plugin registrants and Gradle wrapper files. iOS/macOS require macOS and Xcode; Windows desktop builds require Visual Studio C++ tools. Android is the primary assignment run target.

## 2. Configure Firebase

Create a Firebase project, register the Android app with application ID `com.example.bloc_assignment_app`, and enable Email/Password and Google providers under Authentication. Create the Cloud Firestore database.

For Google sign-in, add the Android SHA-1 and SHA-256 fingerprints to the Firebase Android app and use the OAuth web/server client ID for the Dart define.

Create `firebase.local.json` in the repository root (it is ignored by Git):

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

Run the app:

```powershell
flutter run --dart-define-from-file=firebase.local.json
```

The four required values are API key, app ID, messaging sender ID and project ID. Auth domain, Storage bucket and Google server client ID are optional at compile time, but Google sign-in requires the correct native/OAuth configuration.

Without Firebase options, the app intentionally displays the setup screen. Cloud authentication and CRUD are unavailable until Firebase is configured.

## 3. Deploy Firebase rules and indexes

Install and authenticate with the Firebase CLI, select the correct project, then:

```powershell
firebase use YOUR_FIREBASE_PROJECT_ID
firebase deploy --only firestore:rules,firestore:indexes,storage
```

Review and test the rules against your project before using real data.

## 4. Validate and run on Android

```powershell
dart format .
flutter analyze --fatal-infos --fatal-warnings
flutter test --coverage
flutter devices
flutter run --dart-define-from-file=firebase.local.json
```

For a release package:

```powershell
flutter build apk --release --dart-define-from-file=firebase.local.json
```

Do not commit `firebase.local.json`, service-account keys, signing passwords or other private credentials.
