# BLoC Assignment — Flutter application

A mobile-first Flutter starter using Cubit/BLoC, Firebase Authentication,
Cloud Firestore, and SharedPreferences.

## Important project status
This repository began empty. The current application is a generic authenticated
records workspace used as a technical foundation. The approved Figma design and
the final product domain have not yet been supplied, so this is not yet the
finished assignment-specific app.

## Project setup
1. Install Flutter stable, Android Studio and Android SDK.
2. Run `flutter create --platforms=android,ios,web,windows,linux,macos .`
   from the repository root to generate platform-specific project files and
   wrappers with your installed Flutter version.
3. Run `flutter pub get`.
4. Configure Firebase using the steps in [docs/installation.md](docs/installation.md).
5. Run `dart format .`, `flutter analyze`, `flutter test`.
6. Run on an Android emulator or physical Android device with Firebase Dart
   defines supplied.

## Project layout
- `lib/app`: app shell, routes, theme and constants.
- `lib/core`: Firebase configuration, preferences, utilities and widgets.
- `lib/features`: authentication and records features.
- `lib/data`: shared data contracts and models.
- `firebase`: Firestore rules, indexes and Storage rules.
- `assets`: image, icon, font, animation and document resources.
- `docs`: architecture, installation, API contract and evidence guidance.
- `test` / `integration_test`: unit, widget and integration test locations.
- `.github/workflows`: automated Flutter validation.

## Firebase configuration
No Firebase project secrets or service-account keys are committed. Without
Firebase options the app now launches a setup screen rather than crashing.
Cloud authentication and CRUD require your Firebase project configuration.

See [implementation status](docs/IMPLEMENTATION_STATUS.md) for outstanding work.
