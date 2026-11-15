# Bundled document assets

This directory is reserved for static documents that the application intentionally ships with, such as approved help material, onboarding instructions, or sample content.

## Include only

- Documents that are part of the product experience.
- Files that are safe to distribute to every installation.
- Material that has an approved source and redistribution licence.

Do not store assignment submissions, screenshots used as evidence, user-uploaded documents, private records, credentials, or environment configuration here. Those files have different ownership and handling requirements.

## Naming and registration

Use descriptive lowercase filenames, preferably with hyphens. Register required files under flutter.assets in pubspec.yaml and reference them through the app's asset-loading code.

Before committing a document, verify that it is current, accessible, readable on a phone, and licensed for redistribution. The current starter does not depend on a bundled document.