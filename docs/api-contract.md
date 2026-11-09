# Firebase data contract

This document describes the generic records starter. Update it when the final Figma-approved application domain is known.

## Firestore collection

Path: `records/{recordId}`

| Field | Type | Constraints | Purpose |
|---|---|---|---|
| `title` | string | Required; 1–100 characters | Record title |
| `description` | string | Required; 0–1,000 characters | Optional details stored as an empty string when omitted |
| `ownerId` | string | Required; must equal authenticated UID | Record owner |
| `updatedAt` | timestamp | Required | Sorting and last-update time |

The client creates a UUID document ID and writes `updatedAt` with `FieldValue.serverTimestamp()`. Reads are filtered by `ownerId` and ordered by `updatedAt` descending. The composite index is stored in `firebase/firestore.indexes.json`.

## Operations

| Operation | Client behavior | Security requirement |
|---|---|---|
| Create | Add title, description, owner UID and server timestamp | Authenticated owner UID must match `request.auth.uid`; document fields and sizes are validated |
| Read | Listen to the signed-in user's records | Only documents whose `ownerId` matches the caller are readable |
| Update | Change title/description and update timestamp | Caller must own the existing record and cannot change its owner |
| Delete | Delete selected record by document ID | Caller must own the existing record |

## Authentication

- Email/password registration sends a verification email and signs out the new account until verification is completed.
- Password sign-in sends another verification email and refuses access when the email remains unverified.
- Google sign-in uses Firebase Auth credentials from Google Sign-In.
- Password reset uses Firebase Auth's reset-email flow.
- Client navigation is not a security boundary; Firestore rules remain authoritative.

## Storage path

User files, if added by the final product, must be stored beneath:

```text
users/{userId}/{allPaths}
```

Storage rules allow access only to the matching authenticated UID. Create/update uploads are limited to less than 5 MiB and image JPEG/PNG/WebP or PDF MIME types. The current records UI does not implement an upload screen.

## Data integrity notes

The app validates input before sending writes. The Firebase rules independently validate owner, field names, data types and title/description lengths. Firebase rules are not a substitute for server-side validation in any future trusted backend.
