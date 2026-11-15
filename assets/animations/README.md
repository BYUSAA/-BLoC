# Animation assets

Use this directory for approved animations that are required by an implemented application screen.

## What belongs here

- Lottie JSON files or another animation format supported by a dependency already approved for the application.
- Small, reusable motion assets with a clear purpose, such as an onboarding illustration or a meaningful success state.

Do not add an animation merely for decoration. Prefer native Flutter animation APIs when the motion can be implemented without an external asset or package.

## Asset conventions

- Use descriptive lowercase names with hyphens, such as loading-records.json.
- Keep file sizes and frame rates reasonable for mobile devices.
- Avoid embedded personal information, remote tracking references, or unnecessary network dependencies.
- Check the asset's licence and redistribution terms before committing it.
- Provide a static or semantic alternative when motion communicates important information.

## Register and use

Register the directory or individual files under the flutter.assets section of pubspec.yaml. After adding an asset, run flutter pub get and test the screen on an Android device.

No specific animation dependency or animation-driven feature is currently required by the starter application.