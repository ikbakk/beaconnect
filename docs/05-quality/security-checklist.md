# Security Checklist

## Access

- [ ] User cannot read unrelated users
- [ ] User cannot read unrelated pairs
- [ ] User cannot write another user's events
- [ ] Invite codes are one-time use
- [ ] Invite codes expire server-side
- [ ] Pair membership enforced in Firestore rules

## Privacy

- [ ] No public profiles
- [ ] No profile photos in v1
- [ ] No public discovery
- [ ] Detailed history retention limited to 3 days
- [ ] Shared deletion requires mutual approval

## Logging

- [ ] No raw coordinates in logs unless explicitly needed for debugging
- [ ] No sensitive data in Crashlytics custom keys
- [ ] No relationship analytics in v1
