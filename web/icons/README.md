# Web launcher icons

This directory contains the launcher and browser icons used by the Flutter web host. Flutter expects a set of standard icon filenames and dimensions, so preserve those names and platform references when replacing generated assets.

## Branding guidelines

- Use only approved project branding.
- Export the icon at the dimensions required by the web manifest and Flutter template.
- Keep the mark recognizable at small sizes and on light or dark browser surfaces.
- Avoid embedding personal data or copyrighted artwork without permission.
- Keep icon variants visually consistent with the mobile application.

## Updating icons

After replacing an icon, check web/manifest.json and web/index.html for the referenced file paths. Run the Flutter web build and inspect the result in a browser to confirm that the icon loads.

~~~bash
flutter build web --release
~~~

The web target is included as a Flutter platform scaffold. The assignment's primary demonstration target remains Android, and a web icon set alone does not demonstrate that the app has been validated in a browser.