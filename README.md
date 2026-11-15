# BLoC Assignment

A Flutter application that demonstrates **Cubit/BLoC state management**, feature-oriented architecture, Firebase Authentication, Cloud Firestore, and locally persisted preferences.

> **Project status:** This repository currently contains a technical starter application. Email/password and Google authentication, a generic owner-scoped Records workspace, and three preferences are implemented. The Records workspace is an example for demonstrating the architecture; it is not represented as the final product UI. The final screens and domain should be aligned with the approved design and assignment brief.

[Architecture](docs/architecture.md) · [Installation](docs/installation.md) · [Implementation status](docs/IMPLEMENTATION_STATUS.md) · [ERD](docs/ERD.md) · [Report and demo checklist](docs/report-and-demo.md)

## At a glance

| Area | Current implementation |
| --- | --- |
| Framework | Flutter / Dart |
| State management | flutter_bloc and Cubit |
| Architecture | Feature-oriented presentation, domain, and data layers |
| Authentication | Firebase email/password and Google sign-in |
| Data | Cloud Firestore Records collection |
| Local preferences | SharedPreferences |
| Security | Firestore owner checks and Firebase Storage type/size restrictions |
| Automated checks | GitHub Actions: formatting, analysis, tests, Android release build |
| Primary target | Android |

## Implemented functionality

- Register and sign in with email and password.
- Send email verification and password-reset emails.
- Sign in with Google, including cancellation and authentication error handling.
- Restore an authenticated session and sign out.
- Create, stream, update, and delete records in Cloud Firestore.
- Scope record queries and writes to the authenticated user's UID.
- Manage dark mode, notification preference, and compact layout with PreferencesCubit and SharedPreferences.
- Display a Firebase setup screen when compile-time Firebase configuration is unavailable.
- Validate record inputs and apply Firestore security rules and a composite query index.
- Provide unit, widget, and integration-test targets.

The repository includes a Firebase Storage rules file for user-owned uploads (images and PDFs under 5 MB). A UI upload flow is not advertised as implemented unless it is present in the application code.

## Repository layout

~~~text
.
├── .github/
│   ├── workflows/flutter_ci.yml
│   └── pull_request_template.md
├── android/                 Android host project
├── assets/                  Images, icons, animations, documents, fonts
├── docs/                    Architecture, setup, ERD, status and evidence guide
├── firebase/                Firestore rules, index and Storage rules
├── integration_test/        Device-level integration tests
├── lib/
│   ├── app/                 App shell, constants and theme
│   ├── core/                Firebase config, preferences, errors and utilities
│   ├── data/                 Shared data-layer extension points
│   ├── features/
│   │   ├── auth/             Authentication feature
│   │   ├── records/          Firestore Records example
│   │   ├── home/             Future dashboard extension point
│   │   ├── profile/          Future profile extension point
│   │   └── settings/         Preferences UI extension point
│   └── shared/               Shared helpers, models and widgets
├── test/                     Unit and widget tests
├── tooling/scripts/          Windows verification and platform scripts
├── pubspec.yaml
└── README.md
~~~

Feature-owned code stays in its feature. The shared data folders are extension points, not alternate copies of the Auth or Records repositories. See the [architecture guide](docs/architecture.md) for responsibilities and data flow.

## Requirements

- Flutter SDK compatible with the constraints in pubspec.yaml (Flutter 3.35 or newer).
- Dart 3.6 or newer, supplied with Flutter.
- Android Studio and Android SDK for the primary Android target.
- Android emulator or physical Android device.
- A Firebase project with Authentication, Cloud Firestore, and (when needed) Storage configured.
- Firebase CLI for deploying Firestore and Storage rules.

The repository's CI workflow is designed to run checks and build an Android APK. iOS/macOS builds require macOS and Xcode; Windows desktop builds require Visual Studio with the C++ desktop workload; Linux desktop builds require the relevant Linux toolchain.

## Quick start (Windows / Android Studio)

### 1. Clone and install dependencies

~~~powershell
git clone https://github.com/BYUSAA/-BLoC.git
cd -BLoC
flutter doctor
flutter pub get
flutter devices
~~~

Open the repository root in Android Studio. Confirm that the Android SDK is installed and that an emulator or phone appears in the device list.

### 2. Configure Firebase locally

Create a file named firebase.local.json in the repository root. Keep it local; it is excluded from Git.

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

Use values from your own Firebase project. Register the Android application ID com.example.bloc_assignment_app in Firebase. Enable the Email/Password and Google Authentication providers, add your Android SHA-1 and SHA-256 signing fingerprints, and configure the Google web/server client ID.

Firebase client configuration is not a substitute for security rules. Never commit service-account keys, private credentials, signing keystores, or production secrets.

### 3. Run the app

~~~powershell
flutter run --dart-define-from-file=firebase.local.json
~~~

When Firebase configuration is absent or initialization fails, the application displays a setup screen rather than attempting authenticated features. Authentication and Firestore functionality require a valid Firebase project configuration.

## Development and verification

Run the repository's PowerShell verification script from the project root:

~~~powershell
.\tooling\scripts\verify.ps1
~~~

The script runs dependency resolution, checks formatting without rewriting files, runs static analysis with warnings/info treated as failures, executes tests with coverage, and builds a release APK. To skip only the APK build:

~~~powershell
.\tooling\scripts\verify.ps1 -SkipBuild
~~~

Equivalent individual commands:

~~~powershell
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos --fatal-warnings
flutter test --coverage
flutter build apk --release
~~~

Run the integration test against a connected Android device using the actual device ID:

~~~powershell
flutter test integration_test/app_test.dart -d <android-device-id>
~~~

A check is considered passed only when a local command or a GitHub Actions run confirms it. This README does not imply that a build, Firebase deployment, or device test has been executed.

## Firebase rules and indexes

Review the rules before deploying them to a Firebase project. The current configuration defines:

- Firestore access for authenticated owners of documents in the records collection.
- Record field/type/length validation and a server timestamp requirement.
- A composite index for ownerId ascending and updatedAt descending.
- Storage access restricted to a user's own users/{userId}/ path, with image/PDF content types and a file-size limit below 5 MB.

Install and authenticate with the Firebase CLI, select the intended project, then deploy:

~~~powershell
firebase login
firebase use YOUR_FIREBASE_PROJECT_ID
firebase deploy --only firestore:rules,firestore:indexes,storage
~~~

Test rules in the Firebase Emulator Suite before using real user data. The local emulator ports are defined in firebase.json.

## Documentation

| Document | Purpose |
| --- | --- |
| [Installation](docs/installation.md) | Detailed prerequisites, Firebase setup, run and build commands |
| [Architecture](docs/architecture.md) | Layers, feature boundaries, and state/data flow |
| [Implementation status](docs/IMPLEMENTATION_STATUS.md) | Implemented areas and remaining work |
| [ERD](docs/ERD.md) | Current Records data model |
| [API contracts](docs/api-contract.md) | Current application data contract |
| [API documentation](docs/api_documentation.md) | Additional API reference material |
| [Report and demo](docs/report-and-demo.md) | Evidence, report, and presentation checklist |
| [Screenshots](docs/screenshots/README.md) | Rules for capturing genuine app evidence |

## Remaining product work

1. Replace the generic Records example with the actual problem domain, screens, and flows in the approved Figma prototype.
2. Update the ERD and data contract to match the final domain.
3. Confirm the Firebase project, Android registration, OAuth configuration, deployed rules, and required indexes.
4. Add the correct group number and team details where required by the assignment.
5. Capture genuine screenshots and a real device demonstration after the final screens and flows are implemented.
6. Run the full verification workflow and retain the actual results for the submission report.

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a change. Keep changes focused, use feature ownership, add or update tests, and do not commit private configuration.

## Security

Please do not publish credentials, access tokens, service-account files, or personal data in issues. See [SECURITY.md](SECURITY.md) for responsible vulnerability reporting.

## License

See [LICENSE](LICENSE).