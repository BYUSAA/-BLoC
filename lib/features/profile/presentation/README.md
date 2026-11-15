# Profile presentation — planned UI

This directory is reserved for profile pages and their presentation state. No dedicated profile screen is currently implemented in this folder.

When the approved design defines the profile flow:
- Add a page and profile-specific widgets here.
- Manage loading, editing, saving, and failure states in ProfileCubit or ProfileBloc.
- Obtain profile data through the feature's repository contract.
- Validate editable fields and show actionable feedback.
- Respect authentication state and the user's authorization.
- Add widget tests for display, edit, validation, and error scenarios.

Keep data access out of widgets. Do not duplicate the Authentication feature's session state or create a separate user identity source without an explicit domain requirement.