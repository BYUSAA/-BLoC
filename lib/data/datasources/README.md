# Shared data sources

This directory is reserved for reusable data-source adapters consumed by more than one feature.

A data source is responsible for communicating with an external or local data provider. It should not contain screen logic or decide how the UI presents loading, success, and error states.

## Current feature ownership

The Firebase Authentication adapter is owned by features/auth/data. Firestore Records access is owned by features/records/data. Keep these implementations with their features while they serve only those feature workflows.

## Adding a shared source

Before placing a source here:
1. Confirm that at least two features need the same integration.
2. Define a small, testable contract.
3. Keep provider-specific response mapping at the data boundary.
4. Avoid importing Flutter presentation code.
5. Document configuration, failure behavior, and test setup.

Do not create parallel copies of feature-owned Firebase sources in this directory.