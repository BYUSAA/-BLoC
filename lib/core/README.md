# Core application infrastructure

The core directory contains application-wide technical services and utilities that can be used by more than one feature. It should not become a second location for feature-specific business rules.

## Current responsibilities

| Area | Responsibility |
| --- | --- |
| config | Compile-time Firebase options and initialization configuration |
| errors | Shared application exception representation |
| preferences | PreferencesState and PreferencesCubit backed by SharedPreferences |
| utils | Reusable input validators |
| widgets | Small reusable interface elements such as AppLoading |
| network | Reserved for shared networking infrastructure when required |
| services | Reserved for cross-feature platform or application services |

## Design rules

- Keep core dependencies independent of individual feature presentation widgets.
- Keep feature-specific Firebase access in the feature's data layer.
- Keep state changes in the owning Cubit/BLoC; avoid hidden mutable global state.
- Make utilities small and testable.
- Do not store secrets or credentials in source files.

## Existing preference state

PreferencesCubit currently persists dark mode, notification preference, and compact layout. It loads defaults safely when local storage is unavailable. A future dedicated Settings screen should reuse this Cubit rather than introduce a second preference store.

For feature boundaries and dependency direction, see docs/architecture.md.