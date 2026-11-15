# Application features

The features directory groups the application by user-facing capability. Each implemented feature should own the presentation, domain contract, and data integration required for that capability.

## Current feature map

| Feature | Status | Responsibility |
| --- | --- | --- |
| auth | Implemented starter flow | Firebase sign-in, registration, verification, password reset, session restore, and sign-out |
| records | Implemented technical example | Owner-scoped Firestore record stream and create/update/delete operations |
| home | Extension point | Final dashboard and navigation, pending approved product requirements |
| profile | Extension point | Profile domain and screens, pending approved product requirements |
| settings | Partial UI | Preferences are persisted in core/preferences and exposed through the current workspace settings sheet |

The Records workspace is a generic technical example. Do not treat it as the final application domain or claim that Home and Profile screens are complete.

## Feature structure

A feature may use the following layers where appropriate:

~~~text
feature_name/
  data/
    data_source_or_repository_impl.dart
    dto.dart
  domain/
    entity.dart
    repository_contract.dart
  presentation/
    feature_cubit.dart
    feature_page.dart
    widgets/
~~~

Keep dependencies pointing inward: presentation depends on domain contracts, and data implements those contracts. Avoid importing one feature's private implementation from another feature.

## Adding a feature

Start from the approved requirements and Figma flow. Identify the domain entities and authorization rules, define a repository contract, implement data access, add Cubit/BLoC state, then build the UI and tests. Document any new Firebase collections or indexes and update the relevant security rules.

See docs/architecture.md for the detailed dependency and data-flow explanation.