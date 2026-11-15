# Home presentation — dashboard UI extension point

Use this directory for the Home feature's page, presentation Cubit/BLoC, and widgets once the approved dashboard design and requirements are available.

## Presentation responsibilities

- Render the dashboard from immutable state.
- Keep user interactions and state transitions in a HomeCubit or HomeBloc.
- Represent loading, loaded, empty, and failure states explicitly.
- Delegate data access to a Home repository contract.
- Keep navigation consistent with the application's route and authentication flow.

## Current status

There is no completed Home dashboard in this directory. The authenticated landing experience is currently the generic Records page in features/records/presentation. It should not be copied here and relabelled as a final dashboard.

Before building this UI, confirm the content, navigation, permissions, and empty/error states in the approved Figma prototype. Add widget tests for the principal states and interaction paths.