# Flutter BLoC Assignment

A mobile-first Flutter starter using BLoC/Cubit, Clean Architecture, Firebase Authentication, Cloud Firestore, and SharedPreferences.

## Included
- Email/password registration and sign-in, Google sign-in, password reset, and sign-out.
- Firestore create/read/update/delete for owner-scoped records with live snapshot updates.
- Three persisted preferences (dark theme, notifications preference, compact layout).
- Firestore owner-only security rules, basic tests, and GitHub Actions.

## Run locally (Android only)
1. Install Flutter and Android Studio.
2. Clone this repository and run flutter create --platforms=android . to generate Android platform scaffolding if it is not present.
3. Run flutter pub get.
4. Configure Firebase using flutterfire configure. Enable Email/Password and Google providers, register the Android app, add SHA fingerprints, and create a Firestore database.
5. Deploy firestore.rules, then run dart format ., flutter analyze, and flutter test.
6. Run on an Android emulator or physical Android device: flutter run.

## Important
The original repository was empty. This commit supplies a generic records workspace as a technical foundation. The approved Figma prototype and exact app domain have not been supplied, so this is not yet a pixel-perfect or final assignment implementation. See docs/IMPLEMENTATION_STATUS.md for remaining requirements and honest limitations.
