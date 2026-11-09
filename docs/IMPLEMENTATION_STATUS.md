# Implementation and verification status

Last reviewed: 9 November 2026.

## Implemented in the source tree

- [x] Flutter entry point with Firebase initialization and an explicit setup fallback.
- [x] Material 3 light/dark themes and centralized app constants.
- [x] AuthRepository contract and Firebase Auth/Google Sign-In implementation.
- [x] Email/password registration, verification enforcement, password reset and sign-out.
- [x] AuthCubit with busy state, clear feedback and safe user-facing messages.
- [x] Shared validation functions for email, password, title and description.
- [x] PreferencesCubit for three locally persisted preferences.
- [x] Records domain entity and repository contract.
- [x] Firestore RecordDto and repository implementation.
- [x] RecordsCubit for live updates, CRUD coordination, retry and stream disposal.
- [x] Firestore ownership rules, record constraints, server timestamp checks and composite index.
- [x] Storage rules scoped to user-owned paths with file type/size limits.
- [x] Unit tests for authentication, preferences, record equality and validation.
- [x] Widget tests for the sign-in screen and records workspace.
- [x] Integration-test target for the Firebase setup fallback.
- [x] Windows PowerShell verification and platform bootstrap scripts.
- [x] GitHub Actions workflow for platform generation, formatting, analyzer, tests and Android APK packaging.

## Not yet verified

The source has been edited through GitHub. This environment does not have the Flutter/Dart SDK or a connected Android emulator, so it has not performed a local Flutter run.

GitHub Actions has created runs, but the latest inspected run failed in the platform-bootstrap job before a runner was assigned; the job contained no executed steps or retrievable logs. That is not evidence of a Dart compile/test failure, and it is not evidence of a successful build either.

The following still require a successful CI or local run:

- [ ] Dependency resolution and a committed pubspec.lock.
- [ ] Generated Gradle wrapper JAR and full Android/iOS/web/desktop platform scaffolding.
- [ ] Clean dart format check.
- [ ] flutter analyze --fatal-infos --fatal-warnings with zero diagnostics.
- [ ] All unit and widget tests.
- [ ] Integration test on an Android emulator or phone.
- [ ] Android release APK build.
- [ ] Firebase rules deployment and emulator/project security tests.
- [ ] Email verification and Google sign-in on the registered Android application.
- [ ] Device CRUD and preference persistence checks.
- [ ] The assignment's 70% test coverage target.

Check GitHub Actions for a fresh run once hosted runner access is available.

## Inputs still required

- Approved Figma prototype/export and final application problem/domain.
- Group number and all members' names/GitHub usernames.
- Firebase project and registered Android app/OAuth configuration.
- Genuine contribution evidence for each group member.

## Submission evidence still outstanding

- Final domain ERD.
- Genuine Android screenshots.
- PDF report with research, design, architecture, data model, tests, collaboration and reflection.
- 10–15 minute demonstration recording.

The generic Records workspace is not the final Figma-matched assignment app.
