# Shared test helpers

Use this directory for reusable test support that is needed by more than one test suite.

## Suitable contents

- Fake or in-memory repository implementations.
- Deterministic fixtures and test data builders.
- Shared widget setup and common finders.
- Helpers for controlled streams and asynchronous state transitions.
- Test-only configuration that does not require real production credentials.

## Testing principles

Prefer small fakes for Cubit and widget tests so the tests remain deterministic and do not depend on a live Firebase project. Keep tests for Firebase security rules and emulator behavior separate from isolated unit tests.

Do not put production code here, do not use real user accounts, and do not commit private Firebase configuration. Avoid helper abstractions that make a test harder to understand than the behavior it verifies.

When introducing a shared helper, add a focused test or usage example and keep fixtures representative of the current domain contract.