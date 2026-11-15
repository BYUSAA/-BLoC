# Application screenshots and evidence

Use this directory for genuine evidence captured from the running application after the relevant screen or workflow has been implemented.

## Evidence requirements

- Capture screenshots from an Android emulator or physical Android device.
- Show the actual application state; do not use mockups, edited composites, or generated images as proof of implementation.
- Do not expose passwords, access tokens, private email content, personal records, or other sensitive information.
- Keep the full screen and enough context visible to understand the workflow.
- Use consistent device dimensions where possible and capture both relevant success and validation/error states.

## Suggested file naming

~~~text
01-sign-in.png
02-registration.png
03-email-verification.png
04-records-workspace.png
05-create-record.png
06-edit-record.png
07-settings.png
~~~

Only include a screenshot for a flow that really exists and has been executed. The example names are a suggested sequence, not a statement that every screen is already complete.

## Captions and report mapping

For each screenshot, record:
- What the screenshot demonstrates.
- Device/emulator and build variant used.
- Preconditions (for example, signed-in test account).
- Related section in the project report or demonstration.

Keep a short evidence index in the report. A screenshot alone does not prove that Firebase security rules, backend authorization, or automated tests passed; cite the corresponding test or deployment evidence separately.