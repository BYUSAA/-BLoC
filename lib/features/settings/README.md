# Settings feature — preferences foundation

The current application exposes a small set of user interface preferences through the authenticated Records workspace. Preference state is implemented centrally in core/preferences rather than in a dedicated Settings feature module.

## Implemented preferences

| Preference | Default | Persistence |
| --- | --- | --- |
| Dark mode | Off | SharedPreferences |
| Notifications enabled | On | SharedPreferences |
| Compact layout | Off | SharedPreferences |

PreferencesCubit loads saved values when the application starts and provides methods to update each preference. If local storage is temporarily unavailable, the default/in-memory experience remains usable.

## Current UI

The preferences are exposed through the settings sheet in the current workspace. A dedicated Settings page, route, or complete settings information architecture has not been implemented here.

## Extension guidance

When the approved product design defines a full Settings feature:
- Reuse PreferencesCubit and its existing keys for these preferences.
- Add new preference state only for confirmed product requirements.
- Keep persistent preference behavior separate from transient screen state.
- Make permission-dependent settings explain their system requirements.
- Add tests for defaults, loading, updates, and persistence behavior.

Do not introduce a second preference store or claim that the notification preference schedules or delivers notifications; it currently stores a user preference value only.