# CalcPro

A modern dark calculator built with Flutter and Dart.

## Features

- Basic arithmetic: addition, subtraction, multiplication and division
- Parentheses and percentage input
- Scientific functions: sine, cosine, tangent, square root, square and logarithm
- Dark interface with purple accents
- Automated Android release APK builds through GitHub Actions

## Build locally

Install the Flutter SDK, then run:

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release
```

The APK is generated at:

`build/app/outputs/flutter-apk/app-release.apk`

## Build with GitHub Actions

1. Open the **Actions** tab in this repository.
2. Select **Android APK**.
3. Select **Run workflow** and confirm.
4. Open the completed workflow run.
5. Download the **CalcPro-Android-APK** artifact.

A build also starts automatically when changes are pushed to the `main` branch.

## Notes

- Scientific trigonometric functions currently use radians.
- The APK is built in release mode.
