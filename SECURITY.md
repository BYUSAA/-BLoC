# Security policy

## Reporting an issue

Do not publish credentials, exploitable vulnerabilities or private user data in a public issue. Use GitHub's private security reporting features where available.

## Credentials

Never commit Firebase service-account private keys, Android signing keystores/passwords, OAuth client secrets, backend credentials, real user data or local `firebase.local.json` files.

Firebase client configuration is not an authorization boundary. Protect all data with Authentication and strict Firestore/Storage rules.

## Data access

- Firestore records are scoped to `request.auth.uid`.
- A client cannot write a record for another user or change its owner.
- Document fields and lengths are checked by Firestore rules.
- Storage paths are scoped to the authenticated user's UID and uploads have type/size limits.
- Client-side navigation and form validation are not security controls; Firebase rules are authoritative.

## Before deployment

1. Select the intended Firebase project explicitly.
2. Review rules and indexes against the deployed data model.
3. Test allowed and denied operations with the Firebase Emulator Suite or a non-production project.
4. Confirm users cannot read, update or delete another user's records.
5. Confirm Storage ownership, type and size restrictions.
6. Check that no credentials or private data are present in Git history.