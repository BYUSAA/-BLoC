# Shared data-layer extension point

This directory is reserved for data infrastructure that is reused by multiple features. The preferred default is to keep each feature's data source, DTO, and repository implementation beside the feature that owns the behavior.

## Current implementation

The active data access is feature-owned:

- Authentication: Firebase Authentication implementation in features/auth/data.
- Records: Firestore adapter and RecordDto in features/records/data.
- Domain contracts: defined beside the corresponding feature's domain entities.

The datasources, models, and repositories subdirectories currently act as shared extension points. They are not the active location for duplicate Auth or Records implementations.

## When to add shared code

Move a component here only when more than one feature uses the same data infrastructure and ownership is genuinely shared. Keep domain entities out of generic transport model folders, and avoid duplicating feature repository contracts.

See docs/architecture.md for the project's dependency direction and feature boundaries.