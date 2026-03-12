# Firebase Setup Checklist

## Project

- [ ] Create Firebase project
- [ ] Add Android app
- [ ] Add debug SHA
- [ ] Add release SHA
- [ ] Download google-services.json
- [ ] Configure FlutterFire

## Services

- [ ] Auth
- [ ] Firestore
- [ ] Cloud Messaging
- [ ] Crashlytics
- [ ] Remote Config
- [ ] App Distribution

## Firestore Rules

Must enforce:

- users only access their own account
- pairs only visible to members
- events only visible to pair members
- no public profile browsing
- invite codes expire
- invite codes are one-time use

## Environments

Recommended:

- dev
- staging
- prod
