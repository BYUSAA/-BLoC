# Shared helpers

This directory is for small, deterministic helpers that are used by multiple features and do not belong to one feature's domain.

## Good candidates

- Pure formatting or transformation functions.
- Small common value helpers.
- Reusable functions with explicit inputs and outputs.

## Keep elsewhere

- Domain workflows and business rules belong in the owning feature's domain layer.
- Input validation that defines application-wide policy belongs in core/utils.
- Firebase queries belong in feature data implementations.
- Widget composition belongs in the appropriate presentation or shared widget directory.
- Stateful application behavior belongs in a Cubit/BLoC or a service with a clear lifecycle.

Prefer pure functions that can be unit-tested without bootstrapping Flutter or Firebase. Avoid vague catch-all files, hidden dependencies, mutable globals, and helper methods that conceal important business decisions.