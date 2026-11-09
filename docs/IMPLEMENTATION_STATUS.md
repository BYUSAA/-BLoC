# Implementation and verification status

Last repository review: 9 November 2026.

## Implemented in source

- [x] Flutter app entry point with safe Firebase setup fallback.
- [x] Material 3 light and dark themes.
- [x] AuthCubit for email/password, Google sign-in, password reset and sign-out flows.
- [x] Email verification on registration and verification enforcement for password sign-in.
- [x] PreferencesCubit for three persisted preferences.
- [x] Domain-level RecordsRepository contract and Firestore implementation.
- [x] RecordsCubit for live stream state, retry, CRUD orchestration and stream disposal.
- [x] Firestore owner isolation, field validation and composite query index.
- [x] Storage rules restricting user-owned files by type and size.
- [x] Unit tests for RecordsCubit and preference state.
- [x] Widget test for the records empty state.
- [x] Integration-test target for the Firebase configuration fallback.
- [x] GitHub Actions workflow for generated platform scaffolding, formatting, analysis, tests and Android APK build.

## Verification that is still required

The repository has been edited through GitHub, but this environment does not have the Flutter/Dart SDK and has not run the app on an Android emulator or phone. Do not report any of the following as passed until a real CI run or local run confirms it:

- [ ] Flutter dependency resolution and generated `pubspec.lock`.
- [ ] Generated Gradle wrapper JAR and complete platform runners.
- [ ] `dart format` with no pending changes.
- [ ] `flutter analyze --fatal-infos --fatal-warnings` with zero diagnostics.
- [ ] All unit and widget tests.
- [ ] Android release APK build.
- [ ] Firebase rules deployment and emulator/project security tests.
- [ ] Google sign-in on the registered Android package.
- [ ] Device-level CRUD and authentication checks.
- [ ] At least 70% test coverage target from the assignment.

Check the [GitHub Actions runs](https://github.com/BYUSAA/-BLoC/actions) and fix any failed step before calling the code build-ready.

## Inputs still needed for final assignment alignment

- Approved Figma prototype/export and the actual application problem/domain.
- Group number and the full list of team members' names and GitHub usernames.
- Firebase project access/configuration and registered Android app details.
- Genuine individual branch/commit evidence for every team member.

## Submission evidence still outstanding

- Final ERD for the approved domain.
- Updated screenshots from a real Android device.
- PDF report with research, design, architecture, data model, tests, collaboration and reflection.
- 10–15 minute recorded demonstration.

The current application is a generic authenticated records workspace. It is not yet the final Figma-matched assignment app.
