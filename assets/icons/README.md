# Icon assets

Use Flutter's Material icon set for standard controls and familiar interface actions. Add custom assets here only when the approved product identity or interface requires an icon that is not adequately represented by a built-in icon.

## File conventions

- Prefer SVG for scalable vector artwork when the chosen Flutter renderer supports it; otherwise use optimized PNG files.
- Use descriptive lowercase filenames.
- Keep icon canvas sizes, alignment, and visual weight consistent.
- Include light/dark variants only when one asset cannot remain legible in both themes.
- Check third-party icon licences and attribution requirements.

## Using an asset

Register custom files in the flutter.assets section of pubspec.yaml and reference them from the relevant widget. Do not duplicate an icon as both a custom asset and a Material icon without a design reason.

The current application primarily uses Material icons and does not require a separate custom icon package.