# Authentication feature

The active authentication implementation is organized into `domain` (repository contract and AuthException), `data` (Firebase Authentication adapter) and `presentation` (AuthCubit and sign-in UI).

The canonical feature folder is `auth`; do not maintain a second `authentication` namespace.