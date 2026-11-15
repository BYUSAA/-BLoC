# Image assets

This directory contains approved, static image assets used by the Flutter application. Add images only when they support an implemented screen or the approved design.

## Image guidelines

- Use descriptive lowercase filenames, for example app-mark.png or onboarding-overview.webp.
- Prefer WebP or appropriately compressed PNG/JPEG files for raster images.
- Export at the dimensions actually required by the interface; avoid shipping unnecessarily large originals.
- Preserve aspect ratio and provide appropriate fit/cropping behavior in the widget.
- Ensure useful contrast and alternatives for meaningful visual content.
- Verify ownership, attribution, and redistribution rights before committing files.

Do not commit private user photos, downloaded copyrighted artwork without permission, screenshots presented as test evidence, or secrets embedded in image metadata.

## Registering assets

Register the directory or individual files in pubspec.yaml under flutter.assets. Run flutter pub get after changing the asset manifest, then test the relevant screen on a device.

The starter currently relies on Flutter's built-in icons and does not require a custom image library.