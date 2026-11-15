# Settings presentation — current and planned UI

The current settings controls are presented in a bottom sheet within the authenticated Records workspace. They read and update the shared PreferencesCubit provided above the application.

## Current behavior

The controls update:
- Dark mode.
- Notification preference.
- Compact layout preference.

Values are persisted through SharedPreferences in core/preferences/preferences_cubit.dart. The notification preference is a stored setting; the starter does not claim that a notification delivery service is implemented.

## Future dedicated screen

When the final design requires a Settings page, add the page and settings-specific widgets here. Reuse the existing preference state and preserve a single source of truth. Add clear loading, permission, and error feedback for any future system-level setting.

Keep layout-only widgets in this directory when they belong exclusively to Settings. Promote a widget to a shared location only when multiple features actually use it.