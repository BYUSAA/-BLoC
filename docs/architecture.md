# Architecture and data design

## Approach

The repository uses a feature-first Clean Architecture structure with presentation, domain and data boundaries.

| Layer | Responsibility | Current location |
|---|---|---|
| Presentation | Screen rendering, input handling and state | Feature pages, Cubits and widgets |
| Domain | Business entities and repository contracts | Feature domain folders |
| Data | Firebase and local persistence implementations | Feature data folders |
| Core | Shared configuration, errors, preferences and UI utilities | lib/core |
| App | App shell, themes and stable app constants | lib/app |

The presentation layer does not call Firebase directly. Cubits depend on domain repository contracts, and data adapters implement those contracts.

## Authentication flow

- AuthCubit owns authentication status, busy state, notices and safe user-facing errors.
- AuthRepository is the domain contract.
- AuthRepositoryImpl contains Firebase Auth and Google Sign-In SDK calls.
- Password-based registration sends a verification email and clears the Firebase session.
- Password sign-in refuses an unverified email account and sends another verification email.
- Google sign-in cancellation returns an unauthenticated result instead of pretending the user signed in.

## Records flow

- RecordsCubit subscribes to the repository's records stream, handles loading/failure/retry and coordinates create/update/delete mutations.
- RecordsRepository is the domain contract.
- RecordsRepositoryImpl checks the authenticated UID, validates write input and performs Firestore operations.
- RecordDto converts Firestore documents to the framework-light Record domain entity.
- The Cubit cancels its stream subscription when closed.

## Preferences

PreferencesCubit stores three local preferences in SharedPreferences:

- Dark theme.
- Notification preference.
- Compact layout.

If local storage is unavailable, the UI still operates with safe defaults and in-memory preference changes.

## Current Firestore ERD

The current starter model contains one collection. It is an example technical ERD and must be expanded or replaced if the approved project has different entities.

~~~text
Firebase Authentication User
  uid (identity)
     |
     | 1 : many
     |
Firestore /records/{recordId}
  recordId      document ID
  ownerId       Firebase Auth UID
  title         string, 1–100 characters
  description   string, 0–1,000 characters
  updatedAt     server timestamp
~~~

## Query and security

The repository queries records with ownerId equal to currentUser.uid and orders by updatedAt descending. A composite index for those fields is defined in firebase/firestore.indexes.json.

Firestore rules independently enforce authenticated ownership, immutable ownership on update, allowed field names, field types, size limits and server timestamps. Client-side validation and navigation are not security controls.

Storage rules restrict paths to users/{userId}/... and permit only the matching authenticated user to read or write. Create/update are limited to files smaller than 5 MiB with image JPEG/PNG/WebP or PDF content types.

## Future product-specific work

The approved Figma prototype, final problem domain and Firebase project details are not present yet. Add the real application entities, relationships, screens, use cases and data collections once those are confirmed. Do not treat the example Records model as the final ERD.
