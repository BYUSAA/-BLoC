# iOS Runner application

The Runner directory is the native iOS host for the Flutter application. It contains the app delegate, application property list, launch screen resources, and Xcode project integration.

## Responsibilities

- Start the Flutter engine and register native plugins.
- Define iOS application metadata and supported launch configuration.
- Provide the native host project used by Flutter when building for iOS.

Keep application features and business logic in the Flutter lib directory unless a platform-specific capability genuinely requires native Swift or Objective-C code.

## Configuration

If iOS becomes a required target:
1. Create/register the iOS application in the intended Firebase project.
2. Use the matching iOS bundle identifier.
3. Add the Firebase iOS configuration through the team's approved local-secret/configuration process.
4. Configure URL schemes and entitlements only when required by enabled authentication providers or native functionality.
5. Confirm signing and capabilities in Xcode.

Do not commit provisioning profiles, signing certificates, private keys, or account-specific files.

## Build validation

iOS builds require macOS and Xcode. The repository's primary assignment workflow and Android release CI do not prove that the iOS runner builds successfully. Test with Xcode or Flutter on a supported Mac before claiming iOS support is validated.