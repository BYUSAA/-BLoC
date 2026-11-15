# Shared presentation widgets

Place small UI components here when they are reused across multiple features and have no single feature owner.

## Reuse criteria

A widget is a good candidate when it:
- Has a clear, reusable visual responsibility.
- Accepts its content and behavior through explicit parameters.
- Does not perform Firebase access or own business workflows.
- Is accessible and behaves correctly under the application's theme and text scaling.
- Can be tested independently.

Feature-specific components should remain beside the feature that owns them. Application-wide loading infrastructure currently includes AppLoading under core/widgets. Records-only empty-state presentation remains under features/records/presentation/widgets.

Before moving a widget, confirm that the shared location reduces coupling instead of introducing a generic component with many feature-specific flags.