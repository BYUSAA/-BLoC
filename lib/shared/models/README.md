# Shared domain models and value objects

Use this directory only for domain-level value objects that are genuinely shared by more than one feature.

## Ownership rule

A model that belongs to one capability should remain in that feature's domain layer. This keeps terminology, invariants, and lifecycle close to the code that owns them.

The current Record entity belongs to features/records/domain/record.dart. The Firestore RecordDto belongs to features/records/data/record_dto.dart. Neither should be duplicated here.

## Model guidance

- Keep models immutable where practical.
- Define equality when it is useful for state comparison and testing.
- Validate invariants at construction or at a clearly defined boundary.
- Avoid coupling shared domain models directly to Firebase or Flutter UI types.
- Move a type here only after real cross-feature reuse is established.

A generic shared model folder should not become a dumping ground for loosely related data structures.