# Shared networking layer

This directory is reserved for transport and connectivity infrastructure that is genuinely shared across multiple features.

## Suitable contents

Examples may include:
- A configured HTTP client and shared request/response policy.
- Retry, timeout, and connectivity abstractions.
- Serialization or transport-level error mapping.
- Test doubles for a shared network client.

Add these only when a real application requirement needs them. A wrapper around a single SDK call is not automatically a reusable network layer.

## Current project behavior

The implemented Authentication and Records workflows use the Firebase SDKs directly through feature-owned data implementations. The starter does not currently require a separate REST client or a general-purpose HTTP networking package.

Keep Firestore queries and feature-specific data mapping in the owning feature's data layer. Do not put Flutter widgets, screen state, or domain workflows in this directory.

When adding shared infrastructure, document its lifecycle, error model, test strategy, and consuming features.