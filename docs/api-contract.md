# Firebase data contract

This contract describes the generic Records workspace. Update it when the approved application domain is available.

## Firestore collection

Path: records/{recordId}

| Field | Type | Requirement |
|---|---|---|
| title | string | Required; 1–100 characters |
| description | string | Required; 0–1,000 characters |
| ownerId | string | Required; must equal the authenticated Firebase UID |
| updatedAt | timestamp | Required; must equal the server request time |

The client uses a Firestore-generated document ID and writes updatedAt through FieldValue.serverTimestamp(). Reads filter by ownerId and sort by updatedAt descending. The composite index is stored in firebase/firestore.indexes.json.

## CRUD operations

| Operation | Client behavior | Security rule |
|---|---|---|
| Create | Add title, description, owner UID and server timestamp | Caller must be signed in; owner UID, fields, types and lengths are checked |
| Read | Subscribe to the signed-in user's records | Only documents owned by the caller can be read |
| Update | Change title/description and server timestamp | Caller must own the existing record; owner cannot change |
| Delete | Delete a selected record | Caller must own the existing record |

## Authentication

- Email/password registration sends an email verification link and clears the initial session.
- Password sign-in refuses unverified password accounts and triggers another verification email.
- Google sign-in uses a Google credential with Firebase Authentication.
- Password reset uses Firebase Auth's email reset flow.
- Sign-out clears the Google Sign-In session and Firebase Auth session.

## Storage

User-owned files, if added to the approved product, must be stored beneath:

~~~text
users/{userId}/{allPaths}
~~~

Storage rules require the authenticated UID to match the path UID. Create/update are limited to files smaller than 5 MiB and MIME types image/jpeg, image/png, image/webp or application/pdf. The present Records UI does not include a file upload screen.

## Security notes

The repository validates writes before sending them. Firestore rules independently validate ownership, field names, types, lengths and the server timestamp. Do not rely on client-side validation as the security boundary.
