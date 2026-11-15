# Home feature — dashboard extension point

This directory is reserved for the final authenticated home/dashboard experience. The repository currently does not define the complete product requirements or approved Figma screens needed to implement that domain-specific dashboard.

## Current application behavior

After authentication, the starter currently opens the generic Records workspace implemented at features/records/presentation/records_page.dart. That workspace demonstrates Firebase-backed CRUD and Cubit state management; it is not the final Home feature.

## Before implementing Home

Use the approved product brief and Figma prototype to establish:
- The dashboard's purpose and the information users need at a glance.
- Navigation destinations and their access requirements.
- Any summary metrics and the source of truth for each value.
- Loading, empty, validation, error, and offline states.
- Responsive behavior, accessibility, and theme behavior.

## Suggested structure

~~~text
home/
  data/          Dashboard-specific aggregation or API access, if required
  domain/        Dashboard contracts and value objects
  presentation/  Home page, Cubit/BLoC and home-only widgets
~~~

Keep reusable application-wide widgets outside the feature. Do not duplicate RecordsPage or create placeholder metrics that imply data exists when it does not.