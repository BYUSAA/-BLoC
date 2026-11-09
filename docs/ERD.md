# Initial Firestore ERD

The generic starter uses one records collection. Replace this model with the approved product domain's ERD if the Figma/project brief defines different entities.

```mermaid
erDiagram
  FIREBASE_AUTH_USER ||--o{ RECORD : owns
  FIREBASE_AUTH_USER {
    string uid PK
    string email
  }
  RECORD {
    string id PK
    string ownerId FK
    string title
    string description
    timestamp updatedAt
  }
```

## Collection contract
- Collection: records
- Document ID: generated UUID.
- ownerId: Firebase Authentication UID; required and immutable by security rule.
- title: non-empty string.
- description: string.
- updatedAt: Firestore server timestamp.

The query filters by ownerId. Create any composite indexes requested by Firebase and document them here.
