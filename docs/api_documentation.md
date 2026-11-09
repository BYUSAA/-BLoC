# Firebase API / data contract

## Authentication
- Register: Firebase email/password; sends email verification.
- Login: Firebase email/password.
- Google: Google provider through Firebase Authentication.
- Password reset: Firebase password reset email.
- Logout: Firebase sign-out.

## Firestore collection: records
| Field | Type | Description |
|---|---|---|
| ownerId | string | Auth UID that owns the document |
| title | string | Required, non-empty title |
| description | string | Optional descriptive text |
| updatedAt | timestamp | Server update timestamp |

All list queries filter by ownerId. Security rules enforce authenticated ownership.
