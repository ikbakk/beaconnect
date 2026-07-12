# Project Progress Checklist

> Last updated: 2026-07-10

## Code Implementation

### Slice 1 — First Reassurance
- [x] Auth (email, sign in, sign up)
- [x] Pairing (invite code, approve, mutual)
- [x] Home shell with partner card
- [x] I'm Okay (check-in) button
- [x] Updates entry

### Slice 2 — Real Place Snapshot
- [x] Manual snapshot capture
- [x] Current place display
- [x] Local cache
- [x] Freshness display (dynamic timestamps)
- [x] Place snapshot adds update entry

### Slice 3 — Widget
- [x] 4×2 widget preview screen
- [x] Cached partner state in widget
- [x] I'm Okay action from widget preview
- [x] Android home-screen widget plumbing (native)

### Slice 4 — Battery Saver Mode
- [x] Toggle battery saver
- [x] Honest freshness states
- [x] No aggressive polling

### Slice 5 — Live Sharing
- [x] Start / pause / resume / end lifecycle
- [x] Duration selection
- [x] Optional reason
- [x] Auto-expire expired sessions
- [x] Session state in home snapshot

### Slice 6 — Trust Center + My Beacon
- [x] Trust Center with privacy + history sections
- [x] My Beacon with preferences
- [x] Calmer loading/error states

### Slice 7 — Polish
- [x] Semantics/TalkBack labels on all interactive widgets
- [x] Reduced motion support
- [x] Calmer recovery and empty states
- [x] Updates screen empty state and ending message
- [x] Error states with retry buttons

### Security
- [x] Firestore rules hardened (users, pairs, events, invite codes, devices)
- [x] Invite codes one-time use (code-level)
- [x] Firebase actor IDs use real user ID
- [x] Crashlytics configured
- [ ] Cloud Function for invite expiry TTL
- [ ] Cloud Function for history retention (3 days)
- [ ] Shared deletion mutual approval

### Release Setup
- [x] CI workflow (analyze, test, build APK)
- [x] CHANGELOG.md
- [x] Firebase options (Android — real)
- [x] google-services.json (real)
- [ ] Debug SHA added
- [ ] Release SHA added
- [ ] Release signing config
- [ ] App Distribution configured
- [ ] Dev/staging/prod environment separation
- [ ] No debug logs audit
- [ ] Version bumped (current: 0.2.0+2)

### Firebase Services
- [x] Auth
- [x] Firestore
- [x] Crashlytics
- [ ] Cloud Messaging
- [ ] Remote Config
- [ ] App Distribution

### Functional Hardening
- [x] Runtime permission checks use device status
- [x] Permission request path works from onboarding and Trust Center
- [ ] Real current place capture uses device location
- [ ] Request Check-in uses pair-shared backend state

---

## Documentation

- [x] README updated to reflect current status
- [x] Roadmap updated (M4/M5 done, M6 in progress)
- [x] Changelog updated for 0.2.0
- [x] Project progress checklist created
- [ ] Firebase credentials doc updated
- [ ] Architecture diagrams
- [ ] Demo video
- [ ] Screenshots
- [ ] Case study
- [ ] SECURITY.md
- [ ] Issue templates (contribution guide)

---

## Testing

### Done
- [x] Auth repository (local)
- [x] Pairing repository (local)
- [x] Check-in cooldown use case
- [x] Request check-in cooldown use case
- [x] Place snapshot repository (local)
- [x] Live sharing repository (local)
- [x] My Beacon repository (local)
- [x] Battery saver repository (local)
- [x] Capture place snapshot use case
- [x] Home repository (partner name, freshness)
- [x] Widget test (onboarding + pairing + restore)

### Not Yet
- [ ] Queued check-in offline
- [ ] Pair code expiry
- [ ] Mutual approval
- [ ] Local cache display (full)
- [ ] Stale freshness display
- [ ] Live sharing pause timer continues
- [ ] History retention cleanup
- [ ] Golden tests (Partner Card, Home, Widget, Trust Center)
- [ ] Real current place capture test coverage
- [ ] Pair-shared request check-in test coverage

---

## Manual QA (requires device)

- [ ] App opens offline with cached state
- [ ] Home shows no spinner after first sync
- [ ] Check-in does not show sent until confirmed
- [ ] Offline check-in queues safely
- [ ] Live Sharing cannot start offline
- [ ] Invite code expires after 5 minutes
- [ ] Both users must approve pair
- [ ] No technical jargon appears
- [ ] No raw error messages
- [ ] Delayed state is calm
- [ ] Trust Center explains before action
- [ ] Widget is 4×2 and non-dashboard
- [ ] App recovers after process kill
- [ ] Widget shows cached state
- [ ] Background behavior does not drain battery aggressively
- [ ] Foreground service only used for Live Sharing

---

## Portfolio / Prepare Phase

- [x] README
- [x] Contributing guide
- [x] Code of conduct
- [x] Issue templates
- [x] PR template
- [x] Changelog
- [ ] Screenshots
- [ ] Case study
- [ ] Architecture diagrams
- [ ] Demo video
- [ ] SECURITY.md
- [ ] Public repo cleanup
