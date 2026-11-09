# iOS Flutter build settings

Flutter generates `Generated.xcconfig`, plugin registrants and build environment files in this folder. They are derived files and are ignored by Git where appropriate.

Regenerate with `flutter pub get` on a supported Flutter installation. iOS compilation and CocoaPods installation require macOS and Xcode; Android CI does not validate an iOS build.