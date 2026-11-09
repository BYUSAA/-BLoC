# Contributing

This is an assessed team project. Every member must make genuine, reviewable contributions using their own GitHub account. Never fabricate authorship or attribute work to someone who did not perform it.

## Workflow

1. Read the assignment brief and implementation status.
2. Agree on the feature and acceptance criteria before coding.
3. Create a focused branch: `feature/<name>`, `fix/<name>`, `docs/<name>` or `test/<name>`.
4. Make small, coherent commits and open a pull request to `main`.
5. Review another member's work and respond to feedback.

## Commit messages

Use clear conventional messages such as:

- `feat(auth): add Google sign-in`
- `fix(records): prevent duplicate submissions`
- `test(preferences): verify persistence`
- `docs(architecture): explain data flow`

A commit must represent work actually performed by its author.

## Code expectations

- Keep the feature-first presentation/domain/data boundaries.
- Keep Firebase SDK calls inside data implementations.
- Keep app state in Cubit/BLoC; widget-local `setState` is acceptable for ephemeral UI details such as password visibility.
- Validate inputs and enforce ownership with Firebase rules.
- Add or update tests for changed behavior.
- Do not commit local Firebase configuration, service-account keys, signing files, build output or IDE state.

## Local verification

```powershell
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos --fatal-warnings
flutter test --coverage
flutter build apk --release
```

## Pull request checklist

- [ ] Branch is based on the latest `main`.
- [ ] Change matches the task and includes acceptance evidence.
- [ ] Tests are added/updated and pass locally.
- [ ] Formatting and analyzer checks pass.
- [ ] Firebase rules/indexes are updated when the data model changes.
- [ ] No credentials or unrelated files are included.
- [ ] UI changes match the approved Figma design.

For the report, preserve actual issues, branches, pull requests and commits. Explain each member's real contribution with links.