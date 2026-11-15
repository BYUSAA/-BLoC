# Profile feature — planned capability

This directory is the ownership boundary for future user profile functionality. The current starter authenticates users with Firebase but does not define a complete product profile model or a dedicated Profile screen.

## Requirements to establish first

Before adding profile fields or editing flows, confirm:
- Which profile attributes the product actually needs.
- Which fields come from Firebase Authentication and which are application data.
- Whether users can edit each field and whether any field requires verification.
- How profile documents are created, read, updated, and deleted.
- Which users or services may access each field.
- How deletion, account changes, and missing profile data are handled.

Do not assume that every Firebase Authentication user property should be copied into a public profile document.

## Suggested feature layers

~~~text
profile/
  data/          Profile data source and repository implementation
  domain/        Profile entity and repository contract
  presentation/  Profile Cubit/BLoC, pages and widgets
~~~

Keep authorization enforced by Firebase security rules or the trusted backend, not only by visibility controls in the UI. Add focused unit, widget, and rules tests when the feature is implemented.