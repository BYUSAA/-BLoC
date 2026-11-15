# Shared data models

Use this directory for transport or persistence models that are genuinely shared by multiple features. A model in this folder should have a clear serialization responsibility and should not silently replace a feature's domain entity.

## Model boundaries

- Transport DTOs represent the shape expected by an external API or database.
- Domain entities represent application concepts and belong to their owning feature.
- Mapping between DTOs and domain entities should happen at the data boundary.
- Validate untrusted input before allowing it to affect application state.

## Current implementation

The Firestore DTO for the Records example is RecordDto in features/records/data/record_dto.dart. The Record domain entity is in features/records/domain/record.dart.

Keep both files within the Records feature unless a future requirement establishes that another feature shares the same data contract. Avoid duplicate definitions and implicit coupling to Firestore types in presentation code.