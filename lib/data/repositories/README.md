# Shared repository adapters

This directory is reserved for repository implementations that are genuinely shared across multiple features.

A repository implementation coordinates access to data providers and maps provider data into the application's domain contracts. It should not contain widget code or presentation-specific state.

## Current implementation

Authentication and Records repositories are owned by their respective features:

- Authentication contract and Firebase implementation: features/auth/domain and features/auth/data.
- Records contract and Firestore implementation: features/records/domain and features/records/data.

The shared repositories folder is not currently used for active feature repositories.

## Contribution guidance

- Keep a repository contract beside the domain feature that owns it.
- Place an implementation beside its owner unless there is a clear cross-feature reuse case.
- Inject dependencies so repositories can be tested with fakes or controlled Firebase instances.
- Translate provider failures at the data boundary into meaningful application errors.
- Enforce authorization in backend rules as well as in client-side code.

Do not duplicate an existing feature repository here merely to make the folder appear populated.