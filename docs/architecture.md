# Architecture and data design

## Architectural style

The app uses feature-first Clean Architecture.

| Layer | Responsibility | Current implementation |
|---|---|---|
| Presentation | Screens, input validation and state rendering | Flutter widgets, `AuthCubit`, `RecordsCubit`, `PreferencesCubit` |
| Domain | Business entities and repository contracts | `Record`, `RecordsRepository` |
| Data | Remote/local data access | `AuthRepositoryImpl`, `RecordsRepositoryImpl`, SharedPreferences |

Presentation code should not call Firebase APIs directly. Cubits depend on repository contracts, and repository implementations own Firebase details. Add use cases in the domain layer when the final application introduces workflows that need orchestration or reusable business rules.

## Current feature boundaries

### Authentication

- `AuthCubit` owns authentication status, notices and user-facing errors.
- `AuthRepositoryImpl` owns Firebase email/password, email verification, Google sign-in, password reset and sign-out operations.
- Password-provider accounts must verify their email before the workspace can be opened.
- A cancelled Google account picker does not become a successful sign-in.

### Records

- `RecordsCubit` owns the Firestore record stream, loading/failure state and create/update/delete operations.
- `RecordsRepository` is the domain contract.
- `RecordsRepositoryImpl` filters every read by the current Firebase UID and validates input before writing.
- The Cubit cancels its stream subscription when closed.

### Preferences

`PreferencesCubit` loads and persists three independent settings through SharedPreferences: dark mode, notifications enabled and compact layout. Defaults remain usable when local preferences cannot be read.

## Current Firestore ERD

The present starter has one collection and relates each record to a Firebase Authentication user by UID.

```text
Firebase Authentication User
  uid (primary identity)
    |
    | 1 : many
    |
Firestore /records/{recordId}
  recordId      document ID
  ownerId       string, Firebase Auth UID
  title         string, 1–100 characters
  description   string, 0–1,000 characters
  updatedAt     timestamp
```

This is the current technical model, not necessarily the final assignment ERD. Extend it only after the approved app requirements and Figma design are available.

## Record flow

1. The authenticated workspace creates `RecordsCubit` with the `RecordsRepository` contract.
2. The Cubit subscribes to `watchRecords()`.
3. The repository queries `records` where `ownerId == currentUser.uid`, ordered by `updatedAt` descending.
4. Firestore security rules independently enforce owner access and validate the document shape.
5. Repository writes update the Firestore stream; the Cubit emits the latest list for the UI.

## Security principles

- Never trust a client-side owner ID; rules compare it with `request.auth.uid`.
- Keep service-account private keys out of source control.
- Validate the record title/description in the UI and repository, and repeat the constraints in Firestore rules.
- Use owner-scoped Storage paths and restrict accepted file types and sizes.
- Review and test Firebase rules before deploying them to a live project.

## Known scope boundary

The final Figma design, app-specific domain, group roster and Firebase project have not been supplied yet. The current record CRUD feature is an implementation sample and must be adapted to the approved project before final submission.
