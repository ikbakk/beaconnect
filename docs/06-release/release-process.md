# Release Process

## Internal Alpha

Use Firebase App Distribution.

## Release Checklist

- [ ] Update changelog
- [ ] Run analyze
- [ ] Run tests
- [ ] Manual QA
- [ ] Accessibility check
- [ ] Crashlytics configured
- [ ] Firebase environment correct
- [ ] No debug logs
- [ ] Version bumped
- [ ] Build uploaded to App Distribution

## Release Commands

```text
flutter pub get
flutter analyze
flutter test
flutter build apk --release
```

## CI Support

GitHub Actions workflow:

```text
.github/workflows/android-release-checks.yml
```

This workflow runs:

- analyze
- tests
- release APK build

## Changelog Style

Human, not technical.

Good:

```text
Improved how Beaconnect shows recent updates when your connection is unstable.
```

Bad:

```text
Fixed Firestore sync bug.
```
