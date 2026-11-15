# Cross-feature services

Use this directory for infrastructure services whose responsibilities span multiple application features and do not belong to a single feature's data layer.

## Appropriate examples

- A platform notification adapter used by multiple features.
- A secure device capability with a clear permission and lifecycle model.
- A cross-feature service that coordinates an external SDK without owning feature-specific business rules.

## Ownership guidelines

- Prefer a feature-owned repository when only one feature consumes the service.
- Expose small interfaces where a service needs to be replaced in tests.
- Make initialization and disposal explicit.
- Avoid service locators, global singletons, and hidden mutable state.
- Never embed credentials or production secrets in service code.

## Current state

No dedicated cross-feature service is required by the current starter. Firebase Authentication and Records data access remain in their respective feature data implementations; application preferences are managed by PreferencesCubit in core/preferences.

Add a service only when the product requirement and its consumers are clear.