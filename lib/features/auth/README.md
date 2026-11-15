# Authentication feature

The Authentication feature owns the user sign-in lifecycle and Firebase Authentication integration.

## Current capabilities

- Email/password registration and sign-in.
- Email verification flow support.
- Password-reset email requests.
- Google sign-in through the configured Google client ID.
- Session restoration when the app starts.
- Sign-out and authentication state updates.
- Handling for user cancellation and authentication failures.

Actual provider availability depends on the Firebase project and OAuth configuration. A method in the client does not prove that a provider is enabled in Firebase.

## Feature layout

~~~text
auth/
  data/
    auth_repository_impl.dart
  domain/
    auth_exception.dart
    auth_repository.dart
  presentation/
    auth_cubit.dart
    sign_in_page.dart
~~~

- Domain defines the repository contract and authentication exception.
- Data implements the contract using Firebase Authentication.
- Presentation exposes authentication state through AuthCubit and renders the sign-in UI.

## Security and configuration

Configure the required providers in Firebase Authentication. Register the Android package and signing fingerprints, and supply the Google web/server client ID through the local Firebase configuration process.

Do not store passwords, access tokens, service-account keys, or private OAuth secrets in source code. Client-side checks improve usability but do not replace Firebase's server-side security controls.

## Testing and extension

Keep authentication logic in AuthCubit and the repository abstraction rather than in widgets. Add tests for state transitions, invalid credentials, provider cancellation, verification state, session restoration, and sign-out when changing behavior.

The canonical namespace is auth; do not create a parallel authentication directory.