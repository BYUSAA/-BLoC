# Records feature — Firestore CRUD example

The Records feature is the starter application's authenticated data workspace. It demonstrates the repository pattern, domain entities, Firestore DTO mapping, Cubit state management, and owner-scoped database access.

> **Scope note:** Records is a generic technical example. Replace or adapt it to the final application domain and approved Figma prototype before treating it as the finished product experience.

## Current behavior

- Subscribe to the signed-in user's records in real time.
- Create records with a title and optional description.
- Update an existing record.
- Delete a record.
- Display loading, empty, loaded, and failure states.
- Prevent concurrent mutations through the Cubit's mutation state.
- Validate title and description lengths at the repository boundary.
- Restrict data operations to the current authenticated user.

The backend Firestore rules independently check document ownership and the allowed record schema. Client-side owner filtering is not a replacement for those rules.

## Feature layout

~~~text
records/
  data/
    record_dto.dart
    records_repository_impl.dart
  domain/
    record.dart
    records_repository.dart
  presentation/
    records_cubit.dart
    records_page.dart
    widgets/
      records_empty_state.dart
~~~

## Firestore contract

Records are stored in the records collection. The document fields are:
- title: required non-empty string, maximum 100 characters.
- description: string, maximum 1,000 characters.
- ownerId: authenticated Firebase UID.
- updatedAt: server-generated timestamp.

The query filters by ownerId and orders by updatedAt descending. The composite index is declared in firebase/firestore.indexes.json.

## Change checklist

When changing this feature, update the domain entity, repository contract, DTO mapping, implementation, validation, Firebase rules, indexes, and tests together where applicable. Cover unauthenticated access, unauthorized ownership, invalid fields, stream failures, mutation failures, and empty states.

See docs/ERD.md and docs/api-contract.md for the current example data model and contract.