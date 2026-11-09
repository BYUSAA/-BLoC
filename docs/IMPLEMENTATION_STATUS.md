# Implementation status

## Included
- Flutter mobile application entry point and Material 3 theme.
- Cubit-based authentication and preferences state.
- Firebase email/password registration and sign-in, Google sign-in, password reset, and sign-out.
- Firestore record create, read, update, delete with live snapshot updates.
- Three persisted preferences: dark theme, notifications preference, and compact layout.
- Firestore owner-only security rules.
- Domain model and repository/data/presentation separation.
- GitHub Actions workflow for format, analyze, and test.

## Required before a real device run
1. Install Flutter and Android Studio; use an Android emulator or physical Android device.
2. Run flutter pub get.
3. Run dart pub global activate flutterfire_cli, then flutterfire configure for the Firebase project and Android app. This starter calls Firebase.initializeApp() without generated platform options, so valid native Firebase configuration must be added before runtime.
4. In Firebase Console, enable Email/Password and Google providers in Authentication.
5. Add Android SHA-1/SHA-256 fingerprints and configure OAuth client IDs as required by Google Sign-In.
6. Create a Firestore database and deploy firestore.rules.
7. Run dart format ., flutter analyze, and flutter test.

## Inputs still needed
- Approved Figma prototype URL/export and the exact app name/domain/features.
- Google Drive assignment/reference file contents and Canvas instructions if they contain additional requirements.
- Group number, member names, and each member's GitHub username for an accurate contribution tracker.
- Firebase project configuration/access. Never commit service-account private keys or secrets.

## Honest completion status
This is a functional starter implementation, not a claim of pixel-perfect Figma matching, deployed Firebase configuration, 70% test coverage, a release APK, or completed group contributions. Those require the team's design, Firebase project, real device validation, and genuine work by each member.
