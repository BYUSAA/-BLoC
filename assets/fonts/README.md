# Font assets

Use this directory for approved font files when the product design requires a typeface that is not available through the default Flutter typography.

## Adding a font

1. Confirm the family and required weights in the approved design system.
2. Obtain font files from a source that permits redistribution in the repository and application.
3. Use clear filenames that identify the family and weight.
4. Register the family and each weight under flutter.fonts in pubspec.yaml.
5. Reference the family consistently from the app theme rather than setting fonts independently in individual widgets.
6. Test legibility, fallback behavior, and layout on Android at different text scales.

Do not copy fonts from another computer, bundle unlicensed commercial files, or add unused font weights.

The current starter uses the Flutter/Material default typography and does not require a custom font.