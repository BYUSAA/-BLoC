# Shared data layer extension point

Feature-specific Firebase data sources, DTOs and repositories should remain in their owning feature folders. This shared data directory is reserved for cross-feature infrastructure that is genuinely reusable.

The active Firestore Records adapter is located under `lib/features/records/data`.